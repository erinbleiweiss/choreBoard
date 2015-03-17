//
//  ThirdViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ThirdViewController: PageItemController {
   
    // MARK: - Outlets
    @IBOutlet weak var thirdImageView: UIImageView!
    
    // MARK: - Variables
    var imageName: String = "nature_pic_3" {
        didSet {
            if let imageView = thirdImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdImageView!.image = UIImage(named: imageName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
