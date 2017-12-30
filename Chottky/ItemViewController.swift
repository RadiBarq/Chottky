
//  ItemsViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/15/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorageUI
import Lottie

class ItemViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate{
    
    public static var itemKey: String!
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var clickedImageView: UIImageView?
      var scrollView = UIScrollView()
    var clickedImage: UIImage?
    var itemValues: NSDictionary?
    var favouriteAnimationView = LOTAnimationView(name: "favorite_black")
    @IBOutlet weak var favouriteAnimationSuperView: UIView!
    var loadedImages: [UIImage?] = [nil, nil, nil, nil]
    var favouriteRef: FIRDatabaseReference!
    var isThisFavouriteItem: Bool?
    var itemUserId = String()
    var itemUserDisplayName = String()
    var soldItemsRef: FIRDatabaseReference!
    var favouriteNotificationRef: FIRDatabaseReference!
    static var isItOpenedFromProfileView = Bool()
    
    var numberOfPhotos:Int = 0
    // This should be pressed when the image clicke
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    var indicator = UIActivityIndicatorView()
    
    let userID = FIRAuth.auth()!.currentUser!.uid
    
    override func viewDidLoad() {
        
         super.viewDidLoad()
         imagesCollectionView.delegate = self
         imagesCollectionView.dataSource = self
         imagesCollectionView.register(ItemImageCell.self, forCellWithReuseIdentifier: "imageCell")
     
         self.scrollView.delegate = self
       //  self.navigationController?.navigationBar.isTranslucent = false
         //self.navigationController?.isNavigationBarHidden = true
         // Do any additional setup after loading the view.
        
         databaseRef = FIRDatabase.database().reference().child("items").child(ItemViewController.itemKey)
         favouriteAnimationSuperView.backgroundColor = .clear
         storageRef = FIRStorage.storage().reference(withPath: "Items_Photos").child(ItemViewController.itemKey)
         favouriteRef = FIRDatabase.database().reference().child("Users").child(userID).child("favourites")
         soldItemsRef = FIRDatabase.database().reference().child("Users").child(userID).child("sold_items")
        
         addFavouriteAnimationView()
         // playFavouriteAnimation()
         getItemInformation()
         checkIfThisIsFavouriteItem()
          // Add the gesture to the photo
         let profilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureClicked))
         profilePicture.addGestureRecognizer(profilePictureTapGesture)
         profilePicture.isUserInteractionEnabled = true
         //UIApplication.shared.setStatusBarHidden(false, with: .none)
         // Fself.navigationController?.navigationBar.isTranslucent = true
         //UIApplication.shared.isStatusBarHidden = false
        // self.navigationController?.navigationBar.isHidden = false
         //self.navigationController?.isNavigationBarHidden = false
        
        initializeIndicatior()
        indicator.startAnimating()
        
    }
    
    func getItemInformation()
    {
        databaseRef.observeSingleEvent(of: .value, with: {
        
            (snapsot) in
            
            self.itemValues = snapsot.value as? NSDictionary
            self.updateItemInformation()
        })
    }
    
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.color = Constants.FirstColor
        indicator.center = self.view.center
       // indicator.stopAnimating()
        self.view.addSubview(indicator)
    }
    func profilePictureClicked()
    {
        if (ItemViewController.isItOpenedFromProfileView == false)
        {
            //ProfileViewController.isItMyProfile = false
            ProfileViewController.userDisplayName = itemUserDisplayName
            ProfileViewController.userId = itemUserId
            
            let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
            
        else
        {
            ProfileViewController.userDisplayName = itemUserDisplayName
            ProfileViewController.userId = itemUserId
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkIfThisIsFavouriteItem()
    {
           favouriteRef.observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            if snapshot.hasChild(ItemViewController.itemKey){
                
                self.isThisFavouriteItem = true
                self.favouriteAnimationView?.animationProgress  = 0.9
            }
                
            else{
                
                self.isThisFavouriteItem = false
                print("false room doesn't exist")
                
            }
        })
    }
    
    func addFavouriteNotification() // Here is a very important point to discuss.
    {
        favouriteNotificationRef = FIRDatabase.database().reference().child("Users").child(itemUserId).child("notifications").child(ItemViewController.itemKey)
        var itemKey = ItemViewController.itemKey
        let timestamp = Int(NSDate().timeIntervalSince1970)
        favouriteNotificationRef.updateChildValues(["userId": userID, "itemId": ItemViewController.itemKey, "new": "true", "timestamp": timestamp, "type" : "favourite", "userName": WelcomeViewController.user.getUserDisplayName()])
    }
    
    @IBAction func contactButtonClicked(_ sender: UIButton) {
        
        if !(self.itemUserId == userID)
        {
            ChatCollectionViewController.messageFromDisplayName = itemUserDisplayName
            ChatCollectionViewController.messageToId = itemUserId
            let flowLayout = UICollectionViewFlowLayout()
            let chatLogController = ChatCollectionViewController(collectionViewLayout:flowLayout)
            self.navigationController?.pushViewController(chatLogController, animated: true)
            //self.navigationController?.pushViewController(chatLogController, animated: true
        }
            
        else
        {

            FIRDatabase.database().reference().child("items").child(ItemViewController.itemKey).removeValue()
                FIRDatabase.database().reference().child("Users").child(userID).child("items").child(ItemViewController.itemKey).removeValue()
                var itemKey = ItemViewController.itemKey!
                self.soldItemsRef.updateChildValues([itemKey: ""])
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateItemInformation()
    {
        
        
          var title = itemValues?["title"] as! String
          var description = itemValues?["description"] as! String
          var price = itemValues?["price"] as! String
          var currency = itemValues?["currency"] as! String
          itemUserId = itemValues?["userId"] as! String
          var timetamp = itemValues?["timestamp"] as! Float
          var imageCount = itemValues?["imagesCount"] as! Int
          var profilePictureRef = FIRStorage.storage().reference(withPath: "Profile_Pictures").child(itemUserId).child("Profile.jpg")
          itemUserDisplayName = itemValues?["displayName"] as! String
         self.navigationController?.navigationBar.topItem?.title = itemUserDisplayName
          numberOfPhotos = imageCount
        
          profilePicture.sd_setShowActivityIndicatorView(true)
          profilePicture.sd_setIndicatorStyle(.gray)
          profilePicture.sd_addActivityIndicator()
          profilePicture.sd_setImage(with: profilePictureRef,  placeholderImage: nil, completion:
       
            {  (image, error, cache, ref) in
                
                self.profilePicture.sd_removeActivityIndicator()
            })
    
          //rofilePicture.sd_setImage(with: profilePictureRef)
          //profilePicture.sd_setIndicatorStyle(.gray)
          titleLabel.text = title
          descriptionLabel.text = description
          priceLabel.text = currency + " " + price
        
        //Here check if this item for the same user
        if (itemUserId == userID)
        {
            bottomButton.setTitle("تم بيع هاذا المنتج", for: .normal)
            favouriteAnimationSuperView.isHidden = true
        }
            
        else{
            
            bottomButton.setTitle("تواصل", for: .normal)
        }
        
          indicator.stopAnimating()
          imagesCollectionView.reloadData()
    }

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(ItemViewController.itemKey)
        let imageRef = storageRef.child(String(indexPath.item + 1) + ".jpeg")
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        
       // cell.itemImageView.sd_showActivityIndicatorView()
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.gray)
        cell.itemImageView.sd_addActivityIndicator()
        cell.itemImageView.sd_setImage(with: imageRef,  placeholderImage: nil, completion:
            
            {  (image, error, cache, ref) in
                
                cell.itemImageView.sd_removeActivityIndicator()
                self.loadedImages[indexPath.item] = image
            })
       // cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
    func addFavouriteAnimationView()
    {
        let favouriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(playFavouriteAnimation(_sender:)))
        favouriteAnimationView?.isUserInteractionEnabled = true
        favouriteAnimationView?.addGestureRecognizer(favouriteTapGesture)
        favouriteAnimationSuperView.addSubview(favouriteAnimationView!)
        favouriteAnimationView?.centerXAnchor.constraint(equalTo: (favouriteAnimationSuperView?.centerXAnchor)!).isActive = true
        favouriteAnimationView?.centerYAnchor.constraint(equalTo: (favouriteAnimationSuperView?.centerYAnchor)!).isActive = true
        favouriteAnimationView?.widthAnchor.constraint(equalToConstant: 175).isActive = true
        favouriteAnimationView?.heightAnchor.constraint(equalToConstant: 175).isActive = true
        favouriteAnimationView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func playFavouriteAnimation(_sender: UITapGestureRecognizer){
        
        if (isThisFavouriteItem == false)
        {
            favouriteAnimationView?.animationProgress  = 0.4
            //favouriteAnimationView?.animationSpeed = 2
            favouriteAnimationView?.loopAnimation = false
            favouriteAnimationView?.play()
            let when = DispatchTime.now() + 0.7 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
            self.favouriteAnimationView?.animationProgress  = 0.9
            var itemKey = ItemViewController.itemKey!
            self.favouriteRef.updateChildValues([itemKey : ""])
            self.isThisFavouriteItem = true
            self.addFavouriteNotification()
            }
        }
            
        else
        {
            self.removeFavouriteAnimation()
        }
    }

    func removeFavouriteAnimation()
    {
        self.isThisFavouriteItem = false
        var itemKey = ItemViewController.itemKey!
        
       self.favouriteAnimationView?.animationProgress  = 0.9
        
        favouriteAnimationView?.loopAnimation = false
        
        favouriteAnimationView?.play()
        let when = DispatchTime.now() + 0.7 // change 2 to desired number of seconds
           DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.favouriteAnimationView?.animationProgress  = 0.3
        }
        
        removeFavouriteFromFirebase()
    }
    
    func removeFavouriteFromFirebase()
    {
            let ref = FIRDatabase.database().reference().child("notification")
        FIRDatabase.database().reference().child("Users").child(itemUserId).child("notifications").child(ItemViewController.itemKey).removeValue()
        FIRDatabase.database().reference().child("Users").child(userID).child("favourites").child(ItemViewController.itemKey).removeValue()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        clickedImage = cell.itemImageView.image
        imageTapped(c: cell, index: indexPath.item)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfPhotos
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 325)
        // your code here
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setupTheCloseButton()
    {
        let backButton = UIButton(frame: CGRect(x: 20, y: 20 , width: 35, height: 35))
        self.view.addSubview(backButton)
        backButton.layer.cornerRadius = 17.5
        backButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let iconImageView = UIImageView(frame: CGRect(x:0, y: 0, width: 10, height: 10))
         backButton.addSubview(iconImageView)
        iconImageView.image = UIImage(named: "btn-back-96")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor).isActive = true
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }

    func dismissView()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func imageTapped(c: ItemImageCell, index: Int) {
        
        // This is when one of the cell image clicked, watch out!!
        // What to do here i like the following my little lord
        let cell = c
        clickedImageView = UIImageView()
        
        scrollView.frame = UIScreen.main.bounds
        
        clickedImageView?.image = self.loadedImages[index]
        clickedImageView?.frame = UIScreen.main.bounds
        clickedImageView?.backgroundColor = .black
        clickedImageView?.contentMode = .scaleAspectFit
        clickedImageView?.isUserInteractionEnabled = true
        scrollView.addSubview(clickedImageView!)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        //newImageView.addGestureRecognizer(tap)
        let cancelButton  = UIButton(frame: CGRect(x: 30, y: 30.0, width: 15, height: 15.0))
       // cancelButton.backgroundColor = UIColor.gray
        // var imageView = UIImageView(frame: CGRect(x: 0,y: 0, width: 5, height: 5))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        
        self.tabBarController?.tabBar.isHidden = true
        
        cancelButton.addTarget(self, action: #selector(dismissFullscreenImage(_:)), for: .touchUpInside)
        clickedImageView?.alpha = 0
       // self.navigationController?.navigationBar.isTranslucent = true
        
        UIView.animate(withDuration: 0.3, animations: {
           
            self.view.addSubview(self.scrollView)
              self.clickedImageView?.alpha = 1
            //self.clickedButtonView.transform = CGAffineTransform.identity
        })
        
        //self.navigationController?.isNavigationBarHidden = true
        self.clickedImageView?.addSubview(cancelButton)
      //  UIApplication.shared.isStatusBarHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
            return self.clickedImageView
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
       // self.navigationController?.isNavigationBarHidden = false
       // UIApplication.shared.isStatusBarHidden = false
        
       // self.navigationController?.navigationBar.isTranslucent = true
        
         self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.clickedImageView?.alpha = 0
            self.scrollView.removeFromSuperview()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true     //   self.navigationController?.navigationBar.isTranslucent = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.clear
         UIApplication.shared.statusBarStyle = .lightContent
        statusBar.tintColor = UIColor.white
        setupTheCloseButton()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(false)
       // self.navigationController?.isNavigationBarHidden = false
      //  self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        //self.navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.rgb(red: 41, green: 121, blue: 255)
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.isNavigationBarHidden = fals
        //self.navigationController?.popViewController(animated: false
    }
}
