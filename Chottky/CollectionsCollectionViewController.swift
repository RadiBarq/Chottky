//
//  CollectionsCollectionViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/14/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CollectionsCollectionViewController: UICollectionViewController,  UICollectionViewDelegateFlowLayout {
    
    var categriesPhotosArray = ["category-car", "phone-category", "category-aparment", "category-home", "category-dog", "category-sport", "category-clothes", "category-kids", "category-books", "category-others"]
    let categorisTextArray = ["سيارات","الكترونيات","شقق و اراضي","البيت و الحديقة","حيوانات","الرياضة و الالعاب","ملابس و اكسسوارات","الاطفال","افلام، كتب و اغاني","اغراض اخرى"]
    var selectedInex = 0
    
    // this should be enum in the future here my lord.
    static var presentedFor = "discover"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(CollectionsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // self.collectionView?.delegate = self
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        unselectRowsInSection(rowsCount: 10, section: 1)
        if (CollectionsCollectionViewController.presentedFor == "discover")
        {
            title = "اكتشف"
        }
            
        else
        {
            title = "نوع المنتج الذي تريد بيعه"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "نشر", style: .done, target: self, action: #selector(resetButtonClicked))
        }
    }
    
    func resetButtonClicked()
    {
        FIRDatabase.database().reference().child("items").child(PostedItemViewController.itemId).updateChildValues(["category":categriesPhotosArray[selectedInex]])
            CollectionsCollectionViewController.presentedFor = "sell"
        
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
            self.present(tabViewController, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = " "
        
        if (CollectionsCollectionViewController.presentedFor == "sell")
        {
            
            CollectionsCollectionViewController.presentedFor = "discover"
            
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categriesPhotosArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionsCell
        cell.setImage(image: UIImage(named: categriesPhotosArray[indexPath.row])!)
        cell.setUpLabel(text: categorisTextArray[indexPath.row])
        // Configure the cell
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionsCell
        
        if (CollectionsCollectionViewController.presentedFor == "discover")
        {
            BrowseSettingsTableViewController.selectedCategoriesIndexes = [0, 0 , 0, 0, 0, 0, 0, 0, 0, 0]
            BrowseSettingsTableViewController.selectedCategoriesIndexes![indexPath.row + indexPath.section] = 1
            selectedCell.backgroundColor = UIColor.lightGray
            BrowseCollectionViewController.queryChanged = true
            self.tabBarController?.selectedIndex = 0
        }
            
        else
        {
            
            unselectRowsInSection(rowsCount:categorisTextArray.count , section: 0)
          //  print(categriesPhotosArray[indexPath.row + indexPath.section])
            selectedCell.backgroundColor = UIColor.lightGray
            selectedInex = indexPath.row + indexPath.section
            
        }
    }
    
    func unselectRowsInSection(rowsCount: Int, section: Int)
    {
        for row in 0 ..< rowsCount
        {
            var indexPath  = NSIndexPath(row: row, section: 0)
            var selectedCell = self.collectionView?.cellForItem(at: indexPath as IndexPath ) as? CollectionsCell
            
            if (selectedCell != nil)
            {
                selectedCell!.backgroundColor = UIColor.white
                //cell?.removeImageView()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 0.5, height: collectionView.bounds.size.height/4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
