//
//  NewUserFindRoommatesTableViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 5/1/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class NewUserFindRoommatesTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate  {

    // MARK: - Outlets
    var friends = [FBUser]()
    var filteredFriends = [FBUser]()
    
    
    // MARK: - View Lifestyle
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
                
                self.tableView.reloadData()
            }
        }
        
    }

    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredFriends = self.friends.filter({( user: FBUser) -> Bool in
            //            let categoryMatch = (scope == "All") || (user.groupName == scope)
            let stringMatch = user.name.lowercaseString.rangeOfString(searchText.lowercaseString)
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

    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredFriends.count
        } else {
            return self.friends.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //variable type is inferred
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        cell!.accessoryType = .Checkmark
        
        let plusImage = UIImage(named: "add1")
        let plus = UIImageView(image: plusImage)
        plus.frame = CGRectMake(0, 0, 20.0, 20.0)
        
        cell!.accessoryView = plus
        
        var user : FBUser
        // Check to see whether the normal table or search results table is being displayed and set the friend object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            user = filteredFriends[indexPath.row]
        } else {
            user = friends[indexPath.row]
        }
        
        
        
        
        // Configure the cell
        cell!.textLabel!.text = user.name
        //        cell!.detailTextLabel?.text = user.fbId
        
        PFCloud.callFunctionInBackground("groupNameFromFBID", withParameters:["fbId": user.fbId]) {
            (result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                
                if result != nil{
                    cell!.detailTextLabel?.text = result as? String
                    
                }
                else{
                    cell!.detailTextLabel?.text = ""
                }
                
            }
        }
        
        
        
        return cell!
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
