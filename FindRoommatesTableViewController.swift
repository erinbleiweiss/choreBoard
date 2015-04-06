//
//  FindRoommatesTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/31/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class FindRoommatesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var users = [UserTemp]()
    var filteredUsers = [UserTemp]()
    
    var friends = [FBUser]()
    var filteredFriends = [FBUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        PFCloud.callFunctionInBackground("getFriends", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                for user in result as NSArray {
                    let name = user["name"] as String
                    let fbId = user["id"] as String
                    self.friends.append(FBUser(name: name, fbId: fbId))
                }
                
                println(self.friends)
            }
        }
        
        
        var userInfo = PFCloud.callFunction("getUserInfo", withParameters: [:]) as NSDictionary
        println("MARK")
        println(userInfo)
        println(userInfo["groupName"] as String)

        self.users = [UserTemp(firstName: "Erin", lastName: "Bleiweiss", username: "ebleiweiss", groupName: "My Apartment"),
            UserTemp(firstName: "Abed", lastName: "Nadir", username: "anadir", groupName: "Community"),
            UserTemp(firstName: "Bruce", lastName: "Wayne", username: "notbatman", groupName: "Gotham"),
            UserTemp(firstName: "Jeff", lastName: "Winger", username: "wingerjeff", groupName: "Notches"),
            UserTemp(firstName: "April", lastName: "Ludgate", username: "janetsnakehole", groupName: "Pawnee"),
            UserTemp(firstName: "Robert", lastName: "Quigley", username: "robquig", groupName: "Mobile News Apps")
        ]
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredFriends = self.friends.filter({( user: FBUser) -> Bool in
//            let categoryMatch = (scope == "All") || (user.groupName == scope)
            let stringMatch = user.name.rangeOfString(searchText)
//            return categoryMatch && (stringMatch != nil)
            return stringMatch != nil ? true : false
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredFriends.count
        } else {
            return self.friends.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var user : FBUser
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            user = filteredFriends[indexPath.row]
        } else {
            user = friends[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = user.name
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

}
