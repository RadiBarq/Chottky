//
//  MessagesTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/12/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI

class MessagesTableViewController: UITableViewController {
    
    
    var usersKeys = [String]()
   // static var messageTo_Email = String()f
    //static var messageTo_DisplayName = String()
    var usersNames = [String]()
    var holdingRow = String()
    var holdingTouchIndex:IndexPath!
    let userID = FIRAuth.auth()!.currentUser!.uid
    var storageRef: FIRStorageReference!
    @IBOutlet var holdView: UIView!
    var indicator = UIActivityIndicatorView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        tabBarController?.tabBar.items?[2].badgeValue = nil
        // FirstViewController.notificationsNumber = 0
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        self.navigationController?.navigationBar.topItem?.title = ""
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId" ) // here remember to use self because the function needs an objedct, rememebr these very well
        
        usersKeys = [String]()
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        navigationItem.hidesBackButton = false
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
        fetchUsers()
        initializeIndicatior()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        title = "الرسائل"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        storageRef = FIRStorage.storage().reference(withPath: "Profile_Pictures")
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        
        removeView()
    }
    
    @IBAction func deleteView(_ sender: UIButton) {
        
        var reference = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
        
    }
    
    @IBAction func blockUser(_ sender: UIButton) {
        
        var blockReference = FIRDatabase.database().reference().child("Users").child(userID).child("block").child(holdingRow).setValue("true")
        var deleteReference = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            
            if let indexPath =  tableView.indexPathForRow(at: touchPoint){
                
                holdingRow = usersKeys[indexPath.row]
                holdingTouchIndex = indexPath
                popOutTheHoldView(name: holdingRow) // That's it
            }
        }
    }
    
    
    func addView()
    {
        view.superview?.addSubview(holdView)
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        
        holdView.layer.cornerRadius = 5
        //   holdView.translatesAutoresizingMaskIntoConstraints = false
        holdView.center = view.center
        holdView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        holdView.alpha = 0
        
        UIView.animate(withDuration: 0.4)
        {
            // self.visualEffect.effect = self.effect
            self.holdView.alpha = 1
            self.holdView.transform = CGAffineTransform.identity
        }
    }
    
    func popOutTheHoldView(name: String)
    {
        addView()
    }
    
    @IBAction func handlelDelete(_ sender: UIButton) {
        
        var reference = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()
        removeView()
    }
    
    @IBAction func handleBlock(_ sender: UIButton) {
        
        var blockReference = FIRDatabase.database().reference().child("Users").child(userID).child("block").child(holdingRow).setValue("true")
        
        var deleteReference = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(holdingRow).removeValue()

        removeView()
    }
    
    @IBAction func handleClose(_ sender: UIButton) {
        
        removeView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return usersKeys.count
    }
    
    
    func fetchUsers()
    {
        let ref = FIRDatabase.database().reference()
        usersKeys = [String]()
        
        let handle = ref.child("Users").child(userID).child("chat").observeSingleEvent(of: .value , with: { snapshot in
            
            for user in snapshot.children
            {
                let parentKey = String(describing: (user as! FIRDataSnapshot).key)
                self.usersKeys.append(parentKey)
            }
            
            self.tableView.reloadData()
        })
    }

    func removeView()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.holdView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.holdView.alpha = 0
        })
            
        {(success: Bool) in
            
            self.holdView.removeFromSuperview()
        }
        
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.deselectRow(at: holdingTouchIndex, animated: true)
        fetchUsers()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        var userName = String()
        let UserClickedEmail =  usersKeys[indexPath.row]
        
            FIRDatabase.database().reference().child("Users").child(UserClickedEmail).child("UserName").observeSingleEvent(of: .value, with: { (snapshot) in
            FIRDatabase.database().reference().child("Users").child(self.userID).child("chat").child(UserClickedEmail).child("lastMessage").observeSingleEvent(of: .value, with: {(snapshot1) in
                
                for element in snapshot1.children
                {
                    let childValue = String(describing: (element as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                    let childKey = String(describing: (element as! FIRDataSnapshot).key)
                    
                    
                    if childKey == "message"
                    {
                        cell.lastMessageLabel.text = childValue
                    }
                        
                    else if childKey == "time"
                    {
                         //childValue = Double(childValue)!
                         let date = Date(timeIntervalSince1970: TimeInterval(Double(childValue)!))
                         let dateFormatter = DateFormatter()
                         dateFormatter.locale = Locale(identifier: "ar_JO")
                         dateFormatter.dateStyle = .short
                         cell.lastMessageTimeLabel.text =  dateFormatter.string(from: date)
                        
                        
                    }
                }
    
                let imageRef = self.storageRef.child(self.usersKeys[indexPath.row] + "/" + "Profile.jpg")
                cell.profileImageView.sd_setImage(with: imageRef)
                userName = (snapshot.value) as! String
                cell.textLabel?.textAlignment = .right
                cell.textLabel?.text = userName
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
            })
        })

        return cell
    }
    
    @IBAction func onClickBackButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    // When the user click on the message
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let UserClickedEmail =  usersKeys[indexPath.row]
        var userName = String()
        FIRDatabase.database().reference().child("Users").child(UserClickedEmail).child("UserName").observeSingleEvent(of: .value, with: { (snapshot) in

            userName = (snapshot.value) as! String
            ChatCollectionViewController.messageFromDisplayName = userName
            ChatCollectionViewController.messageToId = self.usersKeys[indexPath.row]
            
            let flowLayout = UICollectionViewFlowLayout()
        
            let chatLogController = ChatCollectionViewController(collectionViewLayout:flowLayout)
            self.navigationController?.pushViewController(chatLogController, animated: true)
            //    users = [String]()
        })
        
        ///This is related to move the controller()
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let firstViewController = storyboard.instantiateViewController(withIdentifier: "SendMessage"
        //   ) as! UICollectionViewControllerd
        // self.present(firstViewController, animated: true, completion: nil)
    }
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

class UserCell: UITableViewCell
{
    override func layoutSubviews() {
        
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: self.frame.width - 100, y: textLabel!.frame.origin.y - 10, width: textLabel!.frame.width, height: (textLabel?.frame.height)!)
        textLabel?.textAlignment = .right
        
    }
    
    public var profileImageView: UIImageView = {
        
        
        let imageView = UIImageView()
        //    imageView.image = UIImage(named: "profilepicture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    public var lastMessageTimeLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.lightGray
        return lbl
        
    }()
    
    public var lastMessageLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.gray
        return lbl
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        // ios9 constraints anchors
        // need x, y, width, height anchors
        profileImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        // Related to the last message label
        addSubview(lastMessageLabel)
        
        
        lastMessageLabel.textColor = Constants.SecondColor
        lastMessageLabel.rightAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -10).isActive = true
        lastMessageLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: 10).isActive = true
        lastMessageLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 50).isActive = true
        lastMessageLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        addSubview(lastMessageTimeLabel)
        
        
        
        lastMessageTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        lastMessageTimeLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor, constant: -10).isActive = true
        lastMessageTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lastMessageTimeLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        //lastMessageTimeLabel.text = "٥د"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
}


