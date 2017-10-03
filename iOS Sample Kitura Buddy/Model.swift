//
//  Model.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shibab Mehboob on 03/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

public struct Employee: Codable {
    public let id: String
    public let name: String
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension Employee: Persistable {
    typealias Model = Employee
    typealias I = String
}
