//
//  PageItemController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var parentPageViewController: UIPageViewController?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//class PageItemController: UIViewController{
//    
//    class var sharedInstance: PageItemController{
//        struct Static{
//            static let instance : PageItemController = PageItemController()
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