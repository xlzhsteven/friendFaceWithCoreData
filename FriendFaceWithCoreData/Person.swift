//
//  Person.swift
//  FriendFaceWithCoreData
//
//  Created by Xiaolong Zhang on 8/25/20.
//  Copyright © 2020 Xiaolong. All rights reserved.
//

import Foundation

struct PersonCodable: Codable {
    let id: UUID
    let name: String
    let isActive: Bool?
    let age: Int16?
    let company: String?
    let email: String?
    let address: String?
    let about: String?
    let registered: Date?
    let tags: [String]?
    let friends: [SmallPersonCodable]?
}

struct SmallPersonCodable: Codable {
    let name: String
    let id: UUID
}
