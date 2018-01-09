# ToDoServer Component

### PersistentiOSKituraKit
The server component from [iOSSampleKituraKit](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/master/ToDoServer) has been adapted to store data in a MySQL database so that, if the server is restarted, the data is stored and will persist.

### File Structure

The file structure matches what would be automatically generated using `kitura init`. This scaffold contains a few key files, along with a load of extras to help start any project as easily as possible.

#### Sources

This folder contains the running programs files. It is split into /Application and /ToDoServer. The second folder matches the name of the project and is where `main.swift` is stored. This runs the application, and the /Application folder contains the Classes and Models that are used in the running application.

### Application.swift

This is where the majority of logic regarding the server lives. It defines routes available for the server, starts the server using `Kitura.run()` and sets up handlers to determine how the server reacts when it receives a **RESTful request**. The context of the request is inferred by a combination of the type of request (post, put, patch, delete or get) and the parameters given. There is also some environment setup at the start of the file for SwiftMetrics and Health. If you choose to include SwiftMetrics, navigating to https://localhost:8080/swiftmetrics-dash will show the servers activity as a live Dashboard.

#### PersistentiOSKituraKit Additions

1. [Swift Kuery](https://github.com/IBM-Swift/Swift-Kuery) and [Swift-Kuery-MySQL](https://github.com/IBM-Swift/SwiftKueryMySQL) are imported
```swift
import SwiftKuery
import SwiftKueryMySQL
```
2. An Instance of the ToDoTable class is created.
```swift
let todotable = ToDoTable()
```
3. The server is connected to the database.
```swift
let connection = MySQLConnection(user: "swift", password: "kuery", database: "ToDoDatabase", port: 3306)
```

4. Handlers for server routes are changed to send and recieve data from the database.

Every HTTP request received from the server is given a corresponding SQL query.

For example the `createHandler` responds to an HTTP `POST` request from the application. The server will now perform an SQL `INSERT` with the received data to store this in the database:
```swift
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
```
To view the other handlers, look inside the [Application.swift](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/persistentiOSKituraKit/ToDoServer/Sources/Application/Application.swift) file.

### Package.swift

This file works with Swift Package Manager, and gets remote repos and projects for you to use in your projects.

#### PersistentiOSKituraKit Additions

1. To use MySQL, `SwiftKueryMySQL` has been added to the list of packages

```swift
.package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", .upToNextMinor(from: "1.0.0")),
```
2.  `SwiftKueryMySQL` is also added to the targets for  `Application`
```swift
.target(name: "Application", dependencies: [ "Kitura", "KituraCORS", "CloudEnvironment", "Health" , "SwiftMetrics", "SwiftKueryMySQL"]),
```

### Models.swift

Inside `Models.swift`, a class matching the database table, is created.

```
public class ToDoTable : Table {
    let tableName = "toDoTable"
    let toDo_id = Column("toDo_id")
    let toDo_title = Column("toDo_title")
    let toDo_user = Column("toDo_user")
    let toDo_order = Column("toDo_order")
    let toDo_completed = Column("toDo_completed")
    let toDo_url = Column("toDo_url")
}
```

### Main.swift

This simple file starts logging with HeliumLogger, and then creates an instance of the Application object before calling its run method. The running never halts as the server is always waiting for new connections and requests. Therefore any terminal window it runs in will be unable to respond to new inputs, so opening a new window is needed for new commands.

**HINT:** To cancel a running process in a terminal window, press CTRL + C.

### Switching to PostgreSQL
This project used a MySQL database to store the data from the server. Since [Swift-Kuery-MySQL](https://github.com/IBM-Swift/SwiftKueryMySQL) is build upon the [Swift Kuery](https://github.com/IBM-Swift/Swift-Kuery) abstraction layer, you can easily switch between mySQL and other supported SQL databases, such a PostgreSQL.

1. Start the PostgreSQL database:

`brew install postgresql`
`brew services start postgresql`

2. Create a database and open postgreSQL command line:

`createdb ToDoDatabase`
`psql ToDoDatabase`

3. Create a ToDo item table:

```
CREATE TABLE toDoTable (
    toDo_id integer primary key,
    toDo_title varchar(50),
    toDo_user varchar(50),
    toDo_order integer,
    toDo_completed boolean,
    toDo_url varchar(50)
);
```
4. In the Application.swift file,  remove the mySQL connection and replace it with:
```swift
let connection = PostgreSQLConnection(host: "localhost", port: 5432, options: [.databaseName("ToDoDatabase")])
```

Now, when you run the server, it will connect to your PostgreSQL database instead of the MySQL database.

### Metrics.swift, InitializationError.swift, and Routes/HealthRoutes.swift

These files provide logging and metrics for the running application. Health provides a JSON availability message when a user navigates to http://localhost:8080/health.

### Further Reading and Resources

https://docker.com

https://kitura.io

https://developer.apple.com/swift

