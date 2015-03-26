//
//  SecondViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

protocol newChore{
    func getNewChore() -> choreItem
}

class SecondViewController: PageItemController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, SwipedChore {
   
    // MARK: - Outlets
    @IBOutlet var choreTableView: UITableView!
    
    // MARK: - Variables
    var choreItems = [choreItem]()
    var swipedItem: choreItem?
    var delegate: newChore? = nil
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()


        choreTableView.dataSource = self
        choreTableView.delegate = self
        choreTableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        if choreItems.count > 0 {
            return
        }
        
        getChoresFromParse()

//        choreItems.append(choreItem(text: "Do the dishes"))
//        choreItems.append(choreItem(text: "Feed the cat"))
//        choreItems.append(choreItem(text: "Sweep the floor"))
//        choreItems.append(choreItem(text: "Take out the trash"))
//        choreItems.append(choreItem(text: "Empty recycling"))
//        choreItems.append(choreItem(text: "Buy eggs"))
//        choreItems.append(choreItem(text: "Get the mail"))
        
        
//        if let newChore = self.delegate?.getNewChore() {
//            choreItems.append(newChore)
//        }
        
        println(self)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        println(self)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return choreItems.count
    }
    
    
    func choreItemDeleted(ChoreItem: choreItem) {
        let index = (choreItems as NSArray).indexOfObject(ChoreItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        choreItems.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        choreTableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        choreTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        choreTableView.endUpdates()
    }
    
    func viewChoreDetail(ChoreItem: choreItem) {
        let index = (choreItems as NSArray).indexOfObject(ChoreItem)
        if index == NSNotFound { return }
        
        let vc = storyboard!.instantiateViewControllerWithIdentifier("NavController0") as ChoreDetailNavigationController
            vc.itemIndex = 0
            vc.parentPageViewController = self.parentPageViewController
        
        let vc2 = storyboard!.instantiateViewControllerWithIdentifier("ViewController0") as ChoreDetailViewController
            vc.itemIndex = 0
 
        
        swipedItem = ChoreItem

        vc2.delegate = self

        if let pageViewController = parentPageViewController as UIPageViewController! {
            pageViewController.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
            
            vc.pushViewController(vc2 as UIViewController, animated: true)
                    
//            var pageControl: UIPageControl?
//            pageControl = UIPageControl()
//            pageControl?.currentPage = 0
//            pageControl?.numberOfPages = 3
            
            //UIPageControl.updateCurrentPageDisplay(pageControl!)
         
        }

        
}
    

    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableViewCell
        cell.selectionStyle = .None
        
        let item = choreItems[indexPath.row]
        // cell.textLabel?.backgroundColor = UIColor.clearColor()
        // cell.textLabel?.text = item.text
        
        cell.delegate = self
        cell.ChoreItem = item
        
        return cell
    }
    
    func getSwipedChore() -> choreItem {
        return swipedItem!
    }
    
    func getChoresFromParse()
    {
        var query: PFQuery = PFQuery(className: "Chore")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                for(var i=0;i<objects.count;i++){
                    var object=objects[i] as PFObject
                    var parseChore = choreItem(text: object.objectForKey("choreName") as String)
                    self.choreItems.append(parseChore)
                }
            }
        }
    }
    
    
    
}
