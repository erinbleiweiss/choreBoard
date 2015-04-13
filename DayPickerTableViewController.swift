//
//  DayPickerTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/12/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class DayPickerTableViewController: UITableViewController {

    var selectedDays = [optionItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDays.append(optionItem(text: "Sunday"))
        selectedDays.append(optionItem(text: "Monday"))
        selectedDays.append(optionItem(text: "Tuesday"))
        selectedDays.append(optionItem(text: "Wednesday"))
        selectedDays.append(optionItem(text: "Thursday"))
        selectedDays.append(optionItem(text: "Friday"))
        selectedDays.append(optionItem(text: "Saturday"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 7
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let row = indexPath.row
        
        
        //update the checkmark for the current row
        if cell!.accessoryType == .Checkmark {
            cell!.accessoryType = .None
            selectedDays[row].setSelected(false)
        }
        else{
            cell!.accessoryType = .Checkmark
            selectedDays[row].setSelected(true)
        }
        
        
    }

}
