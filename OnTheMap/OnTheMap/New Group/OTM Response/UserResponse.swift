//
//  UserResponse.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let lastName: String
    let firtsName: String
    let accountKey: String
    let nikcName: String
    let imageUrl: String
    let mail: MailModel

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firtsName = "first_name"
        case accountKey = "key"
        case nikcName
        case imageUrl = ""
        case mail = "email"
    }
    
}

struct MailModel: Codable {
    let address: String
}
