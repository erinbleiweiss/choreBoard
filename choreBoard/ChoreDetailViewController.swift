//
//  ChoreDetailViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreDetailViewController: PageItemController {
    
    // MARK: - Outlets
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Variables


    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        var theChore = currentChore.sharedInstance.getCurrentChore()
        detailLabel.text = theChore.text
    }
    
    override func viewDidAppear(animated: Bool) {
        var theChore = currentChore.sharedInstance.getCurrentChore()
        detailLabel.text = theChore.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
