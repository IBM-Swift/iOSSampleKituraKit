# How to Import KituraKit into an iOS Project

### File Structure

This folder contains the Swift code from [KituraKit](https://github.com/IBM-Swift/KituraBuddy) and the code for its dependencies to make a single module for importing into an iOS project. Swift Package Manager is not currently supported in iOS, so we have provided instructions for use with CocoaPods. 

#### KituraKit

Client.swift and RequestErrorExtension.swift are taken from the sources files folder of the [KituraKit](https://github.com/IBM-Swift/KituraBuddy) repository with their import statements removed.

#### KituraKit dependencies

KituraKit depends on the following four modules:

[CircuitBreaker](https://github.com/IBM-Swift/CircuitBreaker), [LoggerAPI](https://github.com/IBM-Swift/LoggerAPI), [KituraContracts](https://github.com/IBM-Swift/SafetyContracts), [SwiftyRequest](https://github.com/IBM-Swift/SwiftyRequest)

Their source folders (with imports removed) have been added inside this KituraKit folder. This allows KituraKit to use them without needing additional imports.

### Importing KituraKit to an Xcode Project using CocoaPods

1. Download KituraKit from [KituraKit releases](https://github.com/IBM-Swift/KituraBuddy/releases).

2. Extract the files from the Zip folder into your app, this can be anywhere as long as the KituraKit directory exists in your app. This is becuase the Podfile we'll create later will use these local files and you'll need to provide a path to them. 

3. Open a terminal and navigate to the root of your iOS application (where the .xcodeproj is).

4. Run the `pod init` command in the terminal. This will create a Podfile in the current directory. 

5. Open the Podfile using your preferred text editor. 

6. You may need to set a global platform of iOS 11 for your project if your app has a deployment target of 11. To do so uncomment # platform :ios, '9.0' and set the value to 11.0

7. Under the line "# Pods for <Your-App-Name>". Add the following: 
`pod 'KituraKit', :path => ‘<Path-To-Your-KituraKit-Directory>’`

8. In the terminal run `pod install` this will install the KituraKit pod, and also generate you an xcodeworkspace. 

9. If you had your app open in Xcode as an Xcode project you need to close that and open the Xcode workspace. 

You can now use KituraKit by adding `import KituraKit` to the imports section for your project files.

### Updating KituraKit

To update your version of KituraKit you must first delete the Previous KituraKit.

1. Download the version of [KituraKit](https://github.com/IBM-Swift/KituraBuddy) you want to update to. 

2. Extract the files from the KituraKit.zip you've just downloaded.

3. Replace the current KituraKit directory found in your app with the newly extracted one. 
