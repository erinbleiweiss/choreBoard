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

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var manualView: UIView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    var newChoreItem: choreItem?
    var allChores = [choreItem]()
    var filteredChores = [choreItem]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            settingsButton.target = self.revealViewController()
            settingsButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
        // Check to see whether the normal table or search results table is being displayed and set the friend object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            chore = filteredChores[indexPath.row]
        } else {
            chore = filteredChores[indexPath.row]
        }
        
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
