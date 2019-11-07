//
//  OTMClient.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import MapKit

class OTMClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firtsName = ""
        static var lastName = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let signUp = "https://auth.udacity.com/sign-up?next"
        
        case session
        case user
        case locations
        case postLocation
        
        var stringValue: String {
            switch self {
                case .session: return  Endpoints.base + "/session"
                case .user: return Endpoints.base + "/users/\(Auth.accountKey)"
                case .locations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                case .postLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType,  fixData: Bool? = nil, completion: @escaping(ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                completion(nil, error)
                return
            }
            
            if let _fixData = fixData, _fixData == true {
                data = data.subdata(in: 5..<data.count)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, reponse: ResponseType.Type, fixData: Bool? = nil, completion: @escaping(ResponseType?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if let _fixData = fixData, _fixData == true {
                data = data.subdata(in: 5..<data.count)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let databody = try! JSONEncoder().encode(body)
        request.httpBody = databody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    //MARK: - Post Session id
    
    class func login(userName: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = UdacityUserRequest.init(udacity: UserModel.init(username: userName, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, responseType: UdacityUserResponse.self, body: body, fixData: true) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping(Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            completion(true, nil)
        }
        task.resume()
    }
    
    //MARK: - User
    class func getUserData(completion: @escaping(Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.user.url, reponse: UserResponse.self, fixData: true) { response, error in
            if let response = response {
                Auth.firtsName = "\(response.firtsName)"
                Auth.lastName = "\(response.lastName)"
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
    
    class func getUsersLocation(completion: @escaping(Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.locations.url, reponse: UsersLocationList.self) { response, error in
            if let response = response {
                
                if let jsonData = try? JSONEncoder().encode(response),
                    let jsonString = String(data: jsonData, encoding: .utf8) {
                    OTMDataSource.saveStudenListModel(studenList: jsonString)
                }
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    class func postUserLocation(location: CLLocationCoordinate2D, mediaUrl: String, mapString: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = UserUpdateRequest.init(uniqueKey: Auth.sessionId, firstName: Auth.firtsName, lastName: Auth.lastName, mapString: mapString, mediaURL: mediaUrl, latitude: location.latitude, longitude: location.longitude)
        taskForPOSTRequest(url: Endpoints.postLocation.url, responseType: UserPostResponse.self, body: body) { response, error in
            if response != nil {
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
}
