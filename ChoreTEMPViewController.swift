//
//  ChoreTEMPViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/19/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreTEMPViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var choreTableView: UITableView!
    
    @IBAction func searchBarDidChange(sender: AnyObject) {
        choreTableView.hidden = false
        var searchString = searchBar.text
        searchAutocompleteEntriesWithSubstring(searchString)
    }
    
    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var choreDataSource = [choreItem]()
    
    var newChoreItem: choreItem?
    var allChores = [choreItem]()
    var filteredChores = [choreItem]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Search Bar
        searchBar.delegate = self
        
        choreTableView!.dataSource = self
        choreTableView!.delegate = self
        choreTableView!.scrollEnabled = true
        choreTableView!.hidden = true
        self.view.addSubview(choreTableView)
        
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getAllChores", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                for chore in result as NSArray {
                    let choreName = chore["name"] as String
                    self.allChores.append(choreItem(text: choreName))
                }
            }
        }

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
    }
    
    

    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        filteredChores.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "text CONTAINS[c] %@", searchBar.text)
        let array = (allChores as NSArray).filteredArrayUsingPredicate(searchPredicate!)
        filteredChores = array as [choreItem]
        
        if filteredChores.count == 0{
            filteredChores.append(choreItem(text: searchBar.text))
        }
        
        choreTableView!.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if let temp = cell
        {
            let index = indexPath.row as Int
            cell!.textLabel!.text = filteredChores[index].text
        } else
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        searchBar.text = selectedCell.textLabel!.text
        dismissKeyboard()
    }
    
    
    func textFieldShouldClear(textField: UITextField!) -> Bool {
        filteredChores = [choreItem]()
        choreTableView.reloadData()
        searchBar.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
}






