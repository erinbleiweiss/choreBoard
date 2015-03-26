//
//  ThirdViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ThirdViewController: PageItemController, newChore {
   
    // MARK: - Outlets
    @IBOutlet weak var saveChoreButton: UIBarButtonItem!
    @IBOutlet weak var newChoreTextField: UITextField!
    
    // MARK: - Variables
    var newChoreItem: choreItem?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addChore(sender: AnyObject) {
        newChoreItem = choreItem(text: newChoreTextField.text)
        let vc = storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as SecondViewController
        
        
        //var vc = SecondViewController()
        
        vc.delegate = self
        vc.itemIndex = 1
        vc.parentPageViewController = self.parentPageViewController
        
        let vc2 = storyboard!.instantiateViewControllerWithIdentifier("NavController1") as SecondNavigationController
        

        
            vc2.itemIndex = 1
        if let pageViewController = parentPageViewController as UIPageViewController! {
            pageViewController.setViewControllers([vc2], direction: .Reverse, animated: true, completion: nil)
            vc2.pushViewController(vc as UIViewController, animated: true)
            newChoreTextField.text = ""
        }

    }
    
    func getNewChore() -> choreItem {
        return newChoreItem!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
