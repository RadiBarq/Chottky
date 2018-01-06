//
//  ProfileViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/17/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import PageMenu
import Firebase
import FirebaseStorageUI
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var customeNavigationItem: UINavigationItem!
    var profileImageStorageRef: FIRStorageReference!
    static var profileNavigationController: UINavigationController?
    static var isItMyProfile: Bool?
    var pageMenu: CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    @IBOutlet weak var navigationBar: UINavigationBar!
    static var userId: String = String()
    static var userDisplayName: String = String()
    @IBOutlet weak var profilePicture: UIImageView!
    let userID = FIRAuth.auth()!.currentUser!.uid
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var isThisUserBlocked: Bool?
    

    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {

        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onClickSettings(_ sender: Any) {
        
        
        if (ProfileViewController.userId == userID)
        {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileSetttingsController = mainStoryboard.instantiateViewController(withIdentifier: "profileSettingsTableViewController") as! ProfileSettingsTableViewController
            self.navigationController?.pushViewController(profileSetttingsController, animated: true)
            
        }
            
        else
        {
            let alert = UIAlertController(title: "العملية على هاذا المستخدم", message: "", preferredStyle: .actionSheet)
            if (self.isThisUserBlocked == false)
            {
            
            alert.addAction(UIAlertAction(title: "حذر المستخدم", style: .default, handler: { (action) in
               // PostedItemViewController.imageClickedNumber = indexPath.item
               // let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
              //  let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
              //  self.navigationController?.pushViewController(cameraViewController, animated: true)
         
                var blockReference = FIRDatabase.database().reference().child("Users").child(self.userID).child("block").child(ProfileViewController.userId).setValue(ProfileViewController.userDisplayName)
        
                var deleteReference = FIRDatabase.database().reference().child("Users").child(self.userID).child("chat").child(ProfileViewController.userId).removeValue()
                
                   self.isThisUserBlocked = true
                
               }))
            }
            
            else{
    
                alert.addAction(UIAlertAction(title: "الغاء حذر المستخدم", style: .default, handler: { (action) in
                    // PostedItemViewController.imageClickedNumber = indexPath.item
                    // let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    //  let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
                    //  self.navigationController?.pushViewController(cameraViewController, animated: true)
                    
                    var blockReference = FIRDatabase.database().reference().child("Users").child(self.userID).child("block").child(ProfileViewController.userId).removeValue()
                    
                    self.isThisUserBlocked = false
 
                }))
            }
        
            alert.addAction(UIAlertAction(title: "التبليغ عن المستخدم", style: .default, handler: { (action) in
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let reportViewController = mainStoryboard.instantiateViewController(withIdentifier: "reportUserViewController") as! ReportUserViewController
                self.navigationController?.pushViewController(reportViewController, animated: true)
                
            }))
            
            alert.addAction(UIAlertAction(title: "اغلاق", style: .cancel, handler: { (action) in
                //execute some code when this option is selected
                // self.skinType = "Dark Skin"
                alert.dismiss(animated: true, completion: nil)
                print("close")
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkIfUserBlcoked()
    {
        
       var checkerRef =   FIRDatabase.database().reference().child("Users").child(self.userID).child("block")
        
        checkerRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if(snapshot.hasChild(ProfileViewController.userId))
            {
                
               self.isThisUserBlocked = true

            }
            
            else
            {
                self.isThisUserBlocked = false
                
            }
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        controllerArray = []
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
        title = ""
        self.tabBarController?.tabBar.isHidden = true
        
        var moveTo: Int = 0
        // title = "الصفحة الشخصية"
        let collectionsStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sellingViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "SellingViewController")
        sellingViewController.title = "المعروضات للبيع"
        
        //        sellingViewController.view.backgroundColor = UIColor.red
        
        let soldViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "SoldViewController")
        soldViewController.title = "المبيوعات مسبقا"
        
        // soldViewController.view.backgroundColor = UIColor.red
        
        controllerArray.append(soldViewController)
        controllerArray.append(sellingViewController)
        
        checkIfUserBlcoked()
        
        // pageMenu?.view.translatesAutoresizingMaskIntoConstraints = false
        
        // pageMenu?.view.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        // pageMenu?.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        // pageMenu?.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        //  pageMenu?.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // pageMenu?.view.layer.shadowOpacity = 1
        //// pageMenu?.view.layer.shadowOffset = CGSize.zero
        //pageMenu?.view.layer.shadowColor = UIColor.black.cgColor
        //  pageMenu?.view.layer.shadowRadius = 10
        
        if (ProfileViewController.userId == userID)
        {
            let watchingViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "WatchingViewController")
            watchingViewController.title = "المفضلة"
            
            //  watchingViewController.view.backgroundColor = UIColor.re
            
            controllerArray.append(watchingViewController)
            customeNavigationItem.title = WelcomeViewController.user.displayName
            profileImageStorageRef = FIRStorage.storage().reference(withPath: "Profile_Pictures").child(ProfileViewController.userId).child("Profile.jpg")
            moveTo = 2
        }
            
        else
        {
            settingsButton.image = UIImage(named: "ic_more_vert_white_36pt")
            customeNavigationItem.title = ProfileViewController.userDisplayName
            //    profileImageStorageRef = FIRStorage.storage().reference(withPath: "Items_Photos").child(ItemViewController.itemKey)
            profileImageStorageRef = FIRStorage.storage().reference(withPath: "Profile_Pictures").child(ProfileViewController.userId).child("Profile.jpg")
            moveTo = 1
        }
        
        ProfileSettingsTableViewController.profileSettingsImageStorageRef = self.profileImageStorageRef
        profilePicture.sd_setShowActivityIndicatorView(true)
        profilePicture.sd_setIndicatorStyle(.gray)
        profilePicture.sd_addActivityIndicator()
        profilePicture.sd_setImage(with: profileImageStorageRef,  placeholderImage: nil, completion:
            
            {  (image, error, cache, ref) in
                
                self.profilePicture.sd_removeActivityIndicator()
        })
        
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
        
        // thsis pageMenu is a view controller not a view
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:250.0, width:self.view.frame.width, height:self.view.frame.height - 250), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu?.moveToPage(moveTo)
        pageMenu?.view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ProfileViewController.profileNavigationController = self.navigationController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
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
