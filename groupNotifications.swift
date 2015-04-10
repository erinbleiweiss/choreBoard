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
    
    var numNotifications: Int = 0
    
    func addNotification(n: Int) {
        self.numNotifications++
    }
    
    func getNumNotifications() -> Int {
        return self.numNotifications
    }
    
    func clearNotifications() {
        self.numNotifications = 0
    }
    

}
