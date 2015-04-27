//
//  DetailNavViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/25/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class DetailNavViewController: UINavigationController {

    // MARK: - Variables
    var scheduleType: String!
    var repeatType = [String]()
    var frequencyType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        navigationBar.barTintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        
        navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
