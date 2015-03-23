//
//  newChore.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/22/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

class newChore {
    
    class var sharedInstance: newChore {
        
        struct Static {
            static let instance : newChore = newChore()
        }
        
        return Static.instance
        
    }
    
    var chore: choreItem?
    
    func setCurrentChore(value: String) {
        self.chore = choreItem(text: value)
    }
    
    func getCurrentChore() -> choreItem {
        return self.chore!
    }
}



