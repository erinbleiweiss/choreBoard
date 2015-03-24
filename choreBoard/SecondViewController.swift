//
//  SecondViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class SecondViewController: PageItemController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, SwipedChore {
   
    // MARK: - Outlets
    @IBOutlet var choreTableView: UITableView!
    
    // MARK: - Variables
    var choreItems = [choreItem]()
    var swipedItem: choreItem?
    
    @IBAction func saveAddChoreViewController(segue:UIStoryboardSegue) {
        let choreDetailsViewController = segue.sourceViewController as ThirdViewController
        
        //add the new player to the players array
        choreItems.append(choreDetailsViewController.newChore)
        
        //update the tableView
        let indexPath = NSIndexPath(forRow: choreItems.count-1, inSection: 0)
        choreTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
        //hide the detail view controller
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        choreTableView.dataSource = self
        choreTableView.delegate = self
        choreTableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        if choreItems.count > 0 {
            return
        }
        
        choreItems.append(choreItem(text: "Do the dishes"))
        choreItems.append(choreItem(text: "Feed the cat"))
        choreItems.append(choreItem(text: "Sweep the floor"))
        choreItems.append(choreItem(text: "Take out the trash"))
        choreItems.append(choreItem(text: "Empty recycling"))
        choreItems.append(choreItem(text: "Buy eggs"))
        choreItems.append(choreItem(text: "Get the mail"))
        
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
        
        let vc: AnyObject! = storyboard!.instantiateViewControllerWithIdentifier("NavController0") as ChoreDetailNavigationController
        let vc2: AnyObject! = storyboard!.instantiateViewControllerWithIdentifier("ViewController0") as PageItemController
 
        
        // swipedItem = ChoreItem

        var detailVC = ChoreDetailViewController()
        detailVC.delegate = self

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
    
//    @IBAction func unwindToList(segue:UIStoryboardSegue){
//        
//        var source: ViewController = segue.sourceViewController as ViewController
//        var item: ToDoItem = source.toDoItem!
//        if item != nil{
//            self.toDoItems.addObject(item)
//            self.tableView.reloadData()
//        }
//        
//    }
//    
    
    
}
