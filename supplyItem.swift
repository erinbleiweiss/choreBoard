//
//  supplyItem.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/20/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class supplyItem: NSObject {
    
    var text: String
    var completed: Bool
    
    
    init(text: String) {
        self.text = text
        self.completed = false
    }
    
}

