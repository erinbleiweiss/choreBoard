//
//  ApiKeys.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/30/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation

func valueForAPIKey(#keyname:String) -> String {

    let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    
    let value:String = plist?.objectForKey(keyname) as String
    return value
}