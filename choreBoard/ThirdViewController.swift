//
//  ThirdViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ThirdViewController: PageItemController {
   
    // MARK: - Outlets
    @IBOutlet weak var saveChoreButton: UIBarButtonItem!
    @IBOutlet weak var newChoreTextField: UITextField!
    
    // MARK: - Variables
    var newChore: choreItem!

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveChoreDetail" {
            newChore = choreItem(text: self.newChoreTextField.text)
            println("checkpoint 2")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
