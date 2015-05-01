//
//  ChoreBoardBlueNavigationController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 4/8/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreBoardBlueNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationBar.tintColor = UIColorFromRGB(0x004370)
//        navigationBar.barTintColor = UIColorFromRGB(0x004370)
        navigationBar.tintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        navigationBar.barTintColor = UIColor(red: (0/255.0), green: (67/255.0), blue: (112/255.0), alpha: 1.0)
        
        navigationBar.barStyle = UIBarStyle.Black
        
        // necessary for alignment
        navigationBar.translucent = false
        
        // Do any additional setup after loading the view.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
