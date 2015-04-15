//
//  notificationItem.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/14/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class notificationItem: NSObject {
    var name: String
    var userId: String
    var selected: Bool
    
    
    init(name: String, userId: String) {
        self.name = name
        self.userId = userId
        self.selected = false
    }
    
    func setSelected(state: Bool) {
        self.selected = state
    }
}
