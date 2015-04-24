//
//  ChoreFeedViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/11/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

// for swipe buttons (SWTableViewCell)
extension NSMutableArray
{
    
    func sw_addUtilityButtonWithColor(color : UIColor, title : String)
    {
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.backgroundColor = color;
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.adjustsFontSizeToFitWidth;
        self.addObject(button)
    }
}


protocol parseChoreData{
    
    func getParseData() -> Array<choreItem>
}


class ChoreFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {
    
    var viewLaidOut:Bool = false
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var slideshowHeight: CGFloat = 100
    
    var refreshControl:UIRefreshControl!
    
    var chores = [choreItem]()
    var groupItems: [groupItem] = []
    var swipedItem: groupItem?
    
    var clickedButtonIndex: Int!

    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var delegate: parseChoreData? = nil
    
    @IBOutlet weak var slideshow: DRDynamicSlideShow!
    @IBOutlet weak var choreFeed: UITableView!
    
    
    @IBAction func cancelToChoreFeedVC(segue:UIStoryboardSegue) {
        let choreDetailViewController = segue.sourceViewController as ChoreDetailViewController
//        selectedDays = dayPickerTableViewController.selectedDays
    }
    
    func refresh(sender:AnyObject)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedChores = [String: Bool]()
        
        self.groupItems.removeAll(keepCapacity: false)
        
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getGroupItems", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                let allChores: NSArray = result["chores"] as NSArray
                for chore in allChores{
                    if allChores.count > 0 {
                        let choreName = chore["choreName"] as String
                        let choreStatus = chore["completed"] as Bool
                        let choreId = chore.objectId as String
                        self.groupItems.append(groupItem(text: choreName, type: "Chore", completed: choreStatus, objectId: choreId))
                        
                        storedChores[choreId] = choreStatus
                    }
                }
                
                let allSupplies: NSArray = result["supplies"] as NSArray
                for supply in allSupplies as NSArray{
                    if allSupplies.count > 0{
                        let supplyName = supply["supplyName"] as String
                        let supplyStatus = supply["completed"] as Bool
                        let supplyId = supply.objectId as String
                        self.groupItems.append(groupItem(text: supplyName, type: "Supply", completed: supplyStatus, objectId: supplyId))
                        
                    }
                }
                
                let allBills: NSArray = result["bills"] as NSArray
                for bill in allBills as NSArray{
                    if allBills.count > 0{
                        let billName = bill["billName"] as String
                        let billAmount = bill["amount"] as String
                        let billStatus = bill["completed"] as Bool
                        let billId = bill.objectId as String
                        
                        var billString = billName + " (" + billAmount + ")"
                        
                        self.groupItems.append(groupItem(text: billString, type: "Bill", completed: billStatus, objectId: billId))
                    }

                }
                
            }
            
            defaults.setObject(storedChores, forKey: "storedChores")
            
            self.groupItems.sort({
                item1, item2 in
                let bool1 = item1.completed as Bool
                let bool2 = item2.completed as Bool
                
                return bool1 == false && bool2 == true
            })
            
            self.choreFeed.reloadData()
        }

        
        self.refreshControl?.endRefreshing()
    }
    
    let transitionManager = TransitionManager2()
    

    func checkForLogin() -> Bool{
        if(PFUser.currentUser() == nil){
            let vc = storyboard!.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
            self.presentViewController(vc, animated: false, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
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
            //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if self.checkForLogin() {

        super.viewDidLoad()
        var allChores = self.delegate?.getParseData()
        
        // Set up Top Slideshow
        slideshow.backgroundColor = UIColor.orangeColor()
        slideshow.frame = CGRectMake(0 , 0, UIScreen.mainScreen().bounds.width, slideshowHeight)
        
        // Set up Pull to Refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.choreFeed.addSubview(refreshControl)
        
            
        // Navigation Title
        var imageView = UIImageView(frame: CGRectMake(0, 0, 60, 20))
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
            
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
        let logo = UIImage(named: "choreboard_white")
        imageView.image = logo

        self.navigationItem.titleView = imageView
        
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
        
        if checkForLogin(){
            refresh(self)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChoreDetailSegue" {
            // this gets a reference to the screen that we're about to transition to
            var toViewController = (segue.destinationViewController as ChoreDetailNavController)
            
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            
            toViewController.activeChore = swipedItem
            toViewController.transitioningDelegate = self.transitionManager
        }
        
    }
    
    
    
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        
        switch (state) {
            case .CellStateLeft: // Left
                return true
            case .CellStateRight: // Right
                return false
            default:
                break
        }
        
        return true
        
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    func swipeableTableViewCell(cell: ChoreFeedCell!, didTriggerLeftUtilityButtonWithIndex index: Int){
        
        self.clickedButtonIndex = index

    }

    
    func didSelectedCell(cell: ChoreFeedCell!) {
        var indexPath: NSIndexPath = choreFeed.indexPathForCell(cell)!

        if clickedButtonIndex == 1{ // clicked done button
            if groupItems[indexPath.row].completed == false{
                cell.setCompleted()
                groupItems[indexPath.row].completed = true
                PFCloud.callFunctionInBackground("setCompleted", withParameters: ["objectId": groupItems[indexPath.row].objectId, "kind": groupItems[indexPath.row].type], block: nil)
                self.choreFeed.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            else{
                cell.reset()
                groupItems[indexPath.row].completed = false
                PFCloud.callFunctionInBackground("reset", withParameters: ["objectId": groupItems[indexPath.row].objectId, "kind": groupItems[indexPath.row].type], block: nil)
                self.choreFeed.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            

            refresh(self)
            
        }
        else if clickedButtonIndex == 0{
            var refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete \"" + groupItems[indexPath.row].text + "?\"", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                PFCloud.callFunctionInBackground("deleteObject", withParameters: ["objectId": self.groupItems[indexPath.row].objectId, "kind": self.groupItems[indexPath.row].type], block: nil)
                self.refresh(self)
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else if clickedButtonIndex == 2 {
            
            self.swipedItem = groupItems[indexPath.row]
            performSegueWithIdentifier("ChoreDetailSegue", sender: self)
            
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        if !viewLaidOut{
            
            let colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.magentaColor()]
            let snark = ["If you care about shelter, you should pay your rent else the underpass is nice.",
                "I’ll pee in the shower until you buy toilet paper.",
                "Want me to move those biology experiments you are growing in the sink to your bed, for closer study?",
                "Contrary to what you may believe, the government won't subsidize a landfill on our property"]
            
            for index in 0..<colors.count {
                
                frame.size = CGSizeMake(self.view.frame.size.width, slideshowHeight)
                
                var subview = UIView(frame: frame)
                subview.backgroundColor = UIColor.clearColor()
                self.slideshow.addSubview(subview, onPage: index)
                
                var subviewText = UILabel(frame: CGRectMake(10, 0, slideshow.frame.width - 20, slideshowHeight))
                
                subviewText.textColor = UIColor.whiteColor()
                subviewText.backgroundColor = UIColor.clearColor()
                subviewText.numberOfLines = 0
                subviewText.text = snark[index]
                subviewText.font = UIFont(name: "GilLSans", size: 18.0)
                subview.addSubview(subviewText)
                
                let point = CGPointMake(subviewText.center.x + self.slideshow.frame.size.width, subviewText.center.y - self.slideshow.frame.size.height)
                var pointObj = NSValue(CGPoint: point)
                
                let rotation = CGAffineTransformMakeRotation(-0.9)
                let rotationObj = NSValue(CGAffineTransform: rotation)
                
                let rotation2 = CGAffineTransformMakeRotation(0)
                let rotationObj2 = NSValue(CGAffineTransform: rotation)
                
                switch index
                {
                case 0:
                    self.slideshow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(subviewText, page: 0, keyPath: "center", toValue: pointObj, delay: 0) as DRDynamicSlideShowAnimation)
                case 1:
                    self.slideshow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(subviewText, page: 1, keyPath: "center", toValue: pointObj, delay: 0) as DRDynamicSlideShowAnimation)
                case 2:
                    self.slideshow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(subviewText, page: 2, keyPath: "center", toValue: pointObj, delay: 0) as DRDynamicSlideShowAnimation)
                case 3:
                    self.slideshow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(subviewText, page: 3, keyPath: "center", toValue: pointObj, delay: 0) as DRDynamicSlideShowAnimation)
                default:
                    break
                }
                
                
            }
            
            slideshow.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(colors.count), slideshowHeight)
            
            viewLaidOut = true
        }
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupItems.count
    }

    
    ///////////////////////////////////////////////
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ChoreFeedCell") as? ChoreFeedCell
        
        if cell == nil{
            cell = ChoreFeedCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ChoreFeedCell")
            cell!.leftUtilityButtons = self.leftButtons()
            cell!.rightUtilityButtons = nil
            cell!.delegate = self
        }
        
        if groupItems[indexPath.row].type == "Chore"{
            if groupItems[indexPath.row].completed{
                cell?.setCompleted()
                var strikeThroughText = NSMutableAttributedString(string: self.groupItems[indexPath.row].text)
                strikeThroughText.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, strikeThroughText.length))
                cell!.choreText.attributedText = strikeThroughText
                cell!.choreImage.alpha = 0.3
            }
            else{
                cell!.reset()
                cell!.choreText?.text = self.groupItems[indexPath.row].text
                cell!.choreImage.alpha = 1

            }

            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "broom")
        }
            
        else if groupItems[indexPath.row].type == "Supply"{
            if groupItems[indexPath.row].completed{
                cell?.setCompleted()
                var strikeThroughText = NSMutableAttributedString(string: "Buy " + self.groupItems[indexPath.row].text)
                strikeThroughText.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, strikeThroughText.length))
                cell!.choreText.attributedText = strikeThroughText
                cell!.choreImage.alpha = 0.3
            }
            else{
                cell!.reset()
                cell!.choreText?.text = "Buy " + self.groupItems[indexPath.row].text
                cell!.choreImage.alpha = 1
            }
            
            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "shoppingcart")

        }
            
        else if groupItems[indexPath.row].type == "Bill"{
            if groupItems[indexPath.row].completed{
                cell?.setCompleted()
                var strikeThroughText = NSMutableAttributedString(string: "Pay " + self.groupItems[indexPath.row].text)
                strikeThroughText.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, strikeThroughText.length))
                cell!.choreText.attributedText = strikeThroughText
                cell!.choreImage.alpha = 0.3
            }
            else{
                cell!.reset()
                cell!.choreText?.text = "Pay " + self.groupItems[indexPath.row].text
                cell!.choreImage.alpha = 1
                
            }
            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "creditcard")

        }
            
        else{
            cell!.choreText?.text = self.groupItems[indexPath.row].text
            cell!.choreText?.textAlignment = .Left
        }
        

        if groupItems[indexPath.row].completed == true{
            cell!.setLeftUtilityButtons(leftButtons2(), withButtonWidth: 80)
        }
        else{
            cell!.setLeftUtilityButtons(leftButtons(), withButtonWidth: 80)
        }
        
        
        cell!.delegate = self
        return cell!
        
    }
    

    func leftButtons() -> NSArray{
        
        var leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Delete")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0), title: "Done!")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Edit")
        
        return leftUtilityButtons
    }
    
    func leftButtons2() -> NSArray{
        
        var leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Delete")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0), title: "Reset!")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Edit")
        
        return leftUtilityButtons
    }
    
    func rightButtons() -> NSArray{
        
        var rightUtilityButtons: NSMutableArray = []
        return rightUtilityButtons
    }
    
    
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    }
    

    ///////////////////////////////////////////////
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
