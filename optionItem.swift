//
//  optionItem.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/12/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class optionItem: NSObject {
    var text: String
    var selected: Bool
    
    
    init(text: String) {
        self.text = text
        self.selected = false
    }
    
    func setSelected(state: Bool) {
        self.selected = state
    }
}
