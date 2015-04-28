//
//  ChoreDetailTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/25/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreDetailTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var scheduleDetail: UILabel!
    @IBOutlet weak var repeatDetail: UILabel!
    @IBOutlet weak var frequencyDetail: UILabel!
    
    @IBAction func cancelToDetailFromSchedule(segue:UIStoryboardSegue) {
    }

    @IBAction func cancelToDetailFromRepeat(segue:UIStoryboardSegue) {
    }

    @IBAction func cancelToDetailFromFrequency(segue:UIStoryboardSegue) {
    }
    
    
    @IBAction func deleteChore(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete \"" + self.activeChore.text + "?\"", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            PFCloud.callFunctionInBackground("deleteObject", withParameters: ["objectId": self.activeChore.objectId, "kind": self.activeChore.type]) {
                (result: AnyObject!, error: NSError!) -> Void in
                
                if error == nil{
                    self.dismissViewControllerAnimated(true, completion: {});
                }
            }
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Variables
    var activeChore: groupItem!
    let transitionManager = TransitionManager()
    
    var scheduleType: String!
    var repeatType = [String]()
    var frequencyType: String!

    var reuseIDs = ["DetailMainCell", "DetailScheduleCell", "DetailRepeatCell", "DetailFrequencyCell", "DetailActiveCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.frame = CGRectMake(0, 0, 40, 40)
        detailImage.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        
        detailImage.contentMode = UIViewContentMode.ScaleAspectFit

        if let parentVC = self.parentViewController as? ChoreDetailNavController{
            self.activeChore = parentVC.activeChore!
            detailLabel.text = self.activeChore.text
            
            switch self.activeChore.type{
            case "Chore":
                detailImage.image = UIImage(named: "broom")
                break
            case "Supply":
                detailImage.image = UIImage(named: "shoppingcart")
                break
            case "Bill":
                detailImage.image = UIImage(named: "creditcard")
                break
            default: break
            }
            
        }
        
        var objectId = activeChore.objectId
        var kind = activeChore.type
        
        PFCloud.callFunctionInBackground("getSettings", withParameters:["objId": objectId, "kind": kind]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                self.scheduleType = result["type"] as String
                self.scheduleDetail.text = self.scheduleType
                
                self.frequencyType = result["frequency"] as String
                self.frequencyDetail.text = self.frequencyType
                
                
                self.repeatType = result["repeat"] as [String]
                
                var count = 0
                var repeatTypeString: String = ""
                
                for item in self.repeatType as [String]{
                    if count > 0{
                        repeatTypeString += " "
                        if count == 1{
                            repeatTypeString = repeatTypeString.substringToIndex(advance(repeatTypeString.startIndex, 3))
                            repeatTypeString += " "
                        }
                        repeatTypeString += item.substringToIndex(advance(item.startIndex, 3))
                    }
                    else {
                        repeatTypeString += item
                    }
                    count++
                }
                
                if count == 1{
                    self.repeatDetail.text = repeatTypeString
                }
                else if repeatTypeString == "Mon Tue Wed Thu Fri"
                {
                    self.repeatDetail.text = "Weekdays"
                }
                else if repeatTypeString == "Sun Sat"
                {
                    self.repeatDetail.text = "Weekends"
                }
                else if repeatTypeString == "Sun Mon Tue Wed Thu Fri Sat"
                {
                    self.repeatDetail.text = "Every Day"
                }
                else if repeatTypeString != ""{
                    self.repeatDetail.text = repeatTypeString
                }

                
                self.tableView.reloadData()

            }

        }
        
        detailLabel.font = UIFont (name: "Gill Sans", size: 24)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DetailScheduleSegue" {
            var toViewController = (segue.destinationViewController as DetailNavViewController)

            toViewController.scheduleType = self.scheduleType
            toViewController.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "DetailRepeatSegue" {
            var toViewController = (segue.destinationViewController as DetailNavViewController)
            toViewController.scheduleType = self.scheduleType
            toViewController.repeatType = self.repeatType
            toViewController.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "DetailFrequencySegue" {
            var toViewController = (segue.destinationViewController as DetailNavViewController)
            toViewController.scheduleType = self.scheduleType
            toViewController.frequencyType = self.frequencyType
            toViewController.transitioningDelegate = self.transitionManager
        }
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        
        if row == 1{
            performSegueWithIdentifier("DetailScheduleSegue", sender: self)
        }
        else if row == 2{
            performSegueWithIdentifier("DetailRepeatSegue", sender: self)
        }
        else if row == 3{
            performSegueWithIdentifier("DetailFrequencySegue", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }


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
