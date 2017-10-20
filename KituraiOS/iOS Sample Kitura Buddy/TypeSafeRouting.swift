///*
// * Copyright IBM Corporation 2017
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// * http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */

import Foundation
import UIKit

extension ViewController {
    
    func create(title: String, user: String, order: Int) {
        print("create function called")
        let newToDo = ToDo(title: title, user: user, order: order, completed: false)
        print("ToDo created: \(newToDo)")
        self.client.post("/", data: newToDo) { (returnedItem: ToDo?, error: Error?) -> Void in
            print(String(describing: returnedItem))
            guard returnedItem != nil else {
                print("Error in creating ToDo. error code \(String(describing:error))")
                return
            }
            
            self.readAll()
        }
    }
    
    func readAll() {
        self.client.get("/") { (allToDoItems: [ToDo]?, error: Error?) -> Void in
            guard let allToDoItems = allToDoItems else {
                print("Error in reading user. error code \(String(describing:error))")
                return
            }
            DispatchQueue.main.async {
                self.localToDoStore = allToDoItems
                print("LOCALSTORE NOW: \(self.localToDoStore)")
                
            }
        }
    }
    
    func read(Id: String) {
        self.client.get("/", identifier: Id) { (returnedToDo: ToDo?, error: Error?) -> Void in
            guard let _ = returnedToDo else {
                print("Error in reading user. error code \(String(describing:error))")
                let alert = UIAlertController(title: "Search result", message: "Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let returnedToDo = returnedToDo {
                let alert = UIAlertController(title: "Search result", message: "\(String(describing: returnedToDo.title))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func update(title: String?, user: String?, order: Int?, completed: Bool?) {
        
        guard let order = order else {
            print("No order number present!")
            return
        }
        
        let newToDo = ToDo(title: title, user: user, order: order, completed: completed)
        self.client.patch("/", identifier: order, data: newToDo) { (returnedToDo: ToDo?, error: Error?) -> Void in
            guard let _ = returnedToDo else {
                print("Error in patching ToDo. error code \(String(describing:error))")
                return
            }
            self.readAll()
        }
    }
    
    
    func deleteAll() {
        self.client.delete("/") { error in
            guard error == nil else {
                return
            }
            self.readAll()
        }
    }
    
    func delete(order: Int) {
        self.client.delete("/", identifier: order) { error in
            guard error == nil else {
                return
            }
            self.readAll()
        }
    }
    
}


