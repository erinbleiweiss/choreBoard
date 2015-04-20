//
//  RegisterViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/25/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var registerUsernameText: UITextField!
    @IBOutlet weak var registerPasswordText: UITextField!
    @IBOutlet weak var registerEmailText: UITextField!
    
    
    // MARK: - Variables

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func registerButtonAction(sender: AnyObject) {
        var usrEntered = registerUsernameText.text
        var pwdEntered = registerPasswordText.text
        var emlEntered = registerEmailText.text
        
        if usrEntered != "" && pwdEntered != "" && emlEntered != "" {
            userSignUp()
        } else {
//            println("Could not register")
        }
        
    }
    
    func userSignUp() {
        var usrEntered = registerUsernameText.text
        var pwdEntered = registerPasswordText.text
        var emlEntered = registerEmailText.text
        
        var user = PFUser()
        user.username = usrEntered
        user.password = pwdEntered
        user.email = emlEntered
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                println("Registered!")
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
            }
        }
    }
    
    
    @IBAction func registerBackAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
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
