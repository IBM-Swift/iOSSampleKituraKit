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

import Kitura
import Foundation
import Models
import SafetyContracts

public class Controller {
    
    public typealias Key = String
    
    public let router: Router
    
    private var taskStore: [Key: Task] = [:]
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(taskStore: [Key: Task] = [:]) {
        self.taskStore = taskStore
        router = Router()
        setupRoutes()
        
    }
    
    private func setupRoutes() {
        
        // task routes
        router.get("/tasks") { (resondWith: ([Task]?, ProcessHandlerError?) -> Void) in
            let tasks = self.taskStore.map({ $0.value })
            resondWith(tasks, nil)
        }
        
        router.get("/tasks") { (id: Int, resondWith: (Task?, ProcessHandlerError?) -> Void) in
            guard let task = self.taskStore[String(id)] else {
                resondWith(nil, .notFound)
                return
            }
            resondWith(task, nil)
        }
        
        router.post("/tasks") { (task: Task?, respondWith: (Task?, ProcessHandlerError?) -> Void) in
            guard let task = task else {
                respondWith(nil, .badRequest)
                return
            }
            self.taskStore[String(task.id)] = task
            respondWith(task, nil)
        }
        
        router.put("/tasks") { (id: Int, task: Task?, respondWith: (Task?, ProcessHandlerError?) -> Void) in
            self.taskStore[String(id)] = task
            respondWith(task, nil)
        }
        
        router.patch("/tasks") { (id: Int, task: TaskOptional?, respondWith: (Task?, ProcessHandlerError?) -> Void) in
            guard let exisitingTask = self.taskStore[id.value] else {
                respondWith(nil, .notFound)
                return
            }
            if let taskName = task?.task {
                let updatedTask = Task(id: UInt(id), task: taskName)
                self.taskStore[id.value] = updatedTask
                respondWith(updatedTask, nil)
            } else {
                respondWith(exisitingTask, nil)
            }
        }
        router.delete("/tasks") { (id: Int, respondWith: (ProcessHandlerError?) -> Void) in
            guard let _ = self.taskStore.removeValue(forKey: id.value) else {
                respondWith(.notFound)
                return
            }
            respondWith(nil)
        }
        
        router.delete("/tasks") { (respondWith: (ProcessHandlerError?) -> Void) in
            self.taskStore.removeAll()
            respondWith(nil)
        }
    }
    
    
}
