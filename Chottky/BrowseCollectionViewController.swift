//
//  BrowseViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SideMenu

private let reuseIdentifier = "leftMenuBarCell"

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: LeftMenuTableViewController())
        menuLeftNavigationController.leftSide = true
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        
        SideMenuManager.MenuPresentMode.menuDissolveIn
        SideMenuManager.menuAnimationBackgroundColor = UIColor.white
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
        var takePhotoButton = UIButton()
        takePhotoButton.layer.cornerRadius = 24
        takePhotoButton.layer.masksToBounds = true
        takePhotoButton.frame = CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 75 , width:150 , height:60)
        takePhotoButton.backgroundColor = UIColor.cyan
        takePhotoButton.tintColor = UIColor.red
        takePhotoButton.layer.shadowColor = UIColor.black.cgColor
        takePhotoButton.layer.shadowOffset = CGSize(width:10, height: 10)
        takePhotoButton.layer.shadowRadius = 24
        takePhotoButton.setTitle("بيع الاشياء خاصتك", for: UIControlState.normal)
        super.view.addSubview(takePhotoButton)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of items
        return 100
        

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.yellow
        
        
        return cell
    }

    
    @IBAction func onClickShowMenu(_ sender: UIButton) {

        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)        
        
    }

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
       return true
        
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return true

    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
    
    //These for the number of items my lord
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 16, height: collectionView.bounds.size.height/4)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
}
