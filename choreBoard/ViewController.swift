//
//  ViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    var index = 0
    var delegate: SwipedChore? = nil

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateControllerArrays()
        createPageViewController()
        setPageViewController()
        setupPageControl()
    }
    
    var navControllers = [PageNavigationController]()
    var controllers = [PageItemController]()
    
    private func populateControllerArrays(){
        for i in 0...2{
            let navController = storyboard!.instantiateViewControllerWithIdentifier("NavController\(i)") as PageNavigationController
            navController.itemIndex = i
            
            let controller = storyboard!.instantiateViewControllerWithIdentifier("ViewController\(i)") as PageItemController
            navController.childViewController = controller
            controller.itemIndex = i
            
            navControllers.append(navController)
            controllers.append(controller)
        }
        
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as UIPageViewController
        pageController.dataSource = self

        // *** Whatever index is inside of controllers[i] will be the default view (see also "Indicator" below)  -Erin ***
        if !controllers.isEmpty {
            pageController.setViewControllers([navControllers[1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    

    private func setPageViewController(){
        for i in 0...2{
            let pageItemController = controllers[i] as PageItemController
            pageItemController.parentPageViewController = pageViewController
        }
    }
    

    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
//     MARK: - UIPageViewControllerDataSource
    
    // "swipe backwards (from L to R)"
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageItemController {
            // this "if" block prevents from swiping to index 0 (chore detail controller) from the main screen
            // because this will be handled in tableview swipe functionality
            if controller.itemIndex == 1{
                return nil
            }
            else if controller.itemIndex > 0 {
                return navControllers[controller.itemIndex - 1]
            }
        }
        return nil
    }

    
    // "swipe forwards (from R to L)"
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageNavigationController {
            if controller.itemIndex < controllers.count - 1 {
                return navControllers[controller.itemIndex + 1]
            }
        }
        return nil
    }
    
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return navControllers.count
        
    }
    
    // *** Return the index of default view (from createPageViewController above) -Erin ***
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    
    
}
