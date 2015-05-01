//
//  JoinRequestsTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 5/1/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class JoinRequestsTableViewController: UITableViewController {

    var users = [FBUserPointer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PFCloud.callFunctionInBackground("getGroupRequests", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                for user in result as NSArray {
                    let name = user["fromUserName"] as String
                    let objId = user["fromUser"]!!.objectId as String
                    self.users.append(FBUserPointer(name: name, objId: objId))
                }
                
                self.tableView.reloadData()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        
        var clickedFriend: FBUserPointer = users[row]
        
        var refreshAlert = UIAlertController(title: "Add Roommate", message: "Add " + clickedFriend.name + " to your group?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in

            PFCloud.callFunctionInBackground("addUserToMyGroup", withParameters:["objId": clickedFriend.objId]) {
                (result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    
                }
            }
            

        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

}
