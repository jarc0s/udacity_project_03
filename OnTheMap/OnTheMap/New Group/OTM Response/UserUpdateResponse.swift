//
//  UserUpdateResponse.swift
//  OnTheMap
//
//  Created by juan on 11/4/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UserUpdateResponse: Codable {
    var updatedAt: String
}


struct UserPostResponse: Codable {
    var objectId: String
    var createdAt: String
}
