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
import KituraContracts
import SwiftKuery
import SwiftKueryPostgreSQL
import SwiftKueryMySQL

public class ToDoTable : Table {
    let tableName = "toDoTable"
    let toDo_id = Column("toDo_id")
    let toDo_title = Column("toDo_title")
    let toDo_user = Column("toDo_user")
    let toDo_order = Column("toDo_order")
    let toDo_completed = Column("toDo_completed")
    let toDo_url = Column("toDo_url")
    
}

public struct ToDo: Codable, Equatable {
    public static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return (lhs.title == rhs.title) && (lhs.user == rhs.user) && (lhs.order == rhs.order) && (lhs.completed == rhs.completed) && (lhs.url == rhs.url) && (lhs.id == rhs.id)
    }
    
    public var id: Int?
    public var title: String?
    public var user: String?
    public var order: Int?
    public var completed: Bool?
    public var url: String?
    
    public init(title: String?, user: String?, order: Int?, completed: Bool?) {
        self.title = title
        self.user = user
        self.order = order
        self.completed = completed
        self.url = nil
        self.id = nil
    }
    public init(id: Int, title: String, user: String, order: Int, completed: Bool, url: String) {
        self.id = id
        self.title = title
        self.user = user
        self.order = order
        self.completed = completed
        self.url = url
    }
    
}


