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
                
                for notification in result as NSArray {
                    let friendName = notification["fromUserName"] as String
                    let friendId = notification["fromUserId"] as String

                    self.notifications.append(notificationItem(name: friendName, userId: friendId))
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = "0"
        groupNotifications.sharedInstance.clearNotifications()
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


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = self.notifications[indexPath.row].name

        return cell!
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var clickedFriend = notifications[indexPath.row]
        
//        println("clicked on " + clickedFriend.name)

        
        
        PFCloud.callFunctionInBackground("addUserToMyGroup", withParameters:["userId": clickedFriend.userId]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
//                println("Added!")
                

                
            }
        }
        
        
        
        let alert = UIAlertController(title: "Roommate Added!", message: "\(clickedFriend.name) has been added to your group!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                    let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
                    self.presentViewController(pageVC, animated: true, completion: nil)
            case .Cancel:
                break
//                println("cancel")
                
            case .Destructive:
                break
//                println("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)

        
        
    }

    
    
    

    
    
    
    
    
    
    
    
    
}