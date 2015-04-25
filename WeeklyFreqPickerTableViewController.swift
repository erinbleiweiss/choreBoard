//
//  WeeklyFreqPickerTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/12/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class WeeklyFreqPickerTableViewController: UITableViewController {

    var selectedFrequencyIndex: Int?
    var selectedFrequency = optionItem(text: "Weekly")
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 4
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedFrequencyIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedFrequencyIndex = indexPath.row
        
        switch indexPath.row{
            case 0:
                selectedFrequency = optionItem(text: "Weekly")
            case 1:
                selectedFrequency = optionItem(text: "Every 2 Weeks")
            case 2:
                selectedFrequency = optionItem(text: "Every 3 Weeks")
            case 3:
                selectedFrequency = optionItem(text: "Every 4 Weeks")
            default:
                break
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        
    }


}
