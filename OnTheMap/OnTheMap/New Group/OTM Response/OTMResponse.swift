//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Juan Arcos on 11/1/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
    
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
