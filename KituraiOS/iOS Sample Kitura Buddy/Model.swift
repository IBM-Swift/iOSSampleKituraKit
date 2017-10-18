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
public struct Task: Codable, Equatable {
    public let id: UInt
    public let task: String
    public init(id: UInt, task: String) {
        self.id = id
        self.task = task
    }
    
    public static func ==(lhs: Task, rhs: Task) -> Bool {
        return (lhs.id == rhs.id) && (lhs.task == rhs.task)
    }
    
}

let initialStore = [
    "1": Task(id: 1, task: "Bring milk and bread"),
    "2": Task(id: 2, task: "Mow the lawn"),
    "3": Task(id: 3, task: "File taxes"),
    "4": Task(id: 4, task: "Clean the garage")
]
