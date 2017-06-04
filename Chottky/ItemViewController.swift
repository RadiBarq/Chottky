
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
    
    var favouriteAnimationView = LOTAnimationView(name: "favorite_black")
    @IBOutlet weak var favouriteAnimationSuperView: UIView!
    // This should be pressed when the image clicked

    
    override func viewDidLoad() {
        
         super.viewDidLoad()
         imagesCollectionView.delegate = self
         imagesCollectionView.dataSource = self
         imagesCollectionView.register(ItemImageCell.self, forCellWithReuseIdentifier: "imageCell")
         self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
         databaseRef = FIRDatabase.database().reference()
         favouriteAnimationSuperView.backgroundColor = .clear
         addFavouriteAnimationView()
       // playFavouriteAnimation()
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         storageRef = FIRStorage.storage().reference(withPath: "Items_Photos")
        print(ItemViewController.itemKey)
        let imageRef = storageRef.child(ItemViewController.itemKey + "/" + "1.jpg")
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        cell.itemImageView.sd_setImage(with: imageRef)
        cell.itemImageView.sd_showActivityIndicatorView()
        cell.itemImageView.sd_setIndicatorStyle(.gray)
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
        
        favouriteAnimationView?.animationProgress  = 0.4
         //favouriteAnimationView?.animationSpeed = 2
        favouriteAnimationView?.loopAnimation = false
        favouriteAnimationView?.play()
        let when = DispatchTime.now() + 0.7 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.favouriteAnimationView?.animationProgress  = 0.9
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        clickedImage = cell.itemImageView.image
        imageTapped(c: cell)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
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
    
    func imageTapped(c: ItemImageCell) {
        
        // What to do here i like the following my little lord
        let cell = c
        
        clickedImageView = UIImageView()
        clickedImageView?.image = self.clickedImage
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        // self.navigationController?.popViewController(animated: false)
        
    }
    
}
