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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//class PageNavigationController: UINavigationController{
//    
//    class var sharedInstance: PageNavigationController{
//        struct Static{
//            static let instance : PageNavigationController = PageNavigationController()
//        }
//        
//        return Static.instance
//    }
//    
//    var itemIndex: Int = 0
//    var parentPageViewController: UIPageViewController?
//    
//    func setParentPageViewController(vc: UIPageViewController){
//        self.parentPageViewController = vc
//    }
//    
//    func getParentPageViewController() -> UIPageViewController{
//        return self.parentPageViewController!
//    }
//    
//}