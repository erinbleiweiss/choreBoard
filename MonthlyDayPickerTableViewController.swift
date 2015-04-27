//
//  MonthlyDayPickerTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MonthlyDayPickerTableViewController: UITableViewController {

    var selectedDateIndex: Int?
    var selectedDate = optionItem(text: "1st of the Month")
    
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
        return 7
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedDateIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedDateIndex = indexPath.row
        
        switch indexPath.row{
        case 0:
            selectedDate = optionItem(text: "1st of the Month")
        case 1:
            selectedDate = optionItem(text: "5th of the Month")
        case 2:
            selectedDate = optionItem(text: "10th of the Month")
        case 3:
            selectedDate = optionItem(text: "15th of the Month")
        case 4:
            selectedDate = optionItem(text: "20th of the Month")
        case 5:
            selectedDate = optionItem(text: "25th of the Month")
        case 6:
            selectedDate = optionItem(text: "Last Day of the Month")
        default:
            break
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        
    }

}
