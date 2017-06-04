//
//  SellingViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/21/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class SellingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
   var staticArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        itemsCollectionView.register(ProfileItemsCell.self, forCellWithReuseIdentifier: "cellId")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        // Do any additional setup after loading the view.
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
        cell.setupImage(image: UIImage(named: staticArray[indexPath.item])!)
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
        if (staticArray.count == 0)
        {
            showNoItemLabel()
            return 0
            
        }

    
        // #warning Incomplete implementation, return the number of items
        return staticArray.count
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
