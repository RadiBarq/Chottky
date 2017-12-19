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
        
        var photoImage = UIImage(named: "ic_panorama_fish_eye_48pt")
        v2.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "ic_panorama_fish_eye_48pt"), selectedImage: photoImage)
        v4.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "message-2"), selectedImage: UIImage(named: "message_!"))
        v5.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "ic_notifications_none"), selectedImage: UIImage(named: "ic_notifications"))
        
        tabBarController.tabBar.shadowImage = nil
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        tabBarController.view.tintColor = Constants.FirstColor
        tabBarController.tabBar.barTintColor = .white
        
        for tabBarItem in tabBarController.tabBar.items!
        {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
        
        return tabBarController
    }
}
