//
//  UsersLocation.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct UsersLocationList: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
}

class StudentInformationModel {
    private(set) var studentInformations = OTMDataSource.getStudentList()
    
    func numberOfRows(_ section: Int) -> Int {
        return self.studentInformations.count
    }
    
    func modelAt(_ index: Int) -> StudentInformation {
        return self.studentInformations[index]
    }    
    
}
