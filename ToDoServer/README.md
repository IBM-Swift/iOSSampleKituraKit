# ToDoServer Component

### File Structure

The file structure matches what would be automatically generated using `kitura init`. This scaffold contains a few key files, along with a load of extras to help start any project as easily as possible. 

#### Sources

This folder contains the running programs files. It is split into /Application and /ToDoServer. The second folder matches the name of the project and is where main.swift is stored. This runs the application, and the /Application folder contains the Classes and Models that are used in the running application.

### Application.swift

This is where the majority of logic regarding the server lives. It defines routes available for the server, starts the server using `Kitura.run()` and also sets up handlers for a manner **RESTful requests**. The context of the request is inferred by a combination of the type of request (post, put, patch, delete or get) and the parameters given. The majority of the file is the handlers, there is also some environment setup at the start of the file for SwiftMetrics and Health. If you choose to include SwiftMetrics, navigating to https://localhost:8080/swiftmetrics-dash will show the servers activity as a live Dashboard.

Code Examples: 

`let options = Options(allowedOrigin: .all)` and `let cors = CORS(options: options)` allow CORS to work, which allows a testing suite called ToDo backend to run and test the server against some benchmarks.

The handlers found after the `run()` method are leveraging Codable routing and closures to handle incoming requests and return values. For example, the following method receives no input parameters, but returns either an Array of ToDo Objects or a ProcessHandlerError. The question marks mean that they are optional, but one will always be given depending on the task: 

```swift 
func getAllHandler(completion: ([ToDo]?, ProcessHandlerError?) -> Void ) -> Void {        completion(todoStore, nil) }
```

If a getAll message is recieved, even an empty array is a valid response hence the completion method always sends a nil error and the todoStore object. A more complex example is the createHandler method: 

```swift 
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
```
This method takes in a ToDo type called todo and stores it in a variable. It then checks the vars completed field, if none was set (so it was nil), its set to false. 

The ID is then set to be the size of the array storing all the ToDo's and its URL field is set using this number (the backend ToDo tests utilise this field). 

Finally, the object is appended onto the end of the store to keep it saved, and it is returned to signify that the process was a success. Error is returned as nil as a further indication that nothing went awry.

### Package.swift

This file works with Swift Package Manager, and gets remote repos and projects for you to use in your projects. It's contents for this app are typical, and its syntax is clear when dependencies. However, note that the targets must match **directory names** and then define all that folders files dependencies, or an empty array if it has no dependencies.

Examples:

```swift
.package(url: "https://github.com/IBM-Swift/Kitura.git", .branch("issue.swift4"))
```
defines a dependency called Kitura, on a specific branch swift 4 (new in Swift Package Manager 4). The targets section mirrors the file strucutre of the project, hence for this sample app it includes a ToDoServer  and an Application target. For example this is the ToDoServer target:

`.target(name: "ToDoServer", dependencies: [ .target(name: "Application"), "Kitura" , "HeliumLogger"])`

It shows that ToDoServer relies on 3 dependencies, the other target named Application as well as 2 others called Kitura and HeliumLogger.

### Models.swift

Swift 4 introduced a new protocol, **Codable**, which allows a swift type to be encoded on one end and decoded on the other, such as during a server request. This type retention means that code that **works on one side of a connection will work exactly the same on the other side**, alleviating the need for two teams to writet two version for the server and the client. The Models.swift file contains a struct called ToDo that conforms to the Codable protocol. 

ToDo Model explained:

```swift
public struct ToDo: Codable, Equatable {
    public static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return (lhs.title == rhs.title) && (lhs.user == rhs.user) && (lhs.order == rhs.order) && (lhs.completed == rhs.completed) && (lhs.url == rhs.url)
    }
    public var title: String?
    public var user: String?
    public var order: Int?
    public var completed: Bool?
    public var url: String?
    public init(title: String?, user: String?, order: Int?, completed: Bool?) {
        self.title = title
        self.user = user
        self.order = order
        self.completed = completed
        self.url = nil
    }
    
}
```

All the fields are optional because the PATCH method can choose to change only one property or all of them, and without them being optional, a full ToDo would need to be specified each time a PATCH request is made.

The URL is set to nil, as it is for the back end tests only and the iOS app makes no use of it.

The conformation to the protocol Codable ensures that if this ToDo type is used in the iOS app with the exact same fields, it can be decoded automatically on each side and the same methods will work on each end. This means less code needs to be rewritten and time can be saved, plus one team can write the whole thing at once.

The `public static func ==(lhs:, rhs:) -> Bool` method defines how two ToDo objects are compared against one another. If this wasn't implemented, the struct would not conform to Equatable.

For more information, visit: https://developer.apple.com/documentation/swift/codable.

### Main.swift

This simple file starts logging with HeliumLogger, and then creates an instance of the Application object before calling its run method. The running never halts as the server is always waiting for new connections and requests. Therefore any terminal window it runs in will be unable to repsond to new inputs, so opening a new window is needed for new commands. 

**HINT:** To cancel a running process in a terminal window, press CTRL + C.

### Metrics.swift, InitializationError.swift, and Routes/HealthRoutes.swift

These files provide logging and metrics for the running application. Health provied a succinct UP message in the browser window as JSON if a user navigates to http://localhost:8080/health. 

### Further Reading and Resources

https://docker.com

https://kitura.io

https://developer.apple.com/swift
