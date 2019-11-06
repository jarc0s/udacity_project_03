//
//  OTMDataSource.swift
//  OnTheMap
//
//  Created by juan on 11/2/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

struct OTMDataSource {
    
    static func saveStudenListModel(studenList: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(studenList, forKey: "StudentInformation")
    }
    
    
    static func getStudentList() -> [StudentInformation] {
        let userDefaults = UserDefaults.standard
        guard let resultsStr: String = (userDefaults.value(forKey: "StudentInformation") as! String),
            let data = resultsStr.data(using: .utf8) else {
            return [StudentInformation]()
        }
        
        if let responseObject = try? JSONDecoder().decode(UsersLocationList.self, from: data) {
            return responseObject.results
        }
        return [StudentInformation]()
    }
    
}
