//
//  LeftMenuTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit


class LeftMenuTableViewController: UITableViewController{

    var menus = [String]()
    
    
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
        
      // self.tableView.register(BrowseCollectionViewController(, forCellReuseIdentifier: "leftMenuBarCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
         UIApplication.shared.isStatusBarHidden = true
    }
    
    func intitializeMenusArray()
    {
        menus.append("تصفح")
        menus.append("بيع الاشياء الخاصة بك")
        menus.append("الدردشة")
        menus.append("التصنيفات")
        menus.append("الاشعارات")
        menus.append("صفحتي الشخصية")
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
        var profileImageView = UIImageView(frame: profileImageFrame)
        var profileImage = UIImage(named: "profilepicture")
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.image = profileImage
        headerView.addSubview(profileImageView)
    
        var nameTextFrame = CGRect(x: 38, y: headerView.frame.size.height / 3 + 45, width: 45, height: 7)
        var nameLabel = UILabel(frame: nameTextFrame)
        nameLabel.text = WelcomeViewController.user.getUserDisplayName()
        nameLabel.textColor = .white
        nameLabel.sizeToFit()
        headerView.addSubview(nameLabel)
        return headerView
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.item == 2)
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
        
    }
   //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
     //   return menus.count
    //}
    
    
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: /IndexPath) -> UITableViewCell {
    //
             //   let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, /reuseIdentifier: "leftMenuBarCell")
              //  cell.setData(menus[indexPath.row])
                //return cell

   // }
   //
    
    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      //  return 0
    //}

    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      //  return 0
   // }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
