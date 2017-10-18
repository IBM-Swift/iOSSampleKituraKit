//
//  TypeSafeRouting.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shibab Mehboob on 18/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

extension ViewController {
    
    func create(textID: String, textName: String) {
        print("create function called")
        guard let userID = UInt(textID) else {
            print("\(textID) is not a valid ID. Must be a positive Integer")
            return
        }
        let newUser = Task(id: userID, task: textName)
        print("user created: \(newUser)")
        self.client.post("/users", data: newUser) { (user: Task?, error: Error?) -> Void in
            guard let _ = user else {
                print("Error in creating user. error code \(String(describing:error)) (user might already exists)")
                return
            }
        }
        print("create function reached read()")
        //self.read()
    }
    
    func read() {
        self.client.get("/users") { (users: [Task]?, error: Error?) -> Void in
            guard let _ = users else {
                print("Error in reading user. error code \(String(describing:error))")
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    func update(textID: String, textName: String) {
        guard let userID = UInt(textID) else {
            print("\(textID) is not a valid ID. Must be a positive Integer")
            return
        }
        let expectedUser = Task(id: userID, task: textName)
        print("userID: \(userID)")
        client.put("/users", identifier: String(expectedUser.id), data: expectedUser) { (user: Task?, error: Error?) -> Void in
            guard let _ = user else {
                print("Error in updating user. (user might not exists)")
                return
            }
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
        client.delete("/users", identifier: userID) { error in
            guard error == nil else {
                return
            }
        }
    }
    
}
