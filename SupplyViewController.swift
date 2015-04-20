//
//  SupplyViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/11/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class SupplyViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var supplyTableView: UITableView!
    
    @IBAction func searchBarDidChange(sender: AnyObject) {
        supplyTableView.hidden = false
        var searchString = searchBar.text
        searchAutocompleteEntriesWithSubstring(searchString)
    }

    @IBAction func addSupplyAction(sender: AnyObject) {
        
        if searchBar.text != ""{
            newSupplyItem = supplyItem(text: searchBar.text)
            PFCloud.callFunctionInBackground("addSupply", withParameters: ["supplyName": searchBar.text], block: nil)
        }
        
        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
        self.presentViewController(pageVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
        
    var newSupplyItem: supplyItem?
    var allSupplies = [supplyItem]()
    var filteredSupplies = [supplyItem]()
    
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
        
        supplyTableView!.dataSource = self
        supplyTableView!.delegate = self
        supplyTableView!.scrollEnabled = true
        self.view.addSubview(supplyTableView)
        
        // Load Supplies From Parse
        PFCloud.callFunctionInBackground("getAllSupplies", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                for supply in result as NSArray {
                    let supplyName = supply["name"] as String
                    self.allSupplies.append(supplyItem(text: supplyName))
                }
            }
        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
    }
    
    
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        filteredSupplies.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "text CONTAINS[c] %@", searchBar.text)
        let array = (allSupplies as NSArray).filteredArrayUsingPredicate(searchPredicate!)
        filteredSupplies = array as [supplyItem]
        
        if filteredSupplies.count == 0{
            filteredSupplies.append(supplyItem(text: searchBar.text))
        }
        
        supplyTableView!.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSupplies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if let temp = cell
        {
            let index = indexPath.row as Int
            cell!.textLabel!.text = filteredSupplies[index].text
        } else
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        
        if filteredSupplies.count == 1 && cell!.textLabel?.text != "" && cell!.textLabel?.text == searchBar.text{
            cell!.accessoryType = .Checkmark
        }
        else{
            cell!.accessoryType = .None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        searchBar.text = selectedCell.textLabel!.text
        dismissKeyboard()
    }
    
    
    func textFieldShouldClear(textField: UITextField!) -> Bool {
        filteredSupplies = [supplyItem]()
        supplyTableView.reloadData()
        searchBar.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }

}
