//
//  AppDelegate.swift
//  Chottky
//
//  Created by Radi Barq on 3/3/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase





//#FFCB2A The main color in hash

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 136, green: 214, blue: 253)
        
    
        //application.statusBarStyle = .lightContent
        
       // UINavigationBar.appearance().barStyle = .blackOpaque
        
        
     //   application.statusBarStyle = .lightContent
        
       // let statusBarBackgroundView = UIView()
        
        //statusBarBackgroundView.backgroundColor = UIColor.orange

        
        //window?.addSubview(statusBarBackgroundView)
        //window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        //window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
        

        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor.rgb(red: 100, green: 167, blue: 254)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
