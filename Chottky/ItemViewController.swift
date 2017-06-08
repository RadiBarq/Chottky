
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

class ItemViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    public static var itemKey: String!
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var clickedImageView: UIImageView?
    var clickedImage: UIImage?
    var itemValues: NSDictionary?
    var favouriteAnimationView = LOTAnimationView(name: "favorite_black")
    @IBOutlet weak var favouriteAnimationSuperView: UIView!
    var loadedImages: [UIImage?] = [nil, nil, nil, nil]
    var favouriteRef: FIRDatabaseReference!
    var isThisFavouriteItem: Bool?
    var itemUserEmail = String()
    var itemUserDisplayName = String()
    var numberOfPhotos:Int = 0
    // This should be pressed when the image clicke
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        
         super.viewDidLoad()
         imagesCollectionView.delegate = self
         imagesCollectionView.dataSource = self
         imagesCollectionView.register(ItemImageCell.self, forCellWithReuseIdentifier: "imageCell")
         self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
         databaseRef = FIRDatabase.database().reference().child("items").child(ItemViewController.itemKey)
         favouriteAnimationSuperView.backgroundColor = .clear
         storageRef = FIRStorage.storage().reference(withPath: "Items_Photos").child(ItemViewController.itemKey)
         favouriteRef = FIRDatabase.database().reference().child("Users").child(WelcomeViewController.user.getEmail()).child("favourites")
        
         addFavouriteAnimationView()
       // playFavouriteAnimation()
        getItemInformation()
        checkIfThisIsFavouriteItem()
        
          // Add the gesture to the photo
          let profilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureClicked))
          profilePicture.addGestureRecognizer(profilePictureTapGesture)
          profilePicture.isUserInteractionEnabled = true
        
         //UIApplication.shared.setStatusBarHidden(false, with: .none)
         self.navigationController?.navigationBar.isTranslucent = true
         //UIApplication.shared.isStatusBarHidden = false
        // self.navigationController?.navigationBar.isHidden = false
         //self.navigationController?.isNavigationBarHidden = false

    }
    
    
    func getItemInformation()
    {
        databaseRef.observe(.value, with: {
        
            (snapsot) in
            
            self.itemValues = snapsot.value as? NSDictionary
            self.updateItemInformation()
        })
        
        {(error) in
            
            
            print(error.localizedDescription)
        }
    }
    
    
    func profilePictureClicked()
    {
        let profileStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        ProfileViewController.isItMyProfile = false

        ProfileViewController.userDisplayName = itemUserDisplayName
        ProfileViewController.userEmail = itemUserEmail
    }
    
    func checkIfThisIsFavouriteItem()
    {
        
        favouriteRef.observe(.value, with: { (
            
            snapshot) in
            
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
    
    @IBAction func contactButtonClicked(_ sender: UIButton) {
        
        ChatCollectionViewController.messageFromDisplayName = itemUserDisplayName
        ChatCollectionViewController.messageToEmail = itemUserEmail
        
        let flowLayout = UICollectionViewFlowLayout()
        let chatLogController = ChatCollectionViewController(collectionViewLayout:flowLayout)
        self.navigationController?.pushViewController(chatLogController, animated: true)
          //self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    func updateItemInformation()
    {
          var title = itemValues?["title"] as! String
          var description = itemValues?["description"] as! String
          var price = itemValues?["price"] as! String
          var currency = itemValues?["currency"] as! String
          itemUserEmail = itemValues?["userEmail"] as! String
          var timetamp = itemValues?["timestamp"] as! Float
          var imageCount = itemValues?["imagesCount"] as! Int
          var profilePictureRef = FIRStorage.storage().reference(withPath: "Profile_Pictures").child(itemUserEmail).child("Profile.jpg")
          itemUserDisplayName = itemValues?["displayName"] as! String
        
          numberOfPhotos = imageCount
          profilePicture.sd_setImage(with: profilePictureRef)
          profilePicture.sd_setIndicatorStyle(.gray)
          titleLabel.text = title
          descriptionLabel.text = description
          priceLabel.text = currency + " " + price
          imagesCollectionView.reloadData()
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(ItemViewController.itemKey)
        let imageRef = storageRef.child(String(indexPath.item + 1) + ".jpeg")
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        
       // cell.itemImageView.sd_showActivityIndicatorView()
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.whiteLarge)
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
            }
        }
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
        
        return CGSize(width: self.view.frame.width, height: 313)
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
    
    func imageTapped(c: ItemImageCell, index: Int) {
        
        // What to do here i like the following my little lord
        let cell = c
        clickedImageView = UIImageView()
        clickedImageView?.image = self.loadedImages[index]
        clickedImageView?.frame = UIScreen.main.bounds
        clickedImageView?.backgroundColor = .black
        clickedImageView?.contentMode = .scaleAspectFit
        clickedImageView?.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        //newImageView.addGestureRecognizer(tap)
        
        let cancelButton  = UIButton(frame: CGRect(x: 20, y: 20.0, width: 15, height: 15.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(dismissFullscreenImage(_:)), for: .touchUpInside)
        clickedImageView?.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
           
              self.view.addSubview(self.clickedImageView!)
              self.clickedImageView?.alpha = 1
            //self.clickedButtonView.transform = CGAffineTransform.identity
        })
        
        self.navigationController?.isNavigationBarHidden = true
        self.clickedImageView?.addSubview(cancelButton)
        UIApplication.shared.isStatusBarHidden = true
        
    }
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.clickedImageView?.alpha = 0
            self.clickedImageView?.removeFromSuperview()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        //self.navigationController?.navigationBar.isTranslucent = true
       // UIApplication.shared.isStatusBarHidden = false
        //self.navigationController?.navigationBar.isHidden = false
       // self.navigationController?.isNavigationBarHidden = fals
        //self.navigationController?.popViewController(animated: false
        
    }
}
