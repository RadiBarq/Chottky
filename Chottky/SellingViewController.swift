//
//  SellingViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/21/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import SDWebImage

class SellingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var databaseRef: FIRDatabaseReference!
    var storageRef:  FIRStorageReference!
    var itemKeys = [String]()
    var indicator = UIActivityIndicatorView()
    let userID = FIRAuth.auth()!.currentUser!.uid
    var counter = 0

    
    //var staticArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        itemsCollectionView.register(ProfileItemsCell.self, forCellWithReuseIdentifier: "cellId")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
         //itemsCollectionView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        // Do any additional setup after loading the view.
        
        if (ProfileViewController.isItMyProfile == true)
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(userID).child("items")
        }
        
        else
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(ProfileViewController.userId).child("items")
        }
        
        storageRef = FIRStorage.storage().reference(withPath: "Items_Photos")
        getItems()
        initializeIndicator()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ItemViewController.itemKey = itemKeys[indexPath.item]
        ItemViewController.isItOpenedFromProfileView = true
        let itemStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let itemViewController = itemStoryBoard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        //    self.navigationController?.isNavigationBarHidden = false
        ProfileViewController.profileNavigationController?.pushViewController(itemViewController, animated: true)
    }

    // Here the code where we can get the items
    func getItems()
    {
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.indicator.startAnimating()
            
            for item in snapshot.children
            {
                let itemKey = String(describing: (item as! FIRDataSnapshot).key)
                self.itemKeys.append(itemKey)
                //print(itemKey)
            }
            
            if (self.itemKeys.count == 0)
            {
                 self.showNoItemLabel()
            }
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.itemsCollectionView.reloadData()
            // ...
        })
            
        { (error) in
            
            print(error.localizedDescription)
        }
    }
    
    func initializeIndicator()
    {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.color = Constants.FirstColor
        indicator.backgroundColor = UIColor.clear
        indicator.center = self.view.center
        indicator.stopAnimating()
        self.view.addSubview(indicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: itemsCollectionView.bounds.size.width/2 - 16, height: itemsCollectionView.bounds.size.height/2 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProfileItemsCell
        cell.backgroundColor = UIColor.white
        let imageRef = storageRef.child(itemKeys[indexPath.row]).child("1.jpeg")
        
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.gray)
        cell.itemImageView.sd_addActivityIndicator()
        cell.itemImageView.sd_setImage(with: imageRef,  placeholderImage: nil, completion:
            
            {  (image, error, cache, ref) in
                
                cell.itemImageView.sd_removeActivityIndicator()
        })
        
        
        return cell
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of items
        return itemKeys.count
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
        noItemLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
