/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Kitura
import KituraCORS
import Foundation
import KituraContracts
import LoggerAPI
import Configuration
import CloudEnvironment
import Health
import SwiftKuery
import SwiftKueryPostgreSQL
import SwiftKueryMySQL

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()
public var port: Int = 8080

public class Application {
    
    let router = Router()
    let cloudEnv = CloudEnv()
    let todotable = ToDoTable()
    //  To switch to a PostgreSQL database uncomment `PostgreSQLConnection` and comment out `MySQLConnection`
    //    let connection = PostgreSQLConnection(host: "localhost", port: 5432, options: [.databaseName("ToDoDatabase")])
    let connection = MySQLConnection(user: "swift", password: "kuery", database: "ToDoDatabase", port: 3306)
    
    // Terminal commands to start both databases can be found at the bottom of this file.
    
    func postInit() throws{
        // Capabilities
        initializeMetrics(app: self)
        
        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
        
        // Endpoints
        initializeHealthRoutes(app: self)
        
        // ToDoListBackend Routes
        router.post("/", handler: createHandler)
        router.get("/", handler: getAllHandler)
        router.get("/", handler: getOneHandler)
        router.delete("/", handler: deleteAllHandler)
        router.delete("/", handler: deleteOneHandler)
        router.patch("/", handler: updateHandler)
        router.put("/", handler: updatePutHandler)
        
    }
    
    
    public init() throws {
        // Configuration
        port = cloudEnv.port
    }
    
    public func run() throws{
        try postInit()
        Kitura.addHTTPServer(onPort: port, with: router)
        Kitura.run()
    }
    
    /**
     The createHandler function tells the server how to handle an HTTP POST request.
     It receives a ToDo object from the client and adds an unique identify and URL.
     The values from the ToDo object are then inserted into the mySQL database using SwiftKuery and SwiftKueryMySQL.
     It will return either, a ToDo object, with the RequestError being nil, or a RequestError,
     with the ToDo object being nil.
     */
    func createHandler(todo: ToDo, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        // Set a local ToDo object to equal the ToDo object received from the client.
        var todo = todo
        // If the received ToDo objects completed is nil set it to false
        todo.completed = todo.completed ?? false
        // The getNextId() function finds the next unused id number from the database.
        // This is assigned to todo and, since it is an option, it is unwrapped using guard.
        todo.id = getNextId()
        guard let id = todo.id else {return}
        todo.url = "http://localhost:8080/\(id)"
        // The server connects to the database. If it fails to connect it returns an .internalServerError
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                completion(nil, .internalServerError)
                return
            }
            // The insert query requires non-optional values so we unwrap the todo object.
            guard let title = todo.title, let user = todo.user, let order = todo.order, let completed = todo.completed, let url = todo.url else {
                print("assigning todo error: \(todo)")
                return
            }
            // an SQL insert query is created to insert the todo values into `todotable`.
            let insertQuery = Insert(into: todotable, values: [id, title, user, order, completed, url])
            // The insert query is executed and any errors are handled
            connection.execute(query: insertQuery) { queryResult in
                if let queryError = queryResult.asError {
                    // Something went wrong.
                    print("insert query error: \(queryError)")
                    completion(nil, .internalServerError)
                    return
                }
                // If there were no errors, the todo has been successfully inserted into the database
                // and we return the todo object to indicate success
                completion(todo, nil)
            }
        }
    }
    
    /**
     The getAllHandler function tells the server how to handle an HTTP GET request when you receive no parameters.
     It connects to the database, executes a SQL select query to get the todotable from the database and then fills
     a temporary ToDoStore with all the ToDos. If it has been successful, this function returns this array of ToDos
     with the requestError being nil. If there has been an error it will return the RequestError and nil for the ToDo array.
     */
    func getAllHandler(completion: @escaping ([ToDo]?, RequestError?) -> Void ) {
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                completion(nil, .internalServerError)
                return
            }
            else {
                // An SQL select query is created to read everything from the `todotable`.
                let selectQuery = Select(from :todotable)
                // The select query is executed and the returned results are processed.
                connection.execute(query: selectQuery) { queryResult in
                    // If the queryResult is a result set, iterate through the returned rows.
                    if let resultSet = queryResult.asResultSet {
                        // Create a local array of ToDo objects.
                        var tempToDoStore = [ToDo]()
                        for row in resultSet.rows {
                            // The rowToDo function parses a row from the database and returns either a ToDo object or nil is the parsing fails.
                            guard let currentToDo = self.rowToDo(row: row) else{
                                completion(nil, .internalServerError)
                                return
                            }
                            // Add the ToDo object to you ToDoStore.
                            tempToDoStore.append(currentToDo)
                        }
                        // If there were no errors, return the ToDoStore containing all the ToDos from the database.
                        completion(tempToDoStore, nil)
                    }
                    else if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("select query error: \(queryError)")
                        completion(nil, .internalServerError)
                        return
                    }
                }
            }
        }
    }
    
    /**
     The getOneHandler function tells the server how to handle an HTTP GET request when you receive an id as a parameter.
     It creates and executes an SQL select query for the received id to lookup if that id is present in the database.
     If it has been successful, this function returns the ToDo with the received id and nil for the requestError.
     If there has been an error it will return the RequestError and nil for the ToDo.
     If the id is not in the database, it will return nil for the ToDo and .notFound for the Request error.
     */
    func getOneHandler(id: Int, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                return
            }
            else {
                // An SQL select query is created and executed to return the row from the `todotable` where todotable.toDo_id == id.
                let selectQuery = Select(from :todotable).where(todotable.toDo_id == id)
                connection.execute(query: selectQuery) { queryResult in
                    // If the ToDo with that id is in the database you will receive on row containing that ToDo. Otherwise the sever response with .notFound.
                    var foundToDo: ToDo? = nil
                    if let resultSet = queryResult.asResultSet {
                        for row in resultSet.rows {
                            // If the ToDo exists, the foundToDo parses the returned row to a ToDo object.
                            foundToDo = self.rowToDo(row: row)
                        }
                        if foundToDo == nil {
                            completion(nil, .notFound)
                            return
                        }
                        // If the ToDo is fund it is returned by the server.
                        completion(foundToDo,nil)
                    }
                    else if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("select query error: \(queryError)")
                        completion(nil, .internalServerError)
                        return
                    }
                }
            }
        }
    }
    
    /**
     The deleteAllHandler function tells the server how to handle an HTTP DELETE request when you receive no parameters.
     It creates and executes an SQL delete query for all values in the `todotable`.
     If it has been successful, this function returns nil for the requestError.
     If there has been an error it will return the RequestError.
     */
    func deleteAllHandler(completion: @escaping (RequestError?) -> Void ) {
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                completion(.internalServerError)
                return
            }
            else {
                // An SQL delete query is created and executed to delete everything from the `todotable`.
                let deleteQuery = Delete(from :todotable)
                connection.execute(query: deleteQuery) { queryResult in
                    if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("delete query error: \(queryError)")
                        completion(.internalServerError)
                        return
                    }
                    // If there were no errors, return nil.
                    completion(nil)
                }
            }
        }
    }
    
    /**
     The deleteOneHandler function tells the server how to handle an HTTP DELETE request when you receive a ToDo id as the parameter.
     It creates and executes an SQL delete query for the received id in the `todotable`.
     If it has been successful, this function returns nil for the requestError.
     If there has been an error it will return the RequestError.
     */
    func deleteOneHandler(id: Int, completion: @escaping (RequestError?) -> Void ) {
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                return
            }
            else {
                // An SQL delete query is created and executed to delete the row from the `todotable` where id equals the received id.
                let deleteQuery = Delete(from :todotable).where(todotable.toDo_id == id)
                connection.execute(query: deleteQuery) { queryResult in
                    if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("delete one query error: \(queryError)")
                        completion(.internalServerError)
                        return
                    }
                    // If there were no errors, return nil.
                    completion(nil)
                }
                
            }
        }
    }
    
    /**
     The updateHandler function tells the server how to handle an HTTP PATCH request.
     It takes a ToDo id as the parameter and a ToDo object which will replace your existing ToDo values.
     It creates and executes an SQL Select query to get the current values for the ToDo.
     A new ToDo is then created by replacing the old ToDo values with any of the new ToDo values which are not nil.
     This updated ToDo is then sent back to the database using an SQL update query which replaces the old row with your new row (Similar to an HTTP PUT request).
     If this is successful, the server responds with the updated ToDo that was stored in the database and nil for the request error.
     If it was not successful it responds with the Request error and nil for the ToDo.
     */
    func updateHandler(id: Int, new: ToDo, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        // Create an array of Column to Any describing which fields will be updated
        var validFields: [(Column, Any)] = []
        // If the new ToDo has a value for a field, add that value to your valid fields
        if let title = new.title { validFields.append((self.todotable.toDo_title, title)) }
        if let user = new.user { validFields.append((self.todotable.toDo_user, user)) }
        if let order = new.order { validFields.append((self.todotable.toDo_order, order)) }
        if let completed = new.completed { validFields.append((self.todotable.toDo_completed, completed)) }
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                completion(nil, .internalServerError)
                return
            }
            else {
                // An SQL update query is created and executed to replace all valid fields in the table with your new values
                let updateQuery = Update(self.todotable, set: validFields).where(self.todotable.toDo_id == id)
                self.connection.execute(query: updateQuery) { queryResult in
                    if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("delete one query error: \(queryError)")
                        completion(nil, .internalServerError)
                        return
                    }
                    // If there were no errors, return the sent ToDo object.
                    completion(new, nil)
                }
            }
        }
    }
    
    /**
     The updatePutHandler function tells the server how to handle an HTTP PUT request.
     It takes a ToDo id as the parameter and a ToDo object which will replace your existing ToDo.
     A new ToDo is then created with the given id using the received values.
     This new ToDo is then sent to the database using an SQL update query which replaces the old row with the new row.
     If this is successful, the server responds with the new ToDo that was stored in the database and nil for the request error.
     If it was not successful it responds with the Request error and nil for the ToDo.
     */
    func updatePutHandler(id: Int, new: ToDo, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        // Connect to the database. If this fails return an internalServerError.
        connection.connect() { error in
            if error != nil {
                print("connection error: \(String(describing: error))")
                completion(nil, .internalServerError)
                return
            }
            else {
                // Create a new ToDo object from the received ToDo object with the given id.
                var returnedToDo: ToDo = new
                returnedToDo.id = id
                guard let title = new.title else {return}
                guard let user = new.user else {return}
                guard let order = new.order else {return}
                guard let completed = new.completed else {return}
                returnedToDo.url = "http://localhost:8080/\(id)"
                // Create an execute the update query to replace the old ToDo with the new ToDo.
                let updateQuery = Update(self.todotable, set: [(self.todotable.toDo_title, title),(self.todotable.toDo_user, user),(self.todotable.toDo_order, order),(self.todotable.toDo_completed, completed)]).where(self.todotable.toDo_id == id)
                self.connection.execute(query: updateQuery) { queryResult in
                    if let queryError = queryResult.asError {
                        // If the queryResult is an error return .internalServerError
                        print("delete one query error: \(queryError)")
                        completion(nil, .internalServerError)
                        return
                    }
                    // If there were no errors, return the new ToDo object.
                    completion(returnedToDo, nil)
                }
            }
        }
    }
    
    /**
     id is used as the primary key for the database and therefore, must be unique.
     When the server receives a ToDo it assigns an id and this function getNextId is used to find the next available id to assign.
     It does this by using a SQL select query to get the max id in the database and then returning the number 1 larger than that.
     
     This method is not safe across multiple clients as it creates race conditions. An abstraction for swift kuery is currently being developed to implement returning next available id and this will be updated once that is complete.
     */
    private func getNextId() -> Int {
        var nextId = 0
        connection.connect() { error in
            if error != nil {
                print("get id connection error")
                return
            }
            let maxIdQuery = Select(max(todotable.toDo_id) ,from: todotable)
            connection.execute(query: maxIdQuery) { queryResult in
                if let resultSet = queryResult.asResultSet {
                    for row in resultSet.rows {
                        guard let id = row[0] else{return}
                        guard let id32 = id as? Int32 else{return}
                        let idInt = Int(id32)
                        nextId = idInt + 1
                    }
                }
            }
        }
        return nextId
    }
    /**
     The function rowToDo takes in a row from the todotable and parses it to returns a ToDo object.
     */
    private func rowToDo(row: Array<Any?>) -> ToDo? {
        // mySQL and PostgreSQL store store Ints as Int 32 and so these must be cast to Int.
        guard let id = row[0], let id32 = id as? Int32 else{return nil}
        let idInt = Int(id32)
        guard let title = row[1], let titleString = title as? String else {return nil}
        guard let user = row[2], let userString = user as? String else {return nil}
        guard let order = row[3], let orderInt32 = order as? Int32 else {return nil}
        let orderInt = Int(orderInt32)
        // mySQL stores Bool as an Int8 that is either 0 or 1. PostgreSQL stores Bool as a Bool. To work with both databases we try and cast the Bool value to an Int8 and convert to a Bool. If this fails we assume it is being stored as a Bool and cast as Bool.
        guard let completed = row[4] else {return nil}
        var completedBool = true
        if let completedInt = completed as? Int8 {
            if completedInt == 0 {
                completedBool = false
            }
        } else {
            guard let completed = completed as? Bool else {return nil}
            completedBool = completed
        }
        guard let url = row[5], let urlString = url as? String else {return nil}
        // Once we have retrieved the ToDo values and unwrapped them we create and return our ToDo object.
        return ToDo(id: idInt, title: titleString, user: userString, order: orderInt, completed: completedBool, url: urlString)
    }
}


//Terminal commands to start mySQL toDoDatabase
//
//mysql_upgrade -uroot || echo "No need to upgrade"
//mysql -uroot -e "CREATE USER 'swift'@'localhost' IDENTIFIED BY 'kuery';"
//mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ToDoDatabase;"
//mysql -uroot -e "GRANT ALL ON ToDoDatabase.* TO 'swift'@'localhost';"
//mysql -uroot
//use ToDoDatabase
//CREATE TABLE toDoTable (
//    toDo_id INT NOT NULL,
//    toDo_title VARCHAR(50),
//    toDo_user VARCHAR(50),
//    toDo_order INT,
//    toDo_completed BOOLEAN,
//    toDo_url VARCHAR(50),
//    PRIMARY KEY ( toDo_id )
//);

//Terminal commands to start postgre toDoDatabase
//
//createdb ToDoDatabase
//psql ToDoDatabase
//
//CREATE TABLE toDoTable (
//    toDo_id integer primary key,
//    toDo_title varchar(50) NOT NULL,
//    toDo_user varchar(50) NOT NULL,
//    toDo_order integer NOT NULL,
//    toDo_completed boolean NOT NULL,
//    toDo_url varchar(50) NOT NULL
//);
