//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/8/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class StudentLocation: Codable {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    var objectId: String?
    var uniqueKey:  String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
}

class LocationFactory{
    
    static let shared = LocationFactory()
    var studentLocations: [StudentLocation] = []
    var userSession : UserSession = UserSession()
    private init(){}
    
    
    
}
