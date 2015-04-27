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
    
    @IBAction func cancelToDetailFromSchedule(segue:UIStoryboardSegue) {
    }

    @IBAction func cancelToDetailFromRepeat(segue:UIStoryboardSegue) {
    }

    @IBAction func cancelToDetailFromFrequency(segue:UIStoryboardSegue) {
    }
    
    // MARK: - Variables
    var activeChore: groupItem!
    let transitionManager = TransitionManager()
    
    var repeatType: String!

    
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
//                println(result)
//                println(result["type"]!!)
//                println(result["frequency"]!!)
//                println(result["repeat"]!!)
                
                self.repeatType = result["type"]!! as String

            }

        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var toViewController = (segue.destinationViewController as DetailNavViewController)
        toViewController.repeatType = self.repeatType
        toViewController.transitioningDelegate = self.transitionManager
        
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
