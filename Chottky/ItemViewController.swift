//
//  ItemsViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/15/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ItemImageCell
        
        cell.setupImage(image: UIImage(named: "radibarq")!)
        
        return cell
        
    }


    @IBOutlet weak var imagesCollectionView: UICollectionView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagesCollectionView.register(ItemImageCell.self, forCellWithReuseIdentifier: "imageCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
        
        
    }
    
    //These for the number of items my lord
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
   
        
    }
}
