# Kitura 2 Sample App - ToDo List

[![Build Status](https://travis-ci.org/IBM-Swift/iOSSampleKituraBuddy.svg?branch=master)](https://travis-ci.org/IBM-Swift/iOSSampleKituraBuddy)

### Prequisites

* Xcode 9 or later running on macOS 10.12 or later

### Installation

* Open a terminal window and clone this repo to your machine.
* Run `swift build` to create the backend server, and launch it with the follow command: `.build/x86_64-apple-macosx10.10/debug/ToDoServer`.
  * It may ask for permission for incoming connections. Select "Allow"
* Open a new terminal window and back to the root of the project, and navigate to KituraiOS, and launch the Xcode Project. A new window is needed because the Server never returns (it runs forever listening for connections).
  * Ensure the Target Scheme next to the Run button at the top is on the iOS app with the app icon.
* Press ▶️ at the top next to schemes, or ⌘+R does the same thing. Make sure an iPhone is selected as the Simulator in the drop down menu next to the run button.
