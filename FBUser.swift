//
//  FBUser.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/5/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class FBUser: NSObject {
   
    var name: String
    var fbId: String
    var userId: String
    var activeRequest: Bool = false
    
    init(name: String, fbId: String){
        self.name = name
        self.fbId = fbId
        self.userId = ""
    }
    
    init(name: String, fbId: String, userId: String){
        self.name = name
        self.fbId = fbId
        self.userId = userId
    }
    
    func setUserId (userId: String){
        self.userId = userId
    }
    
    func setActiveRequest (state: Bool){
        self.activeRequest = state
    }
    
}