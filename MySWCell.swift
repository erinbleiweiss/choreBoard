//
//  MySWCell.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/18/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MySWCell: SWTableViewCell {

    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        
        switch (state) {
        case .CellStateLeft: // Left
            println("left")
            return true
        case .CellStateRight: // Right
            println("right")
            return false
        default:
            println("default")
            break
        }
        
        return true
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
