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
    
    // MARK: - Variables
    var activeChore: groupItem!

    var swipedChore: choreItem!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentVC = self.parentViewController as? ChoreDetailNavController{
            self.activeChore = parentVC.activeChore!
            detailLabel.text = self.activeChore.text
        }
        
        println(activeChore.text)
    }
    
    override func viewDidAppear(animated: Bool) {

//        println(swipedChore)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
