//
//  DetailRepeatTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/25/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class DetailRepeatTableViewController: UITableViewController {

    // MARK: - Outlets
    
    
    // MARK: - Variables
    var days1 = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var days2 = ["1st of the Month", "10th of the Month", "15th of the Month", "20th of the Month", "Last Day of the Month"]
    var activeDays = [String]()
    
    var scheduleType: String!
    var repeatType = [String]()
    var monthlyRepeatType: String!
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentVC = self.parentViewController as? DetailNavViewController{
            self.scheduleType = parentVC.scheduleType
            self.repeatType = parentVC.repeatType
        }
        
        if self.scheduleType == "Weekly" {
            activeDays = days1
        }
        else {
            activeDays = days2
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        return activeDays.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = activeDays[indexPath.row]

        if self.scheduleType == "Weekly"{
            for item in self.repeatType as [String] {
                if cell.textLabel?.text == item{
                    cell.accessoryType = .Checkmark
                }
            }
        }
        
        else if self.scheduleType == "Monthly"{
            if cell.textLabel?.text == self.repeatType[0] {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
            
        }
        

        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.scheduleType == "Weekly"{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let row = indexPath.row
            
            
            //update the checkmark for the current row
            if cell!.accessoryType == .Checkmark {
                cell!.accessoryType = .None
            }
            else{
                cell!.accessoryType = .Checkmark
            }
            
        }
        else if self.scheduleType == "Monthly"{
            //Other row is selected - need to deselect it
            if let index = selectedIndex {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
                cell?.accessoryType = .None
            }
            
            selectedIndex = indexPath.row
            
            
            //update the checkmark for the current row
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
            self.repeatType[0] = cell?.textLabel?.text as String!
            
            tableView.reloadData()
        }
        
    }

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
