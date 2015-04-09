//
//  groupNotifications.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/8/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

class groupNotifications {
    
    class var sharedInstance: groupNotifications {
        
        struct Static {
            static let instance : groupNotifications = groupNotifications()
        }
        
        return Static.instance
        
    }
    
    var chore: choreItem?
    
    func setCurrentChore(item: choreItem) {
        self.chore = item
    }
    
    func getCurrentChore() -> choreItem {
        return self.chore!
    }
}
