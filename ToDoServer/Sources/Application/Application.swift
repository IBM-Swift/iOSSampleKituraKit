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
import SafetyContracts
import LoggerAPI
import Configuration
import CloudEnvironment
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()
public var port: Int = 8080

public class Application {
    
    let router = Router()
    let cloudEnv = CloudEnv()
    var todoStore = [ToDo]()
    
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
        router.patch("/", handler: updatePutHandler)
        
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
    
    func createHandler(todo: ToDo, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        var todo = todo
        if todo.completed == nil {
            todo.completed = false
        }
        let id = todoStore.count
        todo.url = "http://localhost:8080/\(id)"
        todoStore.append(todo)
        completion(todo, nil)
    }
    
    func getAllHandler(completion: ([ToDo]?, ProcessHandlerError?) -> Void ) -> Void {
        completion(todoStore, nil)
    }
    
    func getOneHandler(id: Int, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        completion(todoStore[id], nil)
    }
    
    func deleteAllHandler(completion: (ProcessHandlerError?) -> Void ) -> Void {
        todoStore = [ToDo]()
        completion(nil)
    }
    
    func deleteOneHandler(id: Int, completion: (ProcessHandlerError?) -> Void ) -> Void {
        todoStore.remove(at: id)
        completion(nil)
    }
    
    func updateHandler(id: Int, new: ToDo, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        var current = todoStore[id]
        current.user = new.user ?? current.user
        current.order = new.order ?? current.order
        current.title = new.title ?? current.title
        current.completed = new.completed ?? current.completed
        todoStore[id] = current
        completion(todoStore[id], nil)
    }
    
    func updatePutHandler(id: Int, new: ToDo, completion: (ToDo?, ProcessHandlerError?) -> Void ) -> Void {
        var current = todoStore[id]
        current.user = new.user
        current.order = new.order
        current.title = new.title
        current.completed = new.completed
        todoStore[id] = current
        completion(todoStore[id], nil)
    }
    
}

