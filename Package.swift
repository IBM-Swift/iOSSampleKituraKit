// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import PackageDescription

let package = Package(
    name: "ToDoServer",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .branch("issue.swift4")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.1")),
        .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .upToNextMinor(from: "4.0.5")),
        .package(url: "https://github.com/IBM-Swift/Configuration.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Health.git", from: "0.0.0"),
        .package(url: "https://github.com/IBM-Swift/SafetyContracts.git", .exact("0.0.9")),
        .package(url: "https://github.com/IBM-Swift/Kitura-CORS", .upToNextMinor(from: "1.7.0")),
        ],
    targets: [
        .target(name: "ToDoServer", dependencies: [ .target(name: "Application"), "Kitura" , "HeliumLogger"]),
        .target(name: "Application", dependencies: [ "SafetyContracts", "Kitura", "KituraCORS", "Configuration", "CloudEnvironment", "Health" , "SwiftMetrics",
         ]),
        ]
)

