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

import Foundation

// Models/entities (application/use case specific)
//public struct Task: Codable, Equatable {
//    public let id: UInt
//    public let task: String
//    public init(id: UInt, task: String) {
//        self.id = id
//        self.task = task
//    }
//
//    public static func ==(lhs: Task, rhs: Task) -> Bool {
//        return (lhs.id == rhs.id) && (lhs.task == rhs.task)
//    }
//
//}

public struct ToDo: Codable, Equatable {
    public static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return (lhs.title == rhs.title) && (lhs.user == rhs.user) && (lhs.order == rhs.order) && (lhs.completed == rhs.completed) && (lhs.url == rhs.url)
    }
    public let title: String?
    public let user: String?
    public let order: Int?
    public let completed: Bool?
    public let url: String?
    public init(title: String?, user: String?, order: Int?, completed: Bool?) {
        self.title = title
        self.user = user
        self.order = order
        self.completed = completed
        self.url = nil
    }
    
}


let initialStore = [
    "1": ToDo(title: "Bring milk and bread", user: "Andy", order: 2, completed: false),
    "2": ToDo(title: "Mow the lawn", user: "Kye", order: 1, completed: false),
    "3": ToDo(title: "File taxes", user: "Shihab", order: 4, completed: false),
    "4": ToDo(title: "Clean the garage", user: "Andy", order: 3, completed: false)
]
