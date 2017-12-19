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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        indicator.startAnimating()
        fetchNotifications()
        title = "الاشعارات"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    func fetchNotifications()
    {
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
            cell.setupImage(image: UIImage(named: "radibarq")!)
            // Configure the cell...
            var notification = notifications[indexPath.item]
            var storageRef: FIRStorageReference!
            
            if notification!["type"] as! String == "discarded"
            {
                cell.notificationLabel.text = Constants.notificationDiscardedText
                storageRef = itemsStorageRef.child((notification!["itemId"] as! String)).child("1.jpeg")
            }
                
            else
            {
                cell.notificationLabel.text = Constants.notificationFavouriteText + " " + ((notification!["userName"]) as! String)
                storageRef = profilePicturesStorageRef.child((notification!["email"]) as! String).child("Profile.jpg")
            }
            
            if (notification?["new"] as! String == "true")
            {
                cell.notificationLabel.textColor = UIColor.black
                cell.notificationTime.textColor = UIColor.black
            }
            
           cell.notificationImage.sd_setImage(with: storageRef)
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
            var notificationUserEmail = notification?["email"] // AnyType
            var notificationUserDisplayName = notification?["userName"] // Here
        
            ProfileViewController.userId = notificationUserEmail as! String
            ProfileViewController.userDisplayName = notificationUserDisplayName as! String
        
            let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        
    }
}
