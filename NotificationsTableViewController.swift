//
//  NotificationsTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/14/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var notifications = [notificationItem]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Notification Badge
        let buttonImage = UIImage(named: "ico-to-do-list") as UIImage?
        customButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        customButton!.setImage(buttonImage, forState: .Normal)
        
        barButton = BBBadgeBarButtonItem(customUIButton: customButton)
        barButton!.shouldHideBadgeAtZero = true
        
        // Set up Navigation Drawer
        self.navigationItem.rightBarButtonItem = barButton;
        
        if self.revealViewController() != nil {
            customButton!.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getPendingRequests", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                self.notifications = [notificationItem]()
                
//                for notification in result as NSArray {
//                    let friendName = notification["name"] as String
//                    self.notifications.append(notificationItem(text: friendName))
//                }
//                self.notifications.reloadData()
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
        return notifications.count
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
