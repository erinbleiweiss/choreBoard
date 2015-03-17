//
//  ChoreDetailViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ChoreDetailViewController: PageItemController {
    
    // MARK: - Outlets
    @IBOutlet weak var detailImageView: UIImageView!
    
    // MARK: - Variables
    var imageName: String = "nature_pic_1" {
        didSet {
            if let imageView = detailImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView!.image = UIImage(named: imageName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
