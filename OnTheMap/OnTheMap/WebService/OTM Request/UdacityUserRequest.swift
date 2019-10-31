//
//  UdacityUserRequest.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UdacityUserRequest: Codable {
    let udacity: UserModel
}

struct UserModel: Codable {
    let username: String
    let password: String
}


