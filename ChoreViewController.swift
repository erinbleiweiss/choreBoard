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
        super.init(coder: aDecoder);
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
        var userObj: PFUser!
        var groupObj: PFObject!

        newChoreItem = choreItem(text: searchBar.text)
        PFCloud.callFunctionInBackground("addChore", withParameters: ["choreName": searchBar.text], block: nil)
        
        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
        self.presentViewController(pageVC, animated: true, completion: nil)
    }

    
    // MARK: - Variables
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var newChoreItem: choreItem?
    var allChores = [choreItem]()
    var filteredChores = [choreItem]()
    
    var selectedDays = [optionItem]()
    var selectedFrequency = optionItem?()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

///////////////////////////////////////////
//    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
//    {
//        choreTableView.hidden = false
//        var substring = (self.searchBar.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
//        
//        searchAutocompleteEntriesWithSubstring(substring)
//        return true
//    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        filteredChores.removeAll(keepCapacity: false)
        
        for curString in allChores
        {
            var myString:NSString! = curString.text.lowercaseString as NSString
            var substringRange: NSRange! = myString.rangeOfString(substring.lowercaseString)
            if (substringRange.location  == 0)
            {
                filteredChores.append(curString)
            }
        }
        
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
    }
    
    
    func textFieldShouldClear(textField: UITextField!) -> Bool {
        filteredChores = [choreItem]()
        choreTableView.reloadData()
        searchBar.resignFirstResponder()
        return true
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
