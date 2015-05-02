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
    
    var fbIds = [String]()
    var users = [FBUserPointer]()

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
                
                for i in self.friends{
                    self.fbIds.append(i.fbId)
                }
                
                PFCloud.callFunctionInBackground("getUserIds", withParameters:["allItems": self.fbIds]) {
                    (result: AnyObject!, error: NSError!) -> Void in
                    if error == nil {
                        
                        var count = 0
                        for friend in self.friends {
                            var theID = result[count] as String
                            friend.setUserId(theID)
                            count++
                        }
                        
                        
                        
                        PFCloud.callFunctionInBackground("getAddToGroupRequests", withParameters:[:]) {
                            (result: AnyObject!, error: NSError!) -> Void in
                            if error == nil {
                                
                                for user in result as NSArray {
                                    let name = user["fromUserName"] as String
                                    let objId = user["fromUser"]!!.objectId as String
                                    self.users.append(FBUserPointer(name: name, objId: objId))
                                    
                                    for friend in self.friends{
                                        if friend.userId == objId{
                                            friend.activeRequest = true
                                        }
                                    }
                                    
                                    
                                }
                                
                                self.tableView.reloadData()
                            }
                        }
                        
                        
                    }
                }
                
                
                
                
                
                
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
        
        let plusImage = UIImage(named: "add2")
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

        if user.activeRequest{
            println(user.name)
            cell!.textLabel!.font = UIFont.boldSystemFontOfSize(16.0)
        }
        
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
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        
        var clickedFriend: FBUser = friends[row]
        
        if filteredFriends.count > 0 {
            clickedFriend = filteredFriends[row]
        }
        else{
            clickedFriend = friends[row]
        }
        
        if clickedFriend.activeRequest{
            var refreshAlert = UIAlertController(title: "Join Group", message: "Join " + clickedFriend.name + "\'s Group?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Join", style: .Default, handler: { (action: UIAlertAction!) in
                PFCloud.callFunctionInBackground("joinRoommatesGroup", withParameters:["fbId": clickedFriend.fbId]) {
                    (result: AnyObject!, error: NSError!) -> Void in
                    if error == nil {
                        let pageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
                        self.presentViewController(pageVC, animated: true, completion: nil)
                    }
                }
                
                
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
        }
            
            
        else{
            var refreshAlert = UIAlertController(title: "Send Request", message: "Send " + clickedFriend.name + " a group request?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action: UIAlertAction!) in
                
                PFCloud.callFunctionInBackground("joinGroupRequest", withParameters:["fbId": clickedFriend.fbId]) {
                    (result: AnyObject!, error: NSError!) -> Void in
                    if error == nil {
                        
                    }
                }
                
                
                let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
                
                let checkImage = UIImage(named: "checkmark")
                let checkmark = UIImageView(image: checkImage)
                checkmark.frame = CGRectMake(0, 0, 20.0, 20.0)
                selectedCell.accessoryView = checkmark
                
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
