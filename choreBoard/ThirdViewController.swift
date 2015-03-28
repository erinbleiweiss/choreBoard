//
//  ThirdViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, newChore {
   
    // MARK: - Outlets

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newChoreTextField: UITextField!
    @IBOutlet weak var saveChoreButton: UIButton!
    
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
        newChoreItem = choreItem(text: newChoreTextField.text)
        
        var obj = PFObject(className:"Chore")
        obj.setObject(newChoreTextField.text, forKey: "choreName")
        obj.saveInBackgroundWithBlock ({
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
