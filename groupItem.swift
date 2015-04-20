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
    
    
    init(text: String, type: String) {
        self.text = text
        self.type = type
        self.completed = false
    }

    init(text: String, type: String, completed: Bool) {
        self.text = text
        self.type = type
        self.completed = completed
    }
}

