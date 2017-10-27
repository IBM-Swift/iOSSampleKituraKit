# How to Import KituraKit into an iOS Project

### File Structure

This folder contains the Swift code from [KituraKit](https://github.com/IBM-Swift/KituraBuddy) and the code for its dependencies to make a single module for importing into an iOS project. Swift Package Manager is not currently supported in iOS, these instructions provide a workaround so you can easily use KituraKit in iOS.

#### KituraKit

Client.swift and RequestErrorExtension.swift are taken from the sources files folder of the [KituraKit](https://github.com/IBM-Swift/KituraBuddy) repository with their import statements removed.

#### KituraKit dependencies

KituraKit depends on the following four modules:

[CircuitBreaker](https://github.com/IBM-Swift/CircuitBreaker), [LoggerAPI](https://github.com/IBM-Swift/LoggerAPI), [KituraContracts](https://github.com/IBM-Swift/SafetyContracts), [SwiftyRequest](https://github.com/IBM-Swift/SwiftyRequest)

Their source folders (with imports removed) have been added inside this KituraKit folder. This allows KituraKit to use them without needing additional imports.

### Importing KituraKit to an Xcode Project

1. Download KituraKit For iOS import from [KituraKit releases](https://github.com/IBM-Swift/KituraBuddy/releases). This should be a zipped binary file containing KituraKit, It's dependencies and this readme.

2. Extract the files from the Zip folder.

3. Open your Xcode project and click File -> New -> Target

4. Scroll to the bottom and select Cocoa Touch Framework

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddCocoaFramework.png" width="500" alt="Add Cocoa Framework">

5. Set product name to be "KituraKit", language to be Swift, Project to be your application and Embed in Application to be your application.

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/OptionsForAddFramework.png" width="400" alt="Options For Adding Framework">

6. in Xcode click on your project at the top of your file structure, click File -> add files to "project name"

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddFilesToProject.png" width="250" alt="Add files To Project">

7. in your finder go to where you unziped the kituraKit Folder, Select it, **click on options**, make sure Copy Items if needed, Create groups and add to targets KituraKit are selected. Add to targets ImportForiOS should **not** be selected

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/OptionsForAddFiles.png" width="400" alt="Options For Add Files">

8. Your final structure should then look like below. 

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/FinalFileStructure.png" width="200" alt="Final File Structure">

You can now use KituraKit by adding `import KituraKit` to the imports section for your project files.

### Updating KituraKit in an Xcode Project

To update your version of KituraKit you must first delete the Previous KituraKit.

1. Inside Xcode delete both KituraKit Folders

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/DeleteKituraKitFolders.png" width="300" alt="Delete KituraKit Folders">

2. Select your project from the top of the folders pane

3. Open the left menu pane and delete the KituraKit Target

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/DeleteKituraKitTarget.png" width="300" alt="Delete KituraKit Target">

4. Open finder and Ensure the KituraKit folder has been deleted from your project files. If it is still there, delete it.

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/DeleteKituraKitFolder.png" width="500" alt="Delete KituraKit Folder">

5. To update from a new zip folder go to "Importing KituraKit to an Xcode Project" and follow those steps with the updated KituraKit

6. To update files manually continue to Updating Files in KituraKit iOS Import

### Updating Files in KituraKit Bundle For iOS Import

To update files in this zip folder:

1. Get desired files from the sources folder of [KituraKit](http://github.com/IBM-Swift/KituraKit/tree/master/Sources/KituraKit), [CircuitBreaker](http://github.com/IBM-Swift/tree/master/Sources/CircuitBreaker), [LoggerAPI](http://github.com/IBM-Swift/LoggerAPI/tree/master/Sources/LoggerAPI), [KituraContracts](http://github.com/IBM-Swift/KituraContracts/tree/master/Sources/KituraContracts) and [SwiftyRequest](http://github.com/IBM-Swift/tree/master/Sources/SwiftyRequest)
2. Remove any import lines from new .swift files in KituraKit, SwiftyRequest and CircuitBreaker
3. Reimport your files following "Updating KituraKit in an Xcode Project"
