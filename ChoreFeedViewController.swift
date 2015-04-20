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
    var groupItems = [groupItem]()
    var swipedItem: groupItem?

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
                
                for chore in result["chores"] as NSArray{
                    let choreName = chore["choreName"] as String
                    let choreStatus = chore["completed"] as Bool
                    let choreId = chore.objectId as String
                    self.groupItems.append(groupItem(text: choreName, type: "chore", completed: choreStatus))
                    
                    storedChores[choreId] = choreStatus
                }
                
                for supply in result["supplies"] as NSArray{
                    let supplyName = supply["supplyName"] as String
                    let supplyStatus = supply["completed"] as Bool
                    self.groupItems.append(groupItem(text: supplyName, type: "supply", completed: supplyStatus))
                    
                }
                
                for bill in result["bills"] as NSArray{
                    let billName = bill["billName"] as String
                    let billAmount = bill["amount"] as String
                    let billStatus = bill["completed"] as Bool
                    
                    var billString = billName + " (" + billAmount + ")"
                    
                    self.groupItems.append(groupItem(text: billString, type: "bill", completed: billStatus))
                }
                
            }
            
            defaults.setObject(storedChores, forKey: "storedChores")
            self.choreFeed.reloadData()
        }
        
        
        self.refreshControl?.endRefreshing()
    }
    
    let transitionManager2 = TransitionManager()
    
    override func viewDidLoad() {
        checkForLogin()

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
        

    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
        refresh(self)
    }
    
    func checkForLogin(){
        if(PFUser.currentUser() == nil){
            let vc = storyboard!.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChoreDetailSegue" {
            // this gets a reference to the screen that we're about to transition to
            var toViewController = (segue.destinationViewController as ChoreDetailViewController)
            
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            toViewController.transitioningDelegate = self.transitionManager2
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
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int){
        if index == 0{
            performSegueWithIdentifier("ChoreDetailSegue", sender: nil)
        }
        else if index == 1{
            println("clicked done button")
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
                
                var subviewText = UILabel(frame: CGRectMake(0, 0, slideshow.frame.width, slideshowHeight))
                subviewText.textColor = UIColor.blackColor()
                subviewText.backgroundColor = UIColor.clearColor()
                subviewText.numberOfLines = 0
                subviewText.text = snark[index]
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
        
        if groupItems[indexPath.row].type == "chore"{
            cell!.choreText?.text = self.groupItems[indexPath.row].text
            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "broom")
        }
            
        else if groupItems[indexPath.row].type == "supply"{
            cell!.choreText?.text = "Buy " + self.groupItems[indexPath.row].text
            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "shoppingcart")

        }
            
        else if groupItems[indexPath.row].type == "bill"{
            cell!.choreText?.text = "Pay " + self.groupItems[indexPath.row].text
            cell!.choreText?.textAlignment = .Left
            cell!.choreImage.image = UIImage(named: "creditcard")

        }
            
        else{
            cell!.choreText?.text = self.groupItems[indexPath.row].text
            cell!.choreText?.textAlignment = .Left
        }
        
        
        cell!.setLeftUtilityButtons(leftButtons(), withButtonWidth: 80)
        cell!.delegate = self
        return cell!
        
    }
    

    func leftButtons() -> NSArray{
        
        var leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "Edit")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Done!")
        
        return leftUtilityButtons
    }
    
    func rightButtons() -> NSArray{
        
        var rightUtilityButtons: NSMutableArray = []
        return rightUtilityButtons
    }
    
    
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    }
    
    func didSelectedCell(cell: SWTableViewCell!) {

        var indexPath: NSIndexPath = choreFeed.indexPathForCell(cell)!
        swipedItem = groupItems[indexPath.row]
        println(swipedItem!.text)
        
    }
    
    ///////////////////////////////////////////////
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
