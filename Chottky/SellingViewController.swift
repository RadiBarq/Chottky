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
    
    
    //var staticArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        itemsCollectionView.register(ProfileItemsCell.self, forCellWithReuseIdentifier: "cellId")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        if (ProfileViewController.isItMyProfile == true)
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(WelcomeViewController.user.getEmail()).child("items")
        }
        
        else
        {
            databaseRef = FIRDatabase.database().reference().child("Users").child(ProfileViewController.userEmail).child("items")
        }
        
        storageRef = FIRStorage.storage().reference(withPath: "Items_Photos")
        getItems()
        initializeIndicator()
        indicator.startAnimating()
    }

    // Here the code where we can get the items
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
            }
            
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
        self.view.addSubview(indicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: itemsCollectionView.bounds.size.width/2 - 16, height: itemsCollectionView.bounds.size.height/2)
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
        noItemLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        noItemLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
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
