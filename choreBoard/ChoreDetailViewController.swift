//
//  ChoreDetailViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    // MARK: - Variables
    var activeChore: groupItem!

    var swipedChore: choreItem!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.frame = CGRectMake(0, 0, 40, 40)
        detailImage.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        
        detailImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        if let parentVC = self.parentViewController as? ChoreDetailNavController{
            self.activeChore = parentVC.activeChore!
            detailLabel.text = self.activeChore.text
            
            switch self.activeChore.type{
                case "Chore":
                    detailImage.image = UIImage(named: "broom")
                    break
                case "Supply":
                    detailImage.image = UIImage(named: "shoppingcart")
                    break
                case "Bill":
                    detailImage.image = UIImage(named: "creditcard")
                    break
                default: break
            }
            
        }
        
        println(activeChore.text)
        println(activeChore.objectId)
        
    }
    
    override func viewDidAppear(animated: Bool) {

//        println(swipedChore)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
