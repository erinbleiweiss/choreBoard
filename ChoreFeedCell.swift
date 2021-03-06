//
//  ChoreFeedCell.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/20/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreFeedCell: SWTableViewCell {

    @IBOutlet weak var choreImage: UIImageView!
    @IBOutlet weak var choreText: UILabel!
    @IBOutlet weak var choreCompletedText: UILabel!
    
    func setCompleted() -> Void {
        choreText.textColor = UIColor.lightGrayColor()
    }
    
    func reset() -> Void {
        choreText.textColor = UIColor.blackColor()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
