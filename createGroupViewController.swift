//
//  createGroupViewController.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/26/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class createGroupViewController: UIViewController {

    
    @IBOutlet weak var groupName: UITextField!
    
    @IBAction func saveButton(sender: AnyObject) {
        addGroup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addGroup(){
        PFCloud.callFunctionInBackground("addGroup", withParameters: ["groupName": groupName.text], block: nil)

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