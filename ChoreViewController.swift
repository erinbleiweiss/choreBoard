//
//  ChoreViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/27/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var manualView: UIView!
    
    @IBOutlet weak var choreTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var newChoreItem: choreItem?
    var allChores = [choreItem]()
    var filteredChores = [choreItem]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getAllChores", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                for chore in result as NSArray {
                    let choreName = chore["name"] as String
                    self.allChores.append(choreItem(text: choreName))
                }
                self.choreTableView.reloadData()
                println("ALL CHORES")
                println(self.allChores)
            }
        }
        
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
    }

    @IBAction func changeFrequencyType(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            weeklyView.hidden = false
            monthlyView.hidden = true
            manualView.hidden = true
        case 1:
            weeklyView.hidden = true
            monthlyView.hidden = false
            manualView.hidden = true
        case 2:
            weeklyView.hidden = true
            monthlyView.hidden = true
            manualView.hidden = false
        default:
            break; 
        }
    }
    
    @IBAction func addChoreAction(sender: AnyObject) {
        var userObj: PFUser!
        var groupObj: PFObject!
        
        newChoreItem = choreItem(text: searchBar.text)
        PFCloud.callFunctionInBackground("addChore", withParameters: ["choreName": searchBar.text], block: nil)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredChores = self.allChores.filter({( chore: choreItem) -> Bool in
            let stringMatch = chore.text.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil ? true : false
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredChores.count
        } else {
            return self.allChores.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //variable type is inferred
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        var chore : choreItem
        // Check to see whether the normal table or search results table is being displayed and set chore friend object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            chore = filteredChores[indexPath.row]
        } else {
            chore = filteredChores[indexPath.row]
        }
        
        // Configure the cell
        cell!.textLabel!.text = chore.text
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
