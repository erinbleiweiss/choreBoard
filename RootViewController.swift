//
//  RootViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class RootViewController: SWRevealViewController, parseChoreData {

    var rootChores = [choreItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let checkfortoken = prefs.stringForKey("username")
        if (checkfortoken != nil){
//            loadParseChores()
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For Background Data Fetching
    func fetchBackgroundData (performFetchWithCompletionHandler completionHandler:(UIBackgroundFetchResult) -> Void) {

        let defaults = NSUserDefaults.standardUserDefaults()
        var storedChores: NSDictionary = defaults.dictionaryForKey("storedChores")!
        var activeChores = [String]()
        
        PFCloud.callFunctionInBackground("getGroupChores", withParameters:[:]) {
            (result: AnyObject!, error: NSError!) -> Void in
            
            if error == nil {
                for chore in result as NSArray {
                    self.rootChores = [choreItem]()
                    let choreName = chore["choreName"] as String
                    let choreId = chore.objectId as String
                    let choreStatus = chore["completed"] as Bool
                    
                    if (storedChores.valueForKey(choreId) as Bool != choreStatus){
                        activeChores.append(choreName)
                    }

                    self.rootChores.append(choreItem(text: choreName))
                }
                
                for chore in activeChores{
                    PFCloud.callFunctionInBackground("getSnark", withParameters:["choreName": chore]) {
                        (result: AnyObject!, error: NSError!) -> Void in
                        if error == nil {
                            
                            PFCloud.callFunction("activeChorePush", withParameters: ["message": result])

                            
                        }
                    }
                    
                    
                }
                
                completionHandler(UIBackgroundFetchResult.NewData)
            }
            else{
                completionHandler(UIBackgroundFetchResult.Failed)
            }
        }
    }
    
    
    
    func getParseData() -> Array<choreItem> {
        return rootChores
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
