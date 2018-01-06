//
//  ChatCollectionViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/12/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI

private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let inputTextField = UITextField()
    var messagesTexts = [String]()
    var messagesFrom = [String]()
    var messagesTimeStamps = [Float]()
    static var messageToId = String()
    static var messageFromDisplayName = String()
    
    let userID = FIRAuth.auth()!.currentUser!.uid
    
    var userPhotoUrl: URL!
    var userPhoto: UIImage = UIImage()
    var storageRef: FIRStorageReference!
    var indicator = UIActivityIndicatorView()
    var theProgramJustOpened: Bool = true

    //var notificationReference = FIRDatabase.database().reference().child("Users").child(WelcomeViewController.messageTo_DisplayName)
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.tintColor = UIColor.white
        navigationItem.title = ChatCollectionViewController.messageFromDisplayName
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Related to the titles on the navigation, my lord.
        self.navigationController?.navigationBar.topItem?.title = ""
        
     //   self.title = ChatCollectionViewController.messageFromDisplayName
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle(ChatCollectionViewController.messageFromDisplayName, for: .normal)
        button.addTarget(self, action: #selector(userNameClicked), for: .touchUpInside)
        self.navigationItem.titleView = button

        
        
        //  textFieldCp.addTarget(self, action: "addDoneButtonOnKeyboard", for: UIControlEvents.touchDown
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        
        //userPhotoUrl = (userPhotoUrlRef as! FIRDataSnapshot).value! as! URL
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        /// collectionView?.scrollIndicatorInsets = UIEdgeInsets (top: 8, left:  0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.showsVerticalScrollIndicator = false
        
        //setupInputComponents()
        collectionView?.keyboardDismissMode = .interactive
        
        setUpKeyboardObserver()
        observeMessages()
        
        initializeIndicatior()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        storageRef = FIRStorage.storage().reference(withPath: "Profile_Pictures")
        storageRef = storageRef.child(ChatCollectionViewController.messageFromDisplayName + "/" + "Profile.jpg")
    }
    
    func userNameClicked()
    {
        
        ProfileViewController.userDisplayName = ChatCollectionViewController.messageFromDisplayName
        ProfileViewController.userId = ChatCollectionViewController.messageToId
        let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(true)
         self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func setUpKeyboardObserver()
    {
        
        
    }
    
    func handleKeyBoardDidShow(notification: NSNotification)
    {
        let indexPath = NSIndexPath(item: self.messagesTexts.count - 1, section: 0)
        
        if self.messagesFrom.isEmpty == false
        {
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        
        let keyBoardDuration = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! AnyObject).doubleValue
        containerViewBottomAnchor?.constant = 0
        
        
        UIView.animate(withDuration: keyBoardDuration!)
        {
            
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidDisappear(animated)
        
        //  NotificationCenter.default.removeObserver(self)
        
    }
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    lazy var inputContainterView: UIView =
        {
            
            let containerView = UIView()
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
            containerView.backgroundColor = UIColor.white
            
            // This code to add the button
            let sendButton = UIButton(type: .system)
            sendButton.setTitleColor(Constants.FirstColor, for: .normal)
            sendButton.setTitle("ارسال", for: .normal)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            containerView.addSubview(sendButton)
            
            //x,y,w,h
            sendButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            
            self.inputTextField.textColor = UIColor.black
            self.inputTextField.placeholder = "اكتب الرسالة"
            self.inputTextField.translatesAutoresizingMaskIntoConstraints = false
            self.inputTextField.textAlignment = .right
            
            // This code for the separator
            let seperatorLineView = UIView()
            seperatorLineView.backgroundColor = self.hexStringToUIColor(hex: "E6E6E6")
            seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(seperatorLineView)
            seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            
            containerView.addSubview(self.inputTextField)
            //x,y,w,h
            self.inputTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
            self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            self.inputTextField.leftAnchor.constraint(equalTo: sendButton.rightAnchor).isActive = true
            self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            let indexPath = NSIndexPath(item: self.messagesTexts.count - 1, section: 0)
            
            if self.messagesFrom.isEmpty == false
            {
                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
            
            return containerView
    }()
    //This for make the keyboard hiding when scrolling down fellow
    override var inputAccessoryView: UIView?
        {
        
            get
            {
                return inputContainterView
            
            }
    }
    
    override var canBecomeFirstResponder: Bool
        {
        
        get
        {
            return true
        }
    }
    
    
    func handleKeyboardWillShow(notification: NSNotification)
    {
        let keyBoardFrame = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]) as! AnyObject).cgRectValue
        
        let keyBoardDuration = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as! AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyBoardFrame!.height
        
        UIView.animate(withDuration: keyBoardDuration!)
        {
            self.view.layoutIfNeeded()
        }
        // move the input area up somehow???
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?

    
    func setupInputComponents()
    {
    
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        //ios9 constraint anchors
        // x,y,w,h
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // This code to add the button
        let sendButton = UIButton(type: .system)
        sendButton.setTitleColor(UIColor.orange, for: .normal)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        inputTextField.textColor = UIColor.orange
        inputTextField.placeholder = "اكتب الرسالة"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(inputTextField)
        //x,y,w,h
        inputTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 8).isActive = true
        inputTextField.textAlignment = .right
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // This code for the separator
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = hexStringToUIColor(hex: "E6E6E6")
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend()
    {
        
        var messagesTexts = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (messagesTexts != "")
        {
            let timestamp = Int(NSDate().timeIntervalSince1970)
            let ref = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(ChatCollectionViewController.messageToId).childByAutoId().updateChildValues(["messageText": inputTextField.text, "messageFrom": WelcomeViewController.user.displayName, "timestamp": timestamp])
        
            let ref2 = FIRDatabase.database().reference().child("Users").child(ChatCollectionViewController.messageToId).child("chat").child(userID).childByAutoId().updateChildValues(["messageText": inputTextField.text, "messageFrom": WelcomeViewController.user.displayName, "timestamp": timestamp])
        
        FIRDatabase.database().reference().child("Users").child(ChatCollectionViewController.messageToId).child("chat").child(userID).child("lastMessage").updateChildValues(["message": inputTextField.text, "time": timestamp])
         FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(ChatCollectionViewController.messageToId).child("lastMessage").updateChildValues(["message": inputTextField.text, "time": timestamp])
                // notificationReference.updateChildValues(["notified": true])
            
        FIRDatabase.database().reference().child("Users").child(ChatCollectionViewController.messageToId).child("chat").child(userID).child("lastMessage").updateChildValues(["new": "true"])
            
        FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(ChatCollectionViewController.messageToId).child("lastMessage").updateChildValues(["new": "false"])
            
            
        }

    }
    
    func observeMessages()
    {
        
        let ovserveReference = FIRDatabase.database().reference().child("Users").child(userID).child("chat").child(ChatCollectionViewController.messageToId)
        
        ovserveReference.observe(.value, with: {snapshot in
            
            self.messagesTimeStamps = [Float]()
            self.messagesTexts =  [String]()
            self.messagesFrom = [String]()
            
            for messages in snapshot.children
            {
                for  message in (messages as! FIRDataSnapshot).children
                {
                    let childValue = String(describing: (message as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                    
                    let childKey = String(describing: (message as! FIRDataSnapshot).key)
                    
                    if childKey == "messageFrom"
                    {
                        self.messagesFrom.append(childValue)
                    }
                        
                    else if childKey == "messageText"
                    {
                        self.messagesTexts.append(childValue)
                    }
                        
                    else if childKey == "timestamp"
                    {
                        self.messagesTimeStamps.append(Float(childValue)!)
                    }
                }
            }
            
            print ("reload the data again")
            self.theProgramJustOpened = true
            self.collectionView?.reloadData()
            self.inputTextField.text = nil
            self.indicator.stopAnimating()
            // scroll to the last index
        })
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messagesTexts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        let message = messagesTexts[indexPath.row]
        cell.textView.text = message
        
        //cell.backgroundColor = UIColor.orange
        //cell.profileImageView = userPhoto as! UIImageView
        
        if messagesFrom[indexPath.row] == WelcomeViewController.user.getUserDisplayName()
        {
            
            // Will make the message orange
            cell.bubbleView.backgroundColor = Constants.FirstColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message).width + 20
            
            
        }
            
        else
        {
            // will make the message gray somehow.
            let color = hexStringToUIColor(hex: "E6E6E6")
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleView.backgroundColor = color
            // This is to put the message to the right
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            var image = UIImage()
            cell.profileImageView.sd_setImage(with: storageRef)
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message).width + 20
        }
        
        
        if (messagesTexts.count - 1 == indexPath.row && theProgramJustOpened)
        {
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            theProgramJustOpened = false
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        // get estimated height somehow??
        
        let text = messagesTexts[indexPath.row]
        height = estimateFrameForText(text: text).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect
    {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            
            self.messagesTimeStamps = [Float]()
            self.messagesTexts =  [String]()
            self.messagesFrom = [String]()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.messagesTimeStamps = [Float]()
        self.messagesTexts =  [String]()
        self.messagesFrom = [String]()
        
        
    }
}
