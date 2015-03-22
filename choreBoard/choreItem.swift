//
//  choreItem.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class choreItem: NSObject {
   
    var text: String
    var completed: Bool
    
    
    init(text: String) {
        self.text = text
        self.completed = false
    }
    
}

