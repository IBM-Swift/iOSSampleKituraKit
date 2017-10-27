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

3. Drag the "KituraKit" folder from the finder into your Xcode project just below your xCode Project file.

4. A menu stating "Choose options for adding these files" should appear. Tick "copy items if needed", select "Create groups" and in add to target make sure your app is ticked.

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddingFilesToXcode.png" width="400" alt="Adding Files To Xcode">

5. Click on the folder and check the folder is yellow and the path in the right panel includes your project. If the path is incorrect go to "Updating KituraKit in an Xcode Project"

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/FirstFileStructure.png" width="200" alt="First File Structure">

6. In Xcode click File -> New -> Target

7. Scroll to the bottom and select Cocoa Touch Framework

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddCocoaFramework.png" width="500" alt="Add Cocoa Framework">

8. Set product name to be "KituraKit", language to be Swift, Project to be your application and Embed in Application to be your application.

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/OptionsForAddFramework.png" width="400" alt="Options For Adding Framework">

9. You should now see a second KituraKit folder with two files and KituraKit.framework Inside the Products folder

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/FileStructureWithFramework.png" width="200" alt="File Structure With Framework">

10.  Right click on the KituraKit folder containing all the KituraKit swift files and click "Add files to "project name"

   <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddFilesToiOSImport.png" width="300" alt="Add Files To iOSImport">

11. A menu inside KituraKit should appear. **Click options**, Ensure Copy Items if needed is ticked and create groups is selected. In add to targets only "project name" should be ticked

    <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/AddFilesOptions.png" width="500" alt="Add Files Options">

12. The final structure should look like the one below. 

    <img src="https://raw.githubusercontent.com/IBM-Swift/iOSSampleKituraKit/master/KituraiOS/KituraKit/ScreenshotsForReadmes/CompletedFileStructure.png" width="200" alt="Completed File Structure">

    ​

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

### Updating Files in KituraKit iOS Import

To update files in this zip folder:

1. Get desired files from the sources folder of [KituraKit](http://github.com/IBM-Swift/KituraKit/tree/master/Sources/KituraKit), [CircuitBreaker](http://github.com/IBM-Swift/tree/master/Sources/CircuitBreaker), [LoggerAPI](http://github.com/IBM-Swift/LoggerAPI/tree/master/Sources/LoggerAPI), [KituraContracts](http://github.com/IBM-Swift/KituraContracts/tree/master/Sources/KituraContracts) and [SwiftyRequest](http://github.com/IBM-Swift/tree/master/Sources/SwiftyRequest)
2. Remove any import lines from new .swift files in KituraKit, SwiftyRequest and CircuitBreaker
3. Reimport your files following "Updating KituraKit in an Xcode Project"
