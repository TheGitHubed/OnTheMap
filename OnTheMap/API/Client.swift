//
//  Client.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class Client {
    
    static func Login(username : String ,password:String,completion: @escaping (String?)->Void)
    {
        var customHeaders : Dictionary = [String : String]()
        customHeaders[HeaderKeys.Accept] = HeaderValues.Accept
        customHeaders[HeaderKeys.ContentType] = HeaderValues.ContentType
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        APIService.SendRequest(requestUrl: APIAdress.Login, requestMethod: HTTPMethod.post.rawValue, customHeaders: customHeaders,headers: nil, body: body) { data,error,statusCode in
            var errorMsg : String?
            if  error == nil
            {
                if statusCode > 299  { //Err in given login credintials
                    errorMsg =  "Provided login credintials didn't match our records"
                    
                }
                else {
                    if let data = data
                    {
                        let newData = data.subdata(in: 5..<data.count)
                        if let json = try? JSONSerialization.jsonObject(with: newData, options: []),
                            let dict = json as? [String:Any],
                            let accountDict = dict["account"] as? [String: Any],
                            let sessionDict = dict["session"] as? [String: Any] {
                            
                            LocationFactory.shared.userSession.UserID = accountDict["key"] as? String
                            LocationFactory.shared.userSession.SessionID = sessionDict["id"] as? String
                            
                            self.GetStudentData( ){err in }
                        } else { //Err in parsing data
                            errorMsg  = "Couldn't parse response"
                            
                        }
                    }
                }
            }
            else    {
                errorMsg =  error
                
            }
            DispatchQueue.main.async {
                completion( errorMsg)
            }
        }
        
        
    }
    static func Logout(completion: @escaping (String?)->Void)
    {
        var headers : Dictionary = [String : String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        APIService.SendRequest(requestUrl: APIAdress.Login, requestMethod: HTTPMethod.delete.rawValue, customHeaders: nil,headers: headers, body: nil) { data,error,statusCode in
            var errorMsg : String?
            if  error == nil
            {
                if statusCode > 299  {
                    errorMsg =  "Something went wrong"
                    
                }
                else {
                    if let data = data
                    {
                        let newData = data.subdata(in: 5..<data.count)
                        if let _ = try? JSONSerialization.jsonObject(with: newData, options: []){
                            
                        } else { //Err in parsing data
                            errorMsg  = "Couldn't parse response"
                            
                        }
                    }
                }
            }
            else    {
                errorMsg =  error
                
            }
            DispatchQueue.main.async {
                completion( errorMsg)
            }
        }
        
        
    }
    static func GetStudentData(completion: @escaping (String?)->Void) {
        
        var customHeaders : Dictionary = [String : String]()
        customHeaders[HeaderKeys.PARSE_APP_ID] = HeaderValues.PARSE_APP_ID
        customHeaders[HeaderKeys.PARSE_API_KEY] = HeaderValues.PARSE_API_KEY
        let  url = APIAdress.UserData + "/\(LocationFactory.shared.userSession.UserID!)"
        APIService.SendRequest(requestUrl: url, requestMethod: nil, customHeaders: customHeaders,headers: nil,
                               body: nil) { data,error,statusCode in
                                var errorMsg : String?
                                if  error == nil
                                {
                                    if statusCode > 299  {
                                        errorMsg =  "Something went wrong"
                                        
                                    }
                                    else {
                                        if let data = data
                                        {
                                            let newData = data.subdata(in: 5..<data.count)
                                            if let json = try? JSONSerialization.jsonObject(with: newData, options: []),
                                                let dict = json as? [String:Any],
                                                let first_name = dict["first_name"] as? String,
                                                let last_name = dict["last_name"] as? String
                                            {
                                                
                                                LocationFactory.shared.userSession.firstName = first_name
                                                LocationFactory.shared.userSession.lastName = last_name
                                                
                                            } else { //Err in parsing data
                                                errorMsg  = "Couldn't parse response"
                                                
                                            }
                                        }
                                    }
                                }
                                else    {
                                    errorMsg =  error
                                    
                                }
                                completion( errorMsg)
                                
        }
    }
    
    static func GetLocations(completion: @escaping (String?)->Void)
    {
        if  LocationFactory.shared.studentLocations.count > 0 {
            LocationFactory.shared.studentLocations.removeAll()
        }
        var customHeaders : Dictionary = [String : String]()
        customHeaders[HeaderKeys.PARSE_APP_ID] = HeaderValues.PARSE_APP_ID
        customHeaders[HeaderKeys.PARSE_API_KEY] = HeaderValues.PARSE_API_KEY
        let  url = APIAdress.Locations + "?limit=100&skip=\(Int.random(in: 100..<401))&order=-updatedAt"
        APIService.SendRequest(requestUrl: url, requestMethod: nil, customHeaders: customHeaders,headers: nil,
                               body: nil) { data,error,statusCode in
                                var errorMsg : String?
                                if  error == nil
                                {
                                    if statusCode > 299  {
                                        errorMsg =  "Something went wrong"
                                        
                                    }
                                    else {
                                        if let data = data
                                        {
                                            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                                                let dict = json as? [String:Any],
                                                let results = dict["results"] as? [Any] {
                                                
                                                for location in results {
                                                    let data = try! JSONSerialization.data(withJSONObject: location)
                                                    let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                                                    LocationFactory.shared.studentLocations.append(studentLocation)
                                                }
                                            } else { //Err in parsing data
                                                errorMsg  = "Couldn't parse response"
                                                
                                            }
                                        }
                                    }
                                }
                                else    {
                                    errorMsg =  error
                                    
                                }
                                DispatchQueue.main.async {
                                    completion( errorMsg)
                                }
        }
        
        
    }
    
    static func SaveLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        
        var customHeaders : Dictionary<String, String> = [String : String]()
        customHeaders[HeaderKeys.PARSE_APP_ID] = HeaderValues.PARSE_APP_ID
        customHeaders[HeaderKeys.PARSE_API_KEY] = HeaderValues.PARSE_API_KEY
        customHeaders[HeaderKeys.ContentType] = HeaderValues.ContentType
        if  let uniqueKey = location.uniqueKey ,
            let firstName = location.firstName ,
            let lastName = location.lastName,
            let mapString = location.mapString,
            let mediaURL = location.mediaURL,
            let  latitude = location.latitude,
            let  longitude = location.longitude{
            let body =  "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
            
            APIService.SendRequest(requestUrl: APIAdress.Locations, requestMethod: HTTPMethod.post.rawValue, customHeaders: customHeaders,headers: nil,body: body) { data,error,statusCode in
                var errorMsg : String?
                if  error == nil
                {
                    if statusCode > 299  {
                        errorMsg =  "Something went wrong"
                        
                    }
                    else {
                        if let data = data
                        {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: [])  {
                                print(json)
                            } else { //Err in parsing data
                                errorMsg  = "Couldn't parse response"
                                
                            }
                        }
                    }
                }
                else    {
                    errorMsg =  error
                    
                }
                DispatchQueue.main.async {
                    completion( errorMsg)
                }
            }
        }
        
        
        
    }
    
    
}

