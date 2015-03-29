//
//  ChoreViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/27/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreViewController: UIViewController, newChore {

    // MARK: - Outlets

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newChoreTextField: UITextField!
    
    
    // MARK: - Variables
    var newChoreItem: choreItem?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            settingsButton.target = self.revealViewController()
            settingsButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    @IBAction func addChoreAction(sender: AnyObject) {
        var userObj: PFUser!
        var groupObj: PFObject!
        
        
        newChoreItem = choreItem(text: newChoreTextField.text)
        
        var choreObj = PFObject(className: "Chore")
        
        choreObj.setObject(newChoreTextField.text, forKey: "choreName")
        choreObj.saveInBackgroundWithBlock ({
            (succeeded: Bool!, err: NSError!) -> Void in
            NSLog("Hi")
        })

        
        
    }
    
    
    func getNewChore() -> choreItem {
        return newChoreItem!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
