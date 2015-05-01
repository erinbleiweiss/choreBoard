//
//  FBUserPointer.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 5/1/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class FBUserPointer: NSObject {
    var name: String
    var objId: String
    
    init(name: String, objId: String){
        self.name = name
        self.objId = objId
    }
}
