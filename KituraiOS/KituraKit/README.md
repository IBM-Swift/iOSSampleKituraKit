# KituraKit iOS Import

### File Structure

This folder contains KituraKit and all of it's dependencies to make it a single module for importing into iOS projects. This allows for the module to be used with a single import in Xcode until swift package manager is supported.

#### KituraKit

Client.swift, PersistableExtension.swift and ProcesshandlerErrorExtension.swift are all taken from the sources files folder of the [KituraKit](https://github.com/IBM-Swift/KituraBuddy) repository with import statements removed.

#### KituraKit dependencies

KituraKit depends on the following four modules:

[CircuitBreaker](https://github.com/IBM-Swift/CircuitBreaker), [LoggerAPI](https://github.com/IBM-Swift/LoggerAPI), [KituraContracts](https://github.com/IBM-Swift/SafetyContracts), [SwiftyRequest](https://github.com/IBM-Swift/SwiftyRequest)

Their source files (with imports removed) have been added to this folder. This allows KituraKit to use them without needing additional imports.

### Importing KituraKit to an Xcode Project

1. Download KituraKit For iOS import from [KituraKit releases](https://github.com/IBM-Swift/KituraBuddy/releases). This should be a zipped binary file containing KituraKit, It's dependencies and this readme.
2. Extract the files from the Zip folder.
3. Drag the "KituraKit" folder from the finder into your Xcode project just below your xCode Project file.
4. A menu stating "Choose options for adding these files" should appear. Tick "copy items if needed", select "Create groups" and in add to target make sure your app is ticked.
5. Click on the folder and check the folder is yellow and the path in the right panel includes your project. If it is incorrect go to "Updating KituraKit in an Xcode Project"
6. In Xcode click File -> New -> Target
7. Scroll to the bottom and select Cocoa Touch Framework
8. Set product name to be "KituraKit", language to be Swift, Project to be your application and Embed in Application to be your application.
9. You should now see a second KituraKit folder with two files and KituraKit.framework Inside the Products folder
10.  Right click on the KituraKit folder containing all the KituraKit swift files and click "Add files to "project name""
11. A menu inside KituraKit should appear. Click options, Ensure Copy Items if needed is ticked and create groups is selected. In add to targets only "project name" should be ticked

You can now use KituraKit adding "import KituraKit" to your projects imports

### Updating KituraKit in an Xcode Project

To update your version of KituraKit you must first delete the Previous KituraKit.

1. Inside Xcode delete both KituraKit Folders
2. Select your project from the top of the folders pane
3. Open the left menu pane and delete the KituraKit Target
4. Open finder and Ensure the KituraKit folder has been deleted from your project files. If it is still there, delete it.
5. To update from a new zip folder go to "Importing KituraKit to an Xcode Project" and follow those steps with the updated KituraKit
6. To update files manually continue to Updating Files in KituraKit iOS Import

### Updating Files in KituraKit iOS Import

To update files in this zip folder:

1. Get desired files from the sources folder of [KituraKit](https://github.com/IBM-Swift/KituraBuddy), [CircuitBreaker](https://github.com/IBM-Swift/CircuitBreaker), [LoggerAPI](https://github.com/IBM-Swift/LoggerAPI), [KituraContracts](https://github.com/IBM-Swift/SafetyContracts) and [SwiftyRequest](https://github.com/IBM-Swift/SwiftyRequest)
2. remove any import lines from new .swift files in KituraKit, SwiftyRequest or CircuitBreaker

To change this module:
- add new files from CircuitBreaker/LoggerAPI/SafetyContracts/SwiftyRequest/KituraBuddy
- remove any import lines from the new .swift files in Kiturabuddy, SwiftyRequest or CircuitBreaker
- Reimport your files following "Updating KituraKit in an Xcode Project"
