//
//  APIKeys.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct HeaderKeys {
    static let PARSE_APP_ID = "X-Parse-Application-Id"
    static let PARSE_API_KEY = "X-Parse-REST-API-Key"
    static let Accept = "Accept"
    static let ContentType = "Content-Type"
    
}

struct HeaderValues {
    static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let PARSE_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let Accept = "application/json"
    static let ContentType = "application/json"
}

struct APIAdress {
    static let Login = "https://onthemap-api.udacity.com/v1/session"
    static let UserData = "https://onthemap-api.udacity.com/v1/users"
    static let Locations = "https://parse.udacity.com/parse/classes/StudentLocation"
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
