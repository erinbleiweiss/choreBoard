//
//  PushNotificationController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/30/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation

class PushNotificationController : NSObject {
    
    override init() {
        super.init()
        
        let parseApplicationId = valueForAPIKey(keyname: "PARSE_APPLICATION_ID")
        let parseClientKey     = valueForAPIKey(keyname: "PARSE_CLIENT_KEY")
        
        Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
        
    }
    
}