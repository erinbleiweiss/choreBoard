//
//  OneViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/27/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class OneViewController: PFQueryTableViewController {

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var groupName: String!
    

    // Initialise the PFQueryTable tableview
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Chore"
        self.textKey = "choreName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {

        if self.revealViewController() != nil {
            settingsButton.target = self.revealViewController()
            settingsButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        groupName = PFCloud.callFunction("getCurrentGroupName", withParameters: [:]) as? String
        
        self.loadObjects()

    
    }
    
    override func queryForTable() -> PFQuery! {
        
        if groupName != nil{
            
        println("Current user is a member of group: " + groupName)
        
        var innerQuery = PFQuery(className: "Group")
        innerQuery.whereKey("groupName", equalTo:groupName)

        let query = PFQuery(className: "Chore")
        query.whereKey("group", matchesQuery: innerQuery)
        query.orderByAscending("choreName")
        
        //if network cannot find any data, go to cached (local disk data)
//        if (self.objects.count == 0){
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork
//        }
    
        return query
        }
        else{
            var innerQuery = PFQuery(className: "Group")
            innerQuery.whereKey("groupName", equalTo:"")
            let query = PFQuery(className: "Chore")
            query.whereKey("group", matchesQuery: innerQuery)
            query.orderByAscending("choreName")
            return query
        }
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> PFTableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as PFTableViewCell!
//        if cell == nil {
//            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//        }
//        
//        // Extract values from the PFObject to display in the table cell
//        cell?.textLabel?.text = object["choreName"] as String!
//        cell?.detailTextLabel?.text = object["objectId"] as String!
//        
//        return cell
//    }

}
