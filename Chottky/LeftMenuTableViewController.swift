//
//  LeftMenuTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorageUI

class LeftMenuTableViewController: UITableViewController{

    var menus = [String]()
    public static var profileImageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        intitializeMenusArray()
        self.tableView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        navigationController?.navigationBar.isHidden = true
        tableView.separatorColor = UIColor.white
        tableView.register(MenuBarCell.self, forCellReuseIdentifier: "cellId")
        UIApplication.shared.isStatusBarHidden = true
        self.tableView.isScrollEnabled = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      // self.tableView.register(BrowseCollectionViewController(, forCellReuseIdentifier: "leftMenuBarCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         UIApplication.shared.isStatusBarHidden = true
    }
    
    func intitializeMenusArray()
    {
        menus.append("تصفح")
        menus.append("بيع المنتجات الخاصة بك")
        menus.append("الرسائل")
        menus.append("التصنيفات")
        menus.append("الاشعارات")
        menus.append("الصفحة الشخصية")
        menus.append("ادعو اصحاب الفيسبوك")
        menus.append("بحاجة الى مساعدة")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.textAlignment = .right
        addThePhoto(cell: cell as! MenuBarCell, indexPath: indexPath.row)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var backgroundFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 150)
        var backgroundImageView: UIImageView = UIImageView(frame: backgroundFrame)
        let backgroundImage: UIImage = UIImage(named: "main_background")!
        backgroundImageView.image = backgroundImage
        
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150)
        let headerView = UIView(frame:rect)
        headerView.addSubview(backgroundImageView)
        
        var profileBackgroundFrame = CGRect(x: 35.7, y: headerView.frame.size.height / 3 - 32.3
            , width: 60 + 5, height: 60 + 5)
        
        var profileBackgroundImageView = UIImageView(frame: profileBackgroundFrame)
        var profileBackgroundImage = UIImage()
        profileBackgroundImageView.backgroundColor = .white
        profileBackgroundImageView.layer.cornerRadius = 32.5
        profileBackgroundImageView.layer.masksToBounds = true
        headerView.addSubview(profileBackgroundImageView)
        
        var profileImageFrame = CGRect(x: 38, y: headerView.frame.size.height / 3 - 30
            , width: 60, height: 60)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
  
        LeftMenuTableViewController.profileImageView.addGestureRecognizer(tapGesture)
        LeftMenuTableViewController.profileImageView.isUserInteractionEnabled = true
        LeftMenuTableViewController.profileImageView.frame = profileImageFrame
        LeftMenuTableViewController.profileImageView.layer.cornerRadius = 30
        LeftMenuTableViewController.profileImageView.layer.masksToBounds = true
        //LeftMenuTableViewController.profileImageView.sd_setImage(with: storageRef)
        headerView.addSubview(LeftMenuTableViewController.profileImageView)
        
        var nameTextFrame = CGRect(x: 38, y: headerView.frame.size.height / 3 + 45, width: 45, height: 7)
        var nameLabel = UILabel(frame: nameTextFrame)
        nameLabel.text = WelcomeViewController.user.getUserDisplayName()
        nameLabel.textColor = .white
        nameLabel.sizeToFit()
        headerView.addSubview(nameLabel)
        return headerView
    }

    func imageTapped(gesture: UIGestureRecognizer) {
        // What to do here is like the following my little lord
        
        let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
        
    }
    
    func addThePhoto(cell: MenuBarCell, indexPath: Int) -> UITableViewCell
    {
        if (indexPath == 0)
        {
            cell.initializeImageView(name: "ic_shopping_basket")
        }
        
        else if (indexPath == 1)
        {
            
             cell.initializeImageView(name: "ic_photo_camera")
            
        }
        
        else if (indexPath == 2)
        {
            
             cell.initializeImageView(name: "ic_chat")
            
        }
        
        else if (indexPath == 3)
        {
            
            
             cell.initializeImageView(name: "ic_dashboard")
            
        }
        
        
        else if (indexPath == 4)
        {
            
            cell.initializeImageView(name: "ic_notifications")
            
        }
        
        else if (indexPath == 5)
        {
            
            cell.initializeImageView(name: "ic_account_box")
            
        }
        
        else if (indexPath == 6)
        {
            
            cell.initializeImageView(name: "ic_supervisor_account")
            
        }
        
        else if (indexPath == 7)
        {
            cell.initializeImageView(name: "ic_help")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 170
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Here where we just test the items
        if (indexPath.item == 0)
        {
            let messagesStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let messagesViewController = messagesStoryboard.instantiateViewController(withIdentifier: "PostedItemViewController") as! PostedItemViewController
            self.navigationController?.pushViewController(messagesViewController, animated: true)
        }
            
        else if (indexPath.item == 1)
        {
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            // At the end of this, remember to add this.
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
            BrowseCollectionViewController.browseNavigaionController?.pushViewController(cameraViewController, animated: true)
        }
            
        else if (indexPath.item == 2)
        {

            let messagesStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let messagesViewController = messagesStoryboard.instantiateViewController(withIdentifier: "MessagesTableViewController") as! MessagesTableViewController
            self.navigationController?.pushViewController(messagesViewController, animated: true)
        }
        
        else if(indexPath.item == 3)
        {
            
            let collectionsStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let collectionsViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "CollectionsCollectionViewController") as! CollectionsCollectionViewController
            self.navigationController?.pushViewController(collectionsViewController, animated: true)
        
        }
        
        else if (indexPath.item == 4)
        {
            
            let notificationsStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let notificationsViewController = notificationsStoryboard.instantiateViewController(withIdentifier: "NotificationsTableViewController") as! NotificationsTableViewController
            self.navigationController?.pushViewController(notificationsViewController, animated: true)
        }
        
        else if (indexPath.item == 5)
        {
            let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}
