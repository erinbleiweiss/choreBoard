//
//  SecondViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class SecondViewController: PageItemController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
   
    // MARK: - Outlets
    @IBOutlet weak var choreTableView: UITableView!
    
    // MARK: - Variables
    var choreItems = [choreItem]()

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
    
    func didSwipeCell(ChoreItem: choreItem) {
        let index = (choreItems as NSArray).indexOfObject(ChoreItem)
        if index == NSNotFound { return }
        
        let vc: AnyObject! = storyboard!.instantiateViewControllerWithIdentifier("ViewController0") as PageItemController
        
        if let pageViewController = parentViewController as? UIPageViewController {
            pageViewController.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
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
    
    


    
}
