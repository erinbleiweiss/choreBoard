//
//  createGroupViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/26/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class createGroupViewController: UIViewController {

    
    @IBOutlet weak var groupName: UITextField!
    
    @IBAction func saveButton(sender: AnyObject) {
        addGroup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addGroup(){
        
        var userObject: PFUser!
        
        var groupObj = PFObject(className: "Group")
        groupObj.setObject(groupName.text, forKey:"groupName")
        groupObj.saveInBackgroundWithBlock ({
            (succeeded: Bool!, err: NSError!) -> Void in
            NSLog("Group Created")
            
        })
        
        // get username from NSDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")
        
        // get _User object via username
        var query = PFQuery(className:"_User")
        query.whereKey("username", equalTo:username)
        userObject = query.getFirstObject() as PFUser

        // use object to set groupId relation
        let groupRelation: PFRelation = userObject.relationForKey("group")
        groupRelation.addObject(groupObj)
        userObject.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
            if succeeded {
                println("added relation")
            }
            else {
                println("couldn't add relation")
            }
        })
        
        
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
