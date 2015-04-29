//
//  MenuController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/27/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var choreLabel: UILabel!
    @IBOutlet weak var suppliesLabel: UILabel!
    @IBOutlet weak var billsLabel: UILabel!
//    @IBOutlet weak var manageGroupsLabel: UILabel!
//    @IBOutlet weak var nofticationsLabel: UIButton!
    @IBOutlet weak var logoutLabel: UIButton!
    
    
    @IBOutlet weak var chorePlusLabel: UIImageView!
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "username")
        
        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
        self.presentViewController(pageVC, animated: true, completion: nil)
    }
    
    var firstName: String!
    var lastName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFCloud.callFunctionInBackground("getCurrentGroupName", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                self.groupNameLabel.text = result as? String
         
            }
    
        }
        
//        var currentUser = PFUser.currentUser()
//        currentUser.fetchInBackgroundWithBlock { (object, error) -> Void in
//            currentUser.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
//                
//                self.firstName = currentUser.objectForKey("firstName") as String
//                self.lastName = currentUser.objectForKey("lastName") as String
//                self.groupNameLabel.text = self.firstName + " " + self.lastName
//                
//                
//            }
//        }

        groupNameLabel.textColor = UIColor(red: (232/255.0), green: (126/255.0), blue: (4/255.0), alpha: 1.0)
        choreLabel.textColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        suppliesLabel.textColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
//        billsLabel.textColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
//        manageGroupsLabel.textColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        PFCloud.callFunctionInBackground("getCurrentGroupName", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                self.groupNameLabel.text = result as? String
                
            }
            
        }

//        var currentUser = PFUser.currentUser()
//        currentUser.fetchInBackgroundWithBlock { (object, error) -> Void in
//            currentUser.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
//                
//                self.firstName = currentUser.objectForKey("firstName") as String
//                self.lastName = currentUser.objectForKey("lastName") as String
//                self.groupNameLabel.text = self.firstName + " " + self.lastName
//                
//            }
//        }

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    
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
