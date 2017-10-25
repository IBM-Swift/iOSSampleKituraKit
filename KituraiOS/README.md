# Kitura 2 App Component

### Usage

This directory of the repo was created to store and demonstrate that the iOS component can work with the server. It uses a new Kitura client side library called **KituraKit**. The `.xcodeproj` file loads up the XCode project with the files and corresponding structure. To run the iOS app on a simulator, select the iOS Sample KituraKit scheme with the chosen simulator (iPhone X for example), and click the play button on the top left of the XCode window (or `CMD + R`). This will start the app on the simulator, functionality with the Kitura server will only be present after the server has already been started.

### File Structure

The file structure contains the iOS sample project along with KituraKit, which contains the relevant files needed within the app itself for type-safe routing.

#### KituraKit

This folder contains the client library for Kitura, which has further dependancies that are necessary to the functionality of the app. More information can be found here: https://github.com/IBM-Swift/iOSSampleKituraKit/blob/master/KituraiOS/KituraKit/README.md.

#### iOS Sample KituraKit

This folder contains the main app files used to create the app's UI and functionality, along with storyboard files. The ViewController.swift file is the first file that gets called from the AppDelegate.swift file, which is the entry point for the ToDo List app.

### AppDelegate.swift

This is the app's entry point, which handles the app state and what should occur when the app loads or exits.

### ViewController.swift

This is where the majority of logic regarding the app lives. It creates the client using `let client = KituraKit(baseURL: "http://localhost:8080")` which is called from KituraKit. The file also sets up and creates the UI elements including the table view, search bar, and other buttons that exist on the app screen.

The table is initially populated with data from the server using the `self.readAll()` function, which is present in the TypeSafeRouting.swift file (an extension of ViewController.swift). This stores data in the Model.swift file in a struct called LocalToDo, containing an array of ToDo items. The table view accesses this data by its index path and displays the relevant data in an easily readable format. Swiping the cell left presents the option to delete the respective cell's data from the server, which is done via a `self.delete(url: url)` method, where the url is passed in from the LocalToDo store at the respective index path. Swiping right allows the user to either mark the task as completed or uncompleted, which calls a patch method via `self.update(title: titleToSend, user: userToSend, order: orderToSend, completed: true, url: url)`, where the parameters are dependant on the cell in question. Tapping a cell also performs a patch function after presenting an alert with text fields, allowing the user to change and amend either their task name or user name.

The search bar allows users to input an identifier that's associated with each ToDo item, which will return the corresponding task name in a pop up. Searching makes use of the `self.read(Id: searchStringToSend)` function, where the identifier is passed in as a parameter. If an item does not exist, the pop up alerts the user that the item could not be found.

### DataInputViewController.swift

This file is called when the user segues into the screen to add new ToDo items by tapping the plus icon in the top right of the initial screen. The user is presented with two fields, accepting the task name and a user name, along with a save button that calls the `create(title: title, user: user, order: orderAsInt)` function when it is tapped. This takes in data from the fields as parameters, and the cell order as the order identifier, and creates the ToDo item on the server. The user is returned back to the initial screen after this is completed.

### CodableRouting.swift

The app's core functionality lies here, leveraging KituraKit to send and receive data from the server, along with other functions such as patching and deleting.

The first function present is to create a new ToDo item on the server. The below code illustrates how a post method is called on the client using the parameters that have been passed in, which throws an error if the item failed to be created:

```swift
func create(title: String, user: String, order: Int) {
  let newToDo = ToDo(title: title, user: user, order: order, completed: false)
  self.client?.post("/", data: newToDo) { (returnedItem: ToDo?, error: Error?) -> Void in
    print(String(describing: returnedItem))
    guard returnedItem != nil else {
      print("Error in creating ToDo. error code \(String(describing:error))")
      return
    }
  }
}
```

The next function allows all content from the server to be read. This shows a get function being called on the client. No parameters are passed in as it responds with all data present on the root path. All data that is returned has to conform to the ToDo item, and is added to the LocalToDo struct in the Model.swift file:

```swift
func readAll() {
  self.client?.get("/") { (allToDoItems: [ToDo]?, error: Error?) -> Void in
    guard let allToDoItems = allToDoItems else {
      print("Error in reading user. error code \(String(describing:error))")
      return
    }
    DispatchQueue.main.async {
      localToDo.localToDoStore = allToDoItems
      self.tableView.reloadData()
    }
  }
}
```

Another read function also exists, which returns one item depending on the identifier passed in. The below code portrays a get function on the client similar to the previous function, however this also takes in an identifier and returns a single ToDo item rather than an array of items. As this is called from a search function, the response is added to a popup alert view and displayed to the user:

```swift
func read(Id: String) {
  let encoded = Id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
  let decoded = encoded.removingPercentEncoding
  guard let Id = decoded else {
    return
  }

  self.client?.get("", identifier: Id) { (returnedToDo: ToDo?, error: Error?) -> Void in
    guard let _ = returnedToDo else {
      DispatchQueue.main.async {
        print("Error in reading user. error code \(String(describing:error))")
        let alert = UIAlertController(title: "Search result", message: "Not Found", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
      return
    }
    if let returnedToDo = returnedToDo {
      DispatchQueue.main.async {
        guard let title = returnedToDo.title else {return}
        let alert = UIAlertController(title: "Search result", message: title, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}
```

An update is performed via a patch function. This shows how a patch is called on the client to replace respective components in the ToDo item depending on the data passed in. The `self.readAll()` function is called at the end to get data from the server again and populate the table:

```swift
func update(title: String?, user: String?, order: Int?, completed: Bool?, url: String) {
  let urlArray = url.split(separator: "/")
  guard let urlEndOfArray = urlArray.last else {return}
  guard let urlToSend = Int(urlEndOfArray) else{return}
  print("url to send: \(String(describing:urlToSend))")

  let encoded = String(describing:urlToSend).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
  let decoded = encoded.removingPercentEncoding
  guard let Id = decoded else {
    return
  }

  let newToDo = ToDo(title: title, user: user, order: order, completed: completed)
  print("updateToDo: \(newToDo)")
  self.client?.patch("", identifier: Id, data: newToDo) { (returnedToDo: ToDo?, error: Error?) -> Void in
    guard let _ = returnedToDo else {
      print("Error in patching ToDo. error code \(String(describing:error))")
      return
    }
    print("reached patch response: \(String(describing:returnedToDo))")
    self.readAll()
  }
}
```

All data can be deleted from the server. This function doesn't take in any parameters as it performs a delete on the root path, removing all data.:

```swift
func deleteAll() {
  self.client?.delete("") { error in
    guard error == nil else {
      return
    }
    self.readAll()
  }
}
```

Finally, the user can choose to delete specific data dependant on the identifier passed in. The below code performs a delete function on the client too, however it takes in an identifier as a parameter, enabling the specified ToDo item on the server to be deleted:

```swift
func delete(url: String) {
  let urlArray = url.split(separator: "/")
  guard let urlEndOfArray = urlArray.last else {return}
  guard let urlToSend = Int(urlEndOfArray) else{return}
  print("url to delete \(urlToSend)")
  self.client?.delete("", identifier: urlToSend) { error in
    guard error == nil else {
      print("delete error: \(String(describing : error))")
      return
    }
    self.readAll()
  }
}
```

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

Another struct by the name of LocalToDo also exists, acting as a local store for all data received from the server via the `self.readAll()` function, and accessed when populating the table with data. This contains an array called localToDoStore, which accepts items of the ToDo type.

```swift
public struct localToDo {
  static var localToDoStore = [ToDo]()
}
```

### Main.storyboard

A few of the visual UI elements are laid out here, with segues between view controllers.

### Further Reading and Resources

https://docker.com

https://kitura.io

https://developer.apple.com/swift

