//
//  TabViewProvider.swift
//  Chottky
//
//  Created by Radi Barq on 8/31/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import ESTabBarController_swift


enum TabViewProvider
{
    static func customStyle() -> ESTabBarController
    {
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let layout = UICollectionViewFlowLayout()
        let v1 = mainStoryboard.instantiateViewController(withIdentifier: "browseNavigationController")
        let v2 =  mainStoryboard.instantiateViewController(withIdentifier: "collectionsNavigationController")
        let v3 =  mainStoryboard.instantiateViewController(withIdentifier: "browseNavigationController")
        let v4 =  mainStoryboard.instantiateViewController(withIdentifier: "messagesNavigationController")
        let v5 =  mainStoryboard.instantiateViewController(withIdentifier: "notificationsNavigationController")
        v1.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        
        var photoImage = UIImage(named: "thin-circle")
        v2.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "thin-circle"), selectedImage: photoImage)
        v4.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "message-2"), selectedImage: UIImage(named: "message_!"))
        v5.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "ic_notifications_none"), selectedImage: UIImage(named: "ic_notifications"))
        
        tabBarController.tabBar.shadowImage = nil
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        tabBarController.view.tintColor = UIColor.black
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.layer.borderWidth = 0.50
        tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBarController.tabBar.clipsToBounds = true
        
        
        for tabBarItem in tabBarController.tabBar.items!
        {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
        
        return tabBarController
    }
}
