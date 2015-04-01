//
//  LoginViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/25/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    
    // MARK: - Variables
    var permissions = ["public_profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
    }

    
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        if loginUsernameField.text != "" && loginPasswordField.text != "" {
            
            PFUser.logInWithUsernameInBackground(loginUsernameField.text, password:loginPasswordField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    // Yes, User Exists
                    println("login successful!")
                    
                    var username = user.objectForKey("username") as String
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(username, forKey: "username")
                    
                    
                    let groupName = PFCloud.callFunction("getCurrentGroupName", withParameters: [:]) as? String

                    // if user is in a group, present chores list
                    if groupName != nil{
                        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
                        self.presentViewController(pageVC, animated: true, completion: nil)
                    }
                    
                    // else, present add group page
                    else {
                        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ManageGroups") as UIViewController
                        self.presentViewController(pageVC, animated: true, completion: nil)
                    }
                    


                } else {
                    // No, User Doesn't Exist
                    println("login invalid")
                }
            }
            
        } else {
            // Empty, Notify user
        }
        
        
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
