//
//  ProfileViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/17/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import PageMenu

class ProfileViewController: UIViewController {
    
    static var isItMyProfile: Bool?
    
    var pageMenu: CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
        
        title = "الصفحة الشخصية"
        
        let collectionsStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let sellingViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "SellingViewController")
        sellingViewController.title = "المعروضات للبيع"
        
        let soldViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "SoldViewController")
        soldViewController.title = "المبيوعات مسبقا"
        
        
        if (ProfileViewController.isItMyProfile == true)
        {
            let watchingViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "WatchingViewController")
            watchingViewController.title = "المفضلة"
            controllerArray.append(watchingViewController)
            
        }

        controllerArray.append(sellingViewController)
        controllerArray.append(soldViewController)
        
        
        var parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemSeparatorColor(UIColor.white),
            .selectedMenuItemLabelColor(Constants.FirstColor),
            .selectionIndicatorColor(Constants.FirstColor),
            .selectionIndicatorHeight(2),
            .enableHorizontalBounce(true),
            .unselectedMenuItemLabelColor(UIColor(red:  127/255, green: 127/255, blue: 127/255 , alpha: 1))
        ]
        
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:200.0, width:self.view.frame.width, height:self.view.frame.height - 200), pageMenuOptions: parameters)
       // pageMenu?.view.layer.shadowOpacity = 1
       //// pageMenu?.view.layer.shadowOffset = CGSize.zero
        //pageMenu?.view.layer.shadowColor = UIColor.black.cgColor
      //  pageMenu?.view.layer.shadowRadius = 10
        
        
        
        
        self.view.addSubview(pageMenu!.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNoItemLabel()
    {
        var noItemLabel = UILabel()
        self.view.addSubview(noItemLabel)
        noItemLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemLabel.textColor = Constants.FirstColor
        noItemLabel.text = "لايوجد معروضات للبيع"
        noItemLabel.textAlignment = .right
        noItemLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        noItemLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noItemLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
