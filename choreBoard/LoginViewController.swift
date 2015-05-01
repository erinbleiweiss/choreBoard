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
    
    
    // MARK: - Variables
    var permissions = ["public_profile", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapRecognizer)
    }
        
    func dismissKeyboard(){
    }
    
    @IBAction func facebookLoginAction(sender: AnyObject) {
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    // println("User signed up and logged in through Facebook!")

                    // Set up installation (for push notifications)
                    var currentUser = PFUser.currentUser()
                    user.saveInBackground()
                    
                    var username = currentUser.objectForKey("username") as String
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation["username"] = username
                    currentInstallation.saveInBackground()
                    
                    // Populate Parse with FB info (name, gender)
                    PFCloud.callFunctionInBackground("fillFBInfo", withParameters:[:]) {
                        (result: AnyObject!, error: NSError!) -> Void in
                        if error == nil {
                        }
                    }
                    
                    // present chores list
                    self.loginAction()
                    
                } else {
                    
                    var currentUser = PFUser.currentUser()
                    user.saveInBackground()
                    
                    var username = currentUser.objectForKey("username") as String
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation["username"] = username
                    currentInstallation.saveInBackground()
                    
//                    PFCloud.callFunctionInBackground("getMyGroupId", withParameters:[:]) {
//                        (result: AnyObject!, error: NSError!) -> Void in
//                        if (error == nil) && (result != nil) {
//                            var groupId = result as String
//                            let currentInstallation = PFInstallation.currentInstallation()
//                            currentInstallation.addUniqueObject("CH_" + groupId, forKey: "channels")
//                            currentInstallation.saveInBackground()
//                        }
//                    }
                    
                    // println("User logged in through Facebook!")
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(username, forKey: "username")
                    
                    // present chores list
                    self.loginAction()
                }
            } else {
                // println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    
    func loginAction(){
        let groupName = PFCloud.callFunction("getCurrentGroupName", withParameters: [:]) as? String
        // if user is in a group, present chores list
        if groupName != nil{
            let rootVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as SWRevealViewController
            let navVC = self.storyboard!.instantiateViewControllerWithIdentifier("ChoreFeedNav") as ChoreBoardBlueNavigationController
            rootVC.pushFrontViewController(navVC, animated: false)
            
            self.presentViewController(rootVC, animated: true, completion: nil)
        }
            
            // else, present add group page
        else {
            let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ManageGroups") as UIViewController
            self.presentViewController(pageVC, animated: true, completion: nil)
        }
        
        

    
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
