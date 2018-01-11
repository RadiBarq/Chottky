//
//  NotificationsTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/15/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI


class NotificationsTableViewController: UITableViewController{
    
    var itemsStorageRef: FIRStorageReference!
    var profilePicturesStorageRef: FIRStorageReference!
    var notificationsRef: FIRDatabaseReference!
    var indicator = UIActivityIndicatorView()
    var notifications = [NSDictionary?]()
    let userID = FIRAuth.auth()!.currentUser!.uid
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // tableView.register(NotificationsCell.self, forCellReuseIdentifier: "NotificationsCell")
        profilePicturesStorageRef = FIRStorage.storage().reference().child("Profile_Pictures")
        notificationsRef = FIRDatabase.database().reference().child("Users").child(userID).child("notifications")
        itemsStorageRef = FIRStorage.storage().reference().child("Items_Photos")
        self.navigationController?.navigationBar.topItem?.title = ""
        initializeIndicator()
        fetchNotifications()
    }
    
     override func viewDidAppear(_ animated: Bool) {
        
        if (notifications.isEmpty == true)
        {
            self.indicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        title = "الاشعارات"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        makeNotificationsOld()
        title = ""
    }

    func makeNotificationsOld()
    {
        for notification in notifications
        {
            let notificationId = notification?.value(forKey: "itemId") as! String
            let isItNew = notification?.value(forKey: "new") as! String
            
            if (isItNew == "true")
            {
                FIRDatabase.database().reference().child("Users").child(userID).child("notifications").child(notificationId).updateChildValues(["new": "false"])
            }
        }
    }
    
    func fetchNotifications()
    {
          indicator.startAnimating()
          notificationsRef.observe(.value, with: { (
            snapshot) in
            
            self.notifications = []
            
            for notification in snapshot.children
            {
                self.notifications.append((notification as! FIRDataSnapshot).value as? NSDictionary)
            }
            
            self.notifications.reverse()
            self.tableView.reloadData()
        })
    }
    
    func initializeIndicator()
    {
        //Here where we should initialize the indicator that we have
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.color = Constants.FirstColor
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell

        if (notifications.count != 0)
        {
           // cell.setupImage(image: UIImage(named: "radibarq")!)
            var notification = notifications[indexPath.item]
            var profilePictureRef: FIRStorageReference!
            var itemPictureRef: FIRStorageReference!
            
            
            if notification!["type"] as! String == "discarded"
            {
                cell.notificationLabel.text = Constants.notificationDiscardedText
                itemPictureRef = itemsStorageRef.child((notification!["itemId"] as! String)).child("1.jpeg")
                profilePictureRef = FIRStorage.storage().reference().child("Icons").child("discarded_notification.png")
            }
                
            else
            {
                cell.notificationLabel.text = Constants.notificationFavouriteText + " " + ((notification!["userName"]) as! String)
                profilePictureRef = profilePicturesStorageRef.child((notification!["userId"]) as! String).child("Profile.jpg")
                itemPictureRef = itemsStorageRef.child((notification!["itemId"] as! String)).child("1.jpeg")
            }
            
            if (notification?["new"] as! String == "true")
            {
                cell.notificationLabel.textColor = UIColor.black
                cell.notificationTime.textColor = UIColor.black
            }
            
            else{
                
                cell.notificationLabel.textColor = UIColor.gray
                cell.notificationTime.textColor = UIColor.gray
                
            }
            
           cell.notificationUser.sd_setShowActivityIndicatorView(true)
           cell.notificationUser.sd_setIndicatorStyle(.gray)
           cell.notificationUser.sd_addActivityIndicator()
           cell.notificationUser.sd_setImage(with: profilePictureRef,  placeholderImage: nil, completion:
                
                {  (image, error, cache, ref) in
                    
                    cell.notificationUser.sd_removeActivityIndicator()
            })
        
            cell.notificationImage.sd_setShowActivityIndicatorView(true)
            cell.notificationImage.sd_setIndicatorStyle(.gray)
            cell.notificationImage.sd_addActivityIndicator()
            cell.notificationImage.sd_setImage(with: itemPictureRef,  placeholderImage: nil, completion:
                
                {  (image, error, cache, ref) in
                    
                    cell.notificationImage.sd_removeActivityIndicator()
            })
            
           cell.notificationImage.layer.masksToBounds = true
           cell.notificationImage.layer.cornerRadius = 5

            if (notifications.count - 1 == indexPath.item)
            {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval((notification!["timestamp"]) as! Double))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ar_JO")
            dateFormatter.dateStyle = .short
            cell.notificationTime.text = dateFormatter.string(from: date)
        }
    
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Here where we can makes things work as wee want it to work my lord...........
        var notification = notifications[indexPath.item] // now the notification seems working
        if ((notification?["type"]) as! String == "favourite")
        {
            var notificationUserId = notification?["userId"] // AnyType
            var notificationUserDisplayName = notification?["userName"] // Here
        
            ProfileViewController.userId = notificationUserId as! String
            ProfileViewController.userDisplayName = notificationUserDisplayName as! String
        
            let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        
    }
}
