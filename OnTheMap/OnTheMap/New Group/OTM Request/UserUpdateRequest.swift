//
//  UserUpdateRequest.swift
//  OnTheMap
//
//  Created by juan on 11/4/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UserUpdateRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
