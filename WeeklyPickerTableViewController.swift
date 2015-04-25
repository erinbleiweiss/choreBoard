//
//  WeeklyPickerTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/12/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class WeeklyPickerTableViewController: UITableViewController {

    
    
    // MARK: - Variables    
    let transitionManager = TransitionManager()
    var selectedDays = []
    var selectedFrequency = optionItem?()
    
    // MARK: - Outlets
    @IBOutlet var theTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let parentVC = self.parentViewController as? ChoreViewController{
            selectedDays = parentVC.selectedDays
            selectedFrequency = parentVC.selectedFrequency
        }
        
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
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
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.row == 0{
            cell.textLabel?.text = "Repeat"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel!.text = "Never"
            
            // get selected weekdays and apply to detailTextLabel
            var daysList:String = ""
            var count = 0
            
            var selectedDaysNew = [optionItem]()
            
            for item in selectedDays as [optionItem]{
                if (item.selected) {
                    if count > 0{
                        daysList += " "
                        if count == 1{
                            daysList = daysList.substringToIndex(advance(daysList.startIndex, 3))
                            daysList += " "
                        }
                        daysList += item.text.substringToIndex(advance(item.text.startIndex, 3))
                    }
                    else {
                        daysList += item.text
                    }
                    count++
                    selectedDaysNew.append(item)
                }

            }
            
            self.selectedDays = selectedDaysNew
            
            if count == 1{
                cell.detailTextLabel!.text = daysList
            }
            else if daysList == "Mon Tue Wed Thu Fri"
            {
                cell.detailTextLabel!.text = "Weekdays"
            }
            else if daysList == "Sun Sat"
            {
                cell.detailTextLabel!.text = "Weekends"
            }
            else if daysList == "Sun Mon Tue Wed Thu Fri Sat"
            {
                cell.detailTextLabel!.text = "Every Day"
            }
            else if daysList != ""{
                cell.detailTextLabel!.text = daysList
            }
            
            return cell
        }
            
        else {
            cell.textLabel?.text = "Frequency"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel!.text = "Weekly"
            
            if selectedFrequency != nil{
                cell.detailTextLabel!.text = selectedFrequency?.text
            }
            
            return cell
        }
        

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        
        if row == 0{
            performSegueWithIdentifier("WeekRepeatSegue", sender: self)
        }
        else if row == 1{
            performSegueWithIdentifier("WeekFrequencySegue", sender: self)
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
