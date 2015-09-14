
//  AppDelegate.swift
//  Breadcrumbs
//
//  Created by Diego Borges on 9/2/15.
//  Copyright (c) 2015 Breadcrumbs. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        User.registerSubclass()
        Crumb.registerSubclass()
        Trail.registerSubclass()
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("KQQSFqPW3GgHekWc8Mf0M5cELUduk6xPn8j6RZa3", clientKey: "8RJ4MVg6fS5P3lC6RZbxVqfU4nKA5bn5rbVuqZeY")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let user = User()
        user.username = "Diego"
        user.password = "test123"
        
        if let user = User.logInWithUsername(user.username!, password: user.password!) {
//            UIAlertView(title: "Welcome!", message: "Welcome back to crumbz \(user.username!)!", delegate: nil, cancelButtonTitle: "Thanks!").show()
            return true
        }
        
        if user.signUp() {
//            alert.show()
//            UIAlertView(title: "Log In", message: "Welcome \(user.username!)! Check out our guide so you can take advantage of the cool features of crumbz?", delegate: nil, cancelButtonTitle: "Will do! :~").show()
            return true
        }
        
        UIAlertView(title: "Sign Up", message: "Sign up failed for user \(user.username!)", delegate: nil, cancelButtonTitle: "Ok").show()
        return false
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

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

