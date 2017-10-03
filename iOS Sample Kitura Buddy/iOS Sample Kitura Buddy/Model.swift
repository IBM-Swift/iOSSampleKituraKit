//
//  Model.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shibab Mehboob on 03/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

public struct Employee: Codable {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}
