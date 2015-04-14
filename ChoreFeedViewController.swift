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

struct SWCellState {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let kCellStateCenter = SWCellState(0)
let kCellStateLeft = SWCellState(1)
let kCellStateRight = SWCellState(2)


class ChoreFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    
    var viewLaidOut:Bool = false
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var slideshowHeight: CGFloat = 100
    
    @IBOutlet weak var slideshow: DRDynamicSlideShow!
    @IBOutlet weak var choreFeed: UITableView!
    
    var refreshControl:UIRefreshControl!
    var chores = [choreItem]()
    
    var customButton: UIButton?
    var barButton: BBBadgeBarButtonItem?
    
    var leftButtons : NSMutableArray = NSMutableArray()
    var rightButtons : NSMutableArray = NSMutableArray()
    
    func refresh(sender:AnyObject)
    {
        println("refreshing!")
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getGroupChores", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                self.chores = [choreItem]()
                
                for chore in result as NSArray {
                    let choreName = chore["choreName"] as String
                    self.chores.append(choreItem(text: choreName))
                    self.choreFeed.reloadData()
                }
            }
        }
        
        
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Chores From Parse
        PFCloud.callFunctionInBackground("getGroupChores", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                self.chores = [choreItem]()
                
                for chore in result as NSArray {
                    let choreName = chore["choreName"] as String
                    self.chores.append(choreItem(text: choreName))
                }
                self.choreFeed.reloadData()
            }
        }
        
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
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        // Set up buttons
        leftButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "Edit")
        leftButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Done!")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        barButton!.badgeValue = String(groupNotifications.sharedInstance.getNumNotifications())
        refresh(self)
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
    
        println("checkpoint")
        
//        switch (state.value) {
//            case kCellStateLeft.value:
//                return false
//            case kCellStateRight.value:
//                return false
//            default:
//                break
//        }
        
        return false
        
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int){
        if index == 0{
            println("clicked edit button")
        }
        else if index == 1{
            println("clicked main button")
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
        
        return self.chores.count
    }
    
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    //
    //        cell.textLabel!.text = self.chores[indexPath.row].text
    //
    //        return cell
    //    }
    
    ///////////////////////////////////////////////
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //variable type is inferred
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? SWTableViewCell
        
        if cell == nil {
            cell = SWTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell!.leftUtilityButtons = self.leftButtons
            cell!.rightUtilityButtons = self.rightButtons
            cell!.delegate = self
        }
        
        
        cell!.textLabel?.text = self.chores[indexPath.row].text
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    
    ///////////////////////////////////////////////
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
