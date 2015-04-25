//
//  ChoreViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/27/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate  {

    // MARK: - Outlets
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var choreTableView: UITableView!
    
    @IBOutlet weak var searchBar: UITextField!

    var choreDataSource = [choreItem]()
    
    required init(coder aDecoder: (NSCoder)) {
        choreTableView = UITableView(frame: CGRectMake(13, 200, 295, 200), style: UITableViewStyle.Plain);
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func cancelToAddChoreVCFromRepeat(segue:UIStoryboardSegue) {
        let dayPickerTableViewController = segue.sourceViewController as DayPickerTableViewController
        selectedDays = dayPickerTableViewController.selectedDays
    }
    
    @IBAction func cancelToAddChoreVCFromFrequency(segue:UIStoryboardSegue) {
        let freqPickerTableViewController = segue.sourceViewController as WeeklyFreqPickerTableViewController
        selectedFrequency = freqPickerTableViewController.selectedFrequency
    }
    
    @IBAction func searchBarDidChange(sender: AnyObject) {
        choreTableView.hidden = false
        var searchString = searchBar.text
        searchAutocompleteEntriesWithSubstring(searchString)
    }
    
    @IBAction func addChoreAction(sender: AnyObject) {
        
        if searchBar.text != "" || searchBar.text == ""{

            if segmentedControl.selectedSegmentIndex == 0{
        
                var days = [String]()
                
                for i in selectedDays as [optionItem]{
                    if i.selected{
                        days.append(i.text)
                    }
                }
                
                newChoreItem = choreItem(text: searchBar.text)
                PFCloud.callFunctionInBackground("addChore_DEVELOPMENT", withParameters: ["choreName": searchBar.text, "type": "weekly", "days": days, "frequency": selectedFrequency.text ], block: nil)
            }
            else if segmentedControl.selectedSegmentIndex == 1{
                println("monthly!")
            }
            else if segmentedControl.selectedSegmentIndex == 2{
                println("manual!")
            }
            

        }
        
        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
        self.presentViewController(pageVC, animated: true, completion: nil)
    }

    
    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var newChoreItem: choreItem?
    var allChores = [choreItem]()
    var filteredChores = [choreItem]()
    
    var selectedDays = []
    var selectedFrequency = optionItem(text: "Weekly")

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
        
        if filteredChores.count == 1 && cell!.textLabel?.text != ""  && cell!.textLabel?.text == searchBar.text{
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
        filteredChores = [choreItem]()
        choreTableView.reloadData()
        searchBar.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
///////////////////////////////////////////
    
    

    
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
