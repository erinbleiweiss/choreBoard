//
//  MonthlyFreqPickerTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MonthlyFreqPickerTableViewController: UITableViewController {

    var selectedFreqIndex: Int?
    var selectedMonthFrequency = optionItem(text: "Every Month")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navigationBar = self.navigationController?.navigationBar
        navigationBar?.tintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        navigationBar?.barTintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)

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
        return 6
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedFreqIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedFreqIndex = indexPath.row
        
        switch indexPath.row{
        case 0:
            selectedMonthFrequency = optionItem(text: "Every Month")
        case 1:
            selectedMonthFrequency = optionItem(text: "Every 2 Months")
        case 2:
            selectedMonthFrequency = optionItem(text: "Every 3 Months")
        case 3:
            selectedMonthFrequency = optionItem(text: "Every 4 Months")
        case 4:
            selectedMonthFrequency = optionItem(text: "Every 5 Months")
        case 5:
            selectedMonthFrequency = optionItem(text: "Every 6 Months")
        default:
            break
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        
    }

}
