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
        router.get("/tasks") { (resondWith: ([User]?, ProcessHandlerError?) -> Void) in
            let users = self.taskStore.map({ $0.value })
            resondWith(users, nil)
        }
        
        router.get("/tasks") { (id: Int, resondWith: (User?, ProcessHandlerError?) -> Void) in
            guard let user = self.taskStore[String(id)] else {
                resondWith(nil, .notFound)
                return
            }
            resondWith(user, nil)
        }
        
        router.post("/tasks") { (user: User?, respondWith: (User?, ProcessHandlerError?) -> Void) in
            guard let user = user else {
                respondWith(nil, .unprocessableEntity)
                return
            }
            respondWith(user, nil)
        }
        router.post("/tasks", handler: addUser)
        router.put("/tasks/:id", handler: addUser)
        router.patch("/tasks/:id", handler: updateUser)
        router.delete("/tasks/:id", handler: deleteUser)
        router.delete("/tasks", handler: deleteAll)
    }
    
    
    public func addUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        defer {
            next()
        }
        do {
            var data = Data()
            _ = try request.read(into: &data)
            let user = try decoder.decode(Task.self, from: data)
            taskStore[String(user.id)] = user
            response.status(.OK).send(data: data)
        } catch {
            response.status(.unprocessableEntity)
        }
    }
    
    public func updateUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        defer {
            next()
        }
        guard let id = request.parameters["id"] else {
            response.status(.badRequest)
            return
        }
        do {
            var data = Data()
            _ = try request.read(into: &data)
            let user = try decoder.decode(Task.self, from: data)
            taskStore[id] = user
            response.status(.OK).send(data: data)
        } catch {
            response.status(.unprocessableEntity)
        }
    }
    
    public func deleteAll(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        taskStore = [:]
        response.status(.OK)
    }
    
    public func deleteUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        defer {
            next()
        }
        
        guard let id = request.parameters["id"] else {
            response.status(.badRequest)
            return
        }
        
        taskStore[id] = nil
        response.status(.OK)
    }
}
