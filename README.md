<h1 align="center"> Kitura 2 Sample App - ToDo List with Database Persistence </h1>

<p align="center">
<img src="https://www.ibm.com/cloud-computing/bluemix/sites/default/files/assets/page/catalog-swift.svg" width="120" alt="Kitura Bird">
</p>

<p align="center">
<a href="https://travis-ci.org/IBM-Swift/iOSSampleKituraKit">
<img src="https://travis-ci.org/IBM-Swift/iOSSampleKituraKit.svg?branch=master" alt="Travis CI">
</a>
<a href= "http://swift-at-ibm-slack.mybluemix.net/">
<img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg"  alt="Slack">
</a>
</p>

PersistentiOSKituraKit provides an example of the todo list application [iOSSampleKituraKit](https://github.com/IBM-Swift/iOSSampleKituraKit), which has been connected to a MySQL database. This means that, if the server is restarted, the data will persist inside the database. The server handles all communcation the database, so for technical details and example code on how  persistence has been added, view the [ToDoServer README](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/persistentiOSKituraKit/ToDoServer) .

### Quick Start*
1. Install MySQL

`brew install mysql`

2. Start the MySQL server

`mysql.server start`

3. Create and configure a database called ToDoDatabase

```
mysql -uroot -e "CREATE USER 'swift'@'localhost' IDENTIFIED BY 'kuery';"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ToDoDatabase;"
mysql -uroot -e "GRANT ALL ON ToDoDatabase.* TO 'swift'@'localhost';"
```
4. Create a table called toDoTable in the database

```
mysql -uroot;
use ToDoDatabase;
CREATE TABLE toDoTable (
    toDo_id INT NOT NULL,
    toDo_title VARCHAR(50),
    toDo_user VARCHAR(50),
    toDo_order INT,
    toDo_completed BOOLEAN,
    toDo_url VARCHAR(50),
    PRIMARY KEY ( toDo_id )
);
```

5. Exit MySQL using `\q`

6. Ensure [Xcode 9](https://itunes.apple.com/gb/app/xcode/id497799835) or later is installed.

7. Clone this repository:

`git clone https://github.com/IBM-Swift/iOSSampleKituraKit.git`

8. Navigate into the [ToDoServer folder](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/persistentiOSKituraKit/ToDoServer) using:

`cd iOSSampleKituraKit/ToDoServer/`

9. Switch to the persistentiOSKituraKit branch:

`git checkout persistentiOSKituraKit`

10. Run the following command to compile and run the server:

`swift run -Xlinker -L/usr/local/lib`

"-Xlinker -L/usr/local/lib" is required to point swift at the linker for mySQL

**Note:** This command will start the server and it will listen for new connections forever, so the terminal window will be unable to take new commands while the server is running.

11. Open new Terminal window and navigate into the [KituraiOS folder](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/persistentiOSKituraKit/KituraiOS) using:

`cd iOSSampleKituraKit/KituraiOS`

12. Open the iOSKituraKitSample.xcworkspace file with:

`open iOSKituraKitSample.xcworkspace`

13. Ensure that the Scheme in Xcode is set to the iOS Application. The Scheme selection is located along the top of the Xcode window next to the Run and Stop buttons. If you don't see a Kitura icon (white and blue) in the box next to the Stop button, click the icon that's there and select the App from the drop down menu.

14. Make sure an iPhone X is selected in the drop down menu next to the Scheme, not "Generic iOS Device". The iPhone Simulators all have blue icons next to their names. iPad is not supported at this time.

15. Press the Run button or ⌘+R. The project will build and the simulator will launch the application. Navigate your web browser to the address http://localhost:8080 to see an empty array. This is where ToDos made in the app are stored. As you add or delete elements in the app, this array will change.

*The Kitura component can be run on Linux or macOS. Xcode is not required for running the Kitura server component (Xcode is only required for the iOS component).

16. You now have a todolist application, running on a simulated iPhone. You can add, delete and edit todo items in the app and then view your changes on the server at [localhost:8080](http://localhost:8080/). Since there is a database connected, you can restart both the application and the server but any todolist items you have created will persist!

The server is responsible for all database communication and logic so for technical details and code go to the [ToDoServer](https://github.com/IBM-Swift/iOSSampleKituraKit/tree/persistentiOSKituraKit/ToDoServer) . The server README will descibes the components required for adding persistence and within the `application.swift` file you will find code examples of HTTP requests from the application being converted to SQL queries to the database.
