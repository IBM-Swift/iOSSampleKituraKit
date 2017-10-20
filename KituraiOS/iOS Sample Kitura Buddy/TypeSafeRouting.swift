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
        self.client.post("/", data: newToDo) { (returnedItem: ToDo?, error: Error?) -> Void in
            print(String(describing: returnedItem))
            guard returnedItem != nil else {
                print("Error in creating ToDo. error code \(String(describing:error))")
                return
            }
            
        }
    }
    
    func readAll() {
        self.client.get("/") { (allToDoItems: [ToDo]?, error: Error?) -> Void in
            guard let allToDoItems = allToDoItems else {
                print("Error in reading user. error code \(String(describing:error))")
                return
            }
            DispatchQueue.main.async {
                localToDo.localToDoStore = allToDoItems
                self.tableView.reloadData()
            }
        }
    }
    
    func read(Id: String) {
        self.client.get("", identifier: Id) { (returnedToDo: ToDo?, error: Error?) -> Void in
            guard let _ = returnedToDo else {
                
                DispatchQueue.main.async {
                    print("Error in reading user. error code \(String(describing:error))")
                    let alert = UIAlertController(title: "Search result", message: "Not Found", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            if let returnedToDo = returnedToDo {
                
                DispatchQueue.main.async {
                    guard let title = returnedToDo.title else {return}
                    let alert = UIAlertController(title: "Search result", message: title, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func update(title: String?, user: String?, order: Int?, completed: Bool?, url: String) {
        
        let urlArray = url.split(separator: "/")
        guard let urlEndOfArray = urlArray.last else {return}
        guard let urlToSend = Int(urlEndOfArray) else{return}
        print("url to send: \(String(describing:urlToSend))")
        let newToDo = ToDo(title: title, user: user, order: order, completed: completed)
        print("updateToDo: \(newToDo)")
        self.client.patch("", identifier: urlToSend, data: newToDo) { (returnedToDo: ToDo?, error: Error?) -> Void in
            guard let _ = returnedToDo else {
                print("Error in patching ToDo. error code \(String(describing:error))")
                return
            }
            print("reached patch response: \(String(describing:returnedToDo))")
            self.readAll()
        }
    }
    
    func deleteAll() {
        self.client.delete("") { error in
            guard error == nil else {
                return
            }
            self.readAll()
        }
    }
    
    func delete(url: String) {
        let urlArray = url.split(separator: "/")
        guard let urlEndOfArray = urlArray.last else {return}
        guard let urlToSend = Int(urlEndOfArray) else{return}
        print("url to delete \(urlToSend)")
        self.client.delete("", identifier: urlToSend) { error in
            guard error == nil else {
                print("delete error: \(String(describing : error))")
                return
            }
            self.readAll()
        }
    }
    
}


