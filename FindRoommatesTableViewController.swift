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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.users = [UserTemp(firstName: "Erin", lastName: "Bleiweiss", username: "ebleiweiss", groupName: "My Apartment"),
            UserTemp(firstName: "Abed", lastName: "Nadir", username: "anadir", groupName: "Community"),
            UserTemp(firstName: "Bruce", lastName: "Wayne", username: "notbatman", groupName: "Gotham"),
            UserTemp(firstName: "Jeff", lastName: "Winger", username: "wingerjeff", groupName: "Notches"),
            UserTemp(firstName: "April", lastName: "Ludgate", username: "janetsnakehole", groupName: "Pawnee"),
            UserTemp(firstName: "Robert", lastName: "Quigley", username: "robquig", groupName: "Mobile News Apps")
        ]
        self.tableView.reloadData()
    }
    
//    func filterContentForSearchText(searchText: String) {
//        // Filter the array using the filter method
//        self.filteredUsers = self.users.filter({( user: UserTemp) -> Bool in
//            let categoryMatch = (scope == "All") || (user.category == scope)
//            let stringMatch = user.name.rangeOfString(searchText)
//            return categoryMatch && (stringMatch != nil)
//        })
//    }
    
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
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // Get the corresponding candy from our candies array
        let user = self.users[indexPath.row]
        
        // Configure the cell
        cell.textLabel!.text = user.firstName + " " + user.lastName
        
        return cell
    }

}
