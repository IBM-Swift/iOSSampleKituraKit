<h1 align="center"> Kitura 2 Sample App - ToDo List </h1>

<p align="center">
<img src="https://www.ibm.com/cloud-computing/bluemix/sites/default/files/assets/page/catalog-swift.svg" width="120" alt="Kitura Bird">
</p>

<p align="center">
<a href="https://travis-ci.org/IBM-Swift/iOSSampleKituraKit">
    <img src="https://travis-ci.org/IBM-Swift/iOSSampleKituraBuddy.svg?branch=master" alt="Travis CI">
</a>
<a href= "http://swift-at-ibm-slack.mybluemix.net/"> 
    <img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg"  alt="Slack"> 
</a>
</p>


[Kituta is a lightweight and simple web framework](http://kitura.io) that makes it easy to set up complex web routes for web services and applications. 

ToDo List demonstrates how Kitura 2s new Type Safe Routing features can help developers leverage Swift 4's Codable protocol and write code that works on both the front and back end. A new client library is used in the app called [KituraKit](https://github.com/IBM-Swift/KituraBuddy), which is open source so feel free to contribute! 

It is built against a set of [ToDoBackend tests](http://www.todobackend.com/) to showcase the power of Kitura 2 and its API.



### Quick Start for macOS*

1. Install [Xcode 9](https://itunes.apple.com/gb/app/xcode/id497799835) or later.

2. Clone this repository:

    `git clone https://github.com/IBM-Swift/iOSSampleKituraKit.git`

3. Navigate into the [ToDoServer folder](https://github.com/IBM-Swift/iOSSampleKituraBuddy/tree/master/ToDoServer) using: 

    `cd ToDoServer/`

4. Run the following commands to compile the code:

    `swift build`
  
5. Start the server with: 

    `.build/x86_64-apple-macosx10.10/debug/ToDoServer`

**Note:** This command will start the server and it will listen for new connections forever, so the terminal window will be unable to take new commands while the server is running. Opening a new Terminal window will let you continue with the Quick Start. For more info on the Server component, [click here](https://github.com/IBM-Swift/iOSSampleKituraBuddy/blob/master/ToDoServer/README.md)

6. Navigate into the [KituraiOS folder](https://github.com/IBM-Swift/iOSSampleKituraBuddy/tree/master/KituraiOS) using:

    `cd ../KituraiOS`

7. Open the iOS Sample Kitura Buddy.xcodeproj file with:

    `open iOSKituraKitSample.xcodeproj`

A new Xcode window will open. For more info on the iOS app, [click here](https://github.com/IBM-Swift/iOSSampleKituraKit/blob/master/KituraiOS/README.md)

8. Ensure that the Scheme in Xcode is set to the iOS Application. The Scheme selection is located along the top of the Xcode window next to the Run and Stop buttons. If you don't see a Kitura icon (white and blue) in the box next to the Stop button, click the icon that's there and select the App from the drop down menu.

9. Make sure an iPhone X is selected in the drop down menu next to the Scheme, not "Generic iOS Device". The iPhone Simulators all have blue icons next to their names. iPad is not supported at this time.

10. Press the Run button or ⌘+R. The project will build and the simulator will launch the application. Navigate your web browser to the address http://localhost:8080 to see an empty array. This is where ToDos made in the app are stored. As you add or delete elements in the app, this array will change.

*Not available on other platforms due to the iOS App section of the project, which requires Xcode running on macOS.
