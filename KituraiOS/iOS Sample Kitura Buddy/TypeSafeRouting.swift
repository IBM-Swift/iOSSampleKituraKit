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
import UIKit

extension ViewController {
    
    func create(textID: String, textName: String) {
        print("create function called")
        guard let userID = UInt(textID) else {
            print("\(textID) is not a valid ID. Must be a positive Integer")
            return
        }
        let newTask = Task(id: userID, task: textName)
        print("task created: \(newTask)")
        self.client.post("/tasks", data: newTask) { (task: Task?, error: Error?) -> Void in
            print(String(describing: task))
            guard task != nil else {
                print("Error in creating task. error code \(String(describing:error)) (task might already exists)")
                return
            }
            self.readAll()
        }
    }
    
    func readAll() {
        self.client.get("/tasks") { (users: [Task]?, error: Error?) -> Void in
            guard let users = users else {
                print("Error in reading user. error code \(String(describing:error))")
                return
            }
            self.employeesId = []
            self.employeesName = []
            for item in users {
                self.employeesId.append(String(item.id))
                self.employeesName.append(item.task)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func read(textID: String) {
        self.client.get("/tasks", identifier: textID) { (users: Task?, error: Error?) -> Void in
            guard let _ = users else {
                print("Error in reading user. error code \(String(describing:error))")
                let alert = UIAlertController(title: "Search result", message: "Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let users = users {
                let alert = UIAlertController(title: "Search result", message: "\(users.task)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func update(textID: String, textName: String) {
        print("Update called \(textID), \(textName)")
        guard let userID = UInt(textID) else {
            print("\(textID) is not a valid ID. Must be a positive Integer")
            return
        }
        let expectedUser = Task(id: userID, task: textName)
        print("userID: \(userID)")
        client.put("/tasks", identifier: String(expectedUser.id), data: expectedUser) { (user: Task?, error: Error?) -> Void in
            guard let _ = user else {
                print("Error in updating user. (user might not exists)")
                return
            }
            self.readAll()
        }
    }
    
    func deleteAll() {
        client.delete("/tasks") { error in
            guard error == nil else {
                return
            }
            self.readAll()
        }
    }
    
    func delete(textID: String) {
        guard let _ = UInt(textID) else {
            print("\(textID) is not a valid ID. Must be a positive Integer")
            return
        }
        guard let userID = Int(textID) else {
            return
        }
        client.delete("/tasks", identifier: userID) { error in
            guard error == nil else {
                return
            }
            self.readAll()
        }
    }
    
}

