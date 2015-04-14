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
    
    // MARK: - Variables
    var swipedChore: choreItem!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(swipedChore)
    }
    
    override func viewDidAppear(animated: Bool) {

        println(swipedChore)   
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
