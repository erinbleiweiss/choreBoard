//
//  RootViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class RootViewController: SWRevealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For Background Data Fetching
    func insertNewObjectForFetchWithCompletionHandler (performFetchWithCompletionHandler completionHandler:(UIBackgroundFetchResult) -> Void) {
        
        println("updating table view")
        
        
        completionHandler(UIBackgroundFetchResult.NewData)
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
