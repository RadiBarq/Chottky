//
//  SoldViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/21/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import SDWebImage

class SoldViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
      var staticArray = ["nike_shoes-1", "nike_shoes-1", "nike_shoes", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1" , "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1", "nike_shoes-1"]
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    var itemKeys = [String]()
    var indicator = UIActivityIndicatorView()
    let userID = FIRAuth.auth()!.currentUser!.uid

    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemsCollectionView.register(ProfileItemsCell.self, forCellWithReuseIdentifier: "cellId")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
       // itemsCollectionView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        if (ProfileViewController.isItMyProfile == true)
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(userID).child("sold_items")
        }
            
        else
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(ProfileViewController.userId).child("sold_items")
        }
        
        storageRef = FIRStorage.storage().reference(withPath: "Items_Photos")
        getItems()
    }
    
    
    func initializeIndicator()
    {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.color = Constants.FirstColor
        indicator.backgroundColor = UIColor.clear
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    func getItems()
    {
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for item in snapshot.children
            {
                let itemKey = String(describing: (item as! FIRDataSnapshot).key)
                self.itemKeys.append(itemKey)
                //print(itemKey)
            }
            
            if (self.itemKeys.count == 0)
            {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.showNoItemLabel()
            }
            
            self.itemsCollectionView.reloadData()
            // ...
        })
            
        { (error) in
            
            print(error.localizedDescription)
        }
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
        cell.itemImageView.sd_setImage(with: imageRef)
        
        if (indexPath.row == itemKeys.count - 1)
        {
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
        
        return cell
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
        
        //This is temporary
        // #warning Incomplete implementation, return the number of items
        return itemKeys.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNoItemLabel()
    {
        var noItemLabel = UILabel()
        self.view.addSubview(noItemLabel)
        noItemLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemLabel.textColor = Constants.FirstColor
        noItemLabel.text = "لا يوجد منتجات مبيوعة"
        noItemLabel.textAlignment = .right
        noItemLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        noItemLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noItemLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ItemViewController.itemKey = itemKeys[indexPath.item]
        ItemViewController.isItOpenedFromProfileView = true
        let itemStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let itemViewController = itemStoryBoard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        ProfileViewController.profileNavigationController?.pushViewController(itemViewController, animated: true)
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
