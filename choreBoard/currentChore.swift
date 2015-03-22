//
//  currentChore.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/22/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

class currentChore {
    
    class var sharedInstance: currentChore {
        
        struct Static {
            static let instance : currentChore = currentChore()
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



