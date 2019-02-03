//
//  Service.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class APIService
{
    static func SendRequest(requestUrl: String, requestMethod : String?,customHeaders : Dictionary<String, String>? ,headers : Dictionary<String, String>?,body : String? , completion: @escaping (Data?,String?,Int)->Void) {
        
        guard let url = URL(string: requestUrl) else {
            completion(nil,"Supplied url is invalid",0)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod ?? HTTPMethod.get.rawValue
        request.httpBody = body?.data(using: .utf8)
        if let customHeaders = customHeaders , customHeaders.count > 0 {
            for h in customHeaders
            {
                request.addValue(h.value, forHTTPHeaderField: h.key)
            }
        }
        if let headers = headers , headers.count > 0 {
            for h in headers
            {
                request.setValue(h.value, forHTTPHeaderField: h.key)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                 completion(nil,"Request error",0)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode  else { //Request failed to sent
                    completion(nil,"Check your internet connection",0)
                    return
            }
            //Request sent succesfully
            completion(data,nil,statusCode)
        }
        
        task.resume()
    }
    
    
}


