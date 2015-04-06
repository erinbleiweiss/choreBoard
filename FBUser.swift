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
    
    init(name: String, fbId: String){
        self.name = name
        self.fbId = fbId
    }
    
}