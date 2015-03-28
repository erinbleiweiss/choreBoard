//
//  PageNavigationController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/20/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class PageNavigationController: UINavigationController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var parentPageViewController: UIPageViewController?
    var childViewController: AnyObject?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemIndex == 1{
            if childViewController != nil{
                self.pushViewController(childViewController! as SWRevealViewController, animated: true)
            }
        }
        
        else{
            if childViewController != nil{
                self.pushViewController(childViewController! as PageItemController, animated: true)
            }
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.pushViewController(childViewController!, animated: true)
    }
    
}
