//
//  groupItem.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/20/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class groupItem: NSObject {
    var text: String
    var type: String
    var completed: Bool
    var objectId: String
    
    
    init(text: String, type: String, objectId: String) {
        self.text = text
        self.type = type
        self.completed = false
        self.objectId = objectId
    }

    init(text: String, type: String, completed: Bool, objectId: String) {
        self.text = text
        self.type = type
        self.completed = completed
        self.objectId = objectId
    }
}

