//
//  OTMClient.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case user
        case locations
        
        var stringValue: String {
            switch self {
                case .session: return  Endpoints.base + "/session"
                case .user: return Endpoints.base + "/users/\(Auth.accountKey)"
                case .locations: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, fixData: Bool? = nil, completion: @escaping(ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard var data = data else {
                completion(nil, error)
                return
            }
            
            if fixData != nil {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("HERE: \(errorResponse.localizedDescription)")
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("OR HERE")
                        completion(nil, error)
                    }
                }
                
            }
        }
        task.resume()
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, reponse: ResponseType.Type, fixData: Bool? = nil, completion: @escaping(ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if fixData != nil {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
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
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    //MARK: - User
    class func getUserData(completion: @escaping(UserResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.user.url, reponse: UserResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    class func getUsersLocation(completion: @escaping(UsersLocationList?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.locations.url, reponse: UsersLocationList.self) { response, error in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
}
