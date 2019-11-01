//
//  UdacityUserResponse.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UdacityUserResponse: Codable {
    let account: AccountModel
    let session: SessionModel
}


struct AccountModel: Codable {
    let registered: Bool
    let key: String
}

struct SessionModel: Codable {
    let id: String
    let expiration: String
}
