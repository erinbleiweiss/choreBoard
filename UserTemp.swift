//
//  UserTemp.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/31/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class UserTemp: NSObject {
   
    var firstName: String
    var lastName: String
    var username: String
    var groupName: String
    
    init(firstName: String, lastName: String, username: String, groupName: String){
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.groupName = groupName
    }
    
}
