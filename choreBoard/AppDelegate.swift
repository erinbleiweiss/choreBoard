//
//  AppDelegate.swift
//  choreBoard
//
//  Created by Erin Bleiweiss on 3/17/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pushNotificationController:PushNotificationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("O9DkEtufcwqSuyJq0irfxCGMHOzrkkh5K2oS76gE", clientKey: "NTYdlIaWz6564dUWPMZ2oprIjASkt6LGm6pCUHJv")
        
        PFFacebookUtils.initializeFacebook()
        FBLoginView.self
        FBProfilePictureView.self
                
        var controller:PFQueryTableViewController = PFQueryTableViewController(className: "Chore")
        
        // Minimum fetch interval for background data
//        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        application.setMinimumBackgroundFetchInterval(30) // value is in seconds (for testing purposes)
        
        self.pushNotificationController = PushNotificationController()
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)

            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    // Following 2 functions are for Facebook sessions
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }
    
    // Following 4 functions are for push notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // println("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("failed to register for remote notifications: ")
        println(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            // println("received notification")
        
        groupNotifications.sharedInstance.addNotification(1)
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    
    // Function for fetching background data
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let navigationController = self.window?.rootViewController
//        println(navigationController)

        if self.window?.rootViewController is RootViewController
        {
            let vc = self.window?.rootViewController as RootViewController
            vc.fetchBackgroundData(completionHandler)
        }
        else {
//            println("Not the right class")
            completionHandler(UIBackgroundFetchResult.Failed)
        }
        
//        var x = 1
//        
//        // Call or write any code necessary to get new data, process it and update the UI.
//
//        // The logic for informing iOS about the fetch results in plain language:
//        if (/** NEW DATA EXISTS AND WAS SUCCESSFULLY PROCESSED **/ x == 1) {
//            completionHandler(UIBackgroundFetchResult.NewData);
//        }
//        
//        if (/** NO NEW DATA EXISTS **/ x == 2) {
//            completionHandler(UIBackgroundFetchResult.NoData);
//        }
//        
//        if (/** ANY ERROR OCCURS **/ x == 3) {
//            completionHandler(UIBackgroundFetchResult.Failed);
//        }
        
    }
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

