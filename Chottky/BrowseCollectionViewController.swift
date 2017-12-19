//
//  BrowseViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/11/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import SDWebImage
import FirebaseStorageUI
private let reuseIdentifier = "itemCell"

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {

    
    static var browseNavigaionController: UINavigationController?
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    //This the array were we should declare the items keys.
    var itemKeys = [String]()
    var takePhotoButton = UIButton()    
    var indicator = UIActivityIndicatorView()
    let userID = FIRAuth.auth()!.currentUser!.uid
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.rgb(red: 41, green: 121, blue: 255)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(ItemsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        BrowseCollectionViewController.browseNavigaionController = self.navigationController
      
        
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
        databaseRef = FIRDatabase.database().reference().child("items")
        storageRef = FIRStorage.storage().reference(withPath: "Items_Photos")
        getItems()
        
        initializeIndicatior()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        setupLefMenuProfileImage()
        setupNavigationBarItems()
       // self.present(TabViewProvider.customStyle(), animated: true, completion: nil)
    }

    
    func setupNavigationBarItems()
    {
        var image = UIImage(named: "ic_filter_list_white.png")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickBrowseSettings))
        
        
        var searchBar = UISearchBar()
        searchBar.placeholder = "ابحث في جايلك"
        
        searchBar.tintColor = Constants.FirstColor
        //searchBar.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 40, height: 40))
        // Create your search bar
        self.navigationItem.titleView = searchBar
    }
    
    
    func onClickBrowseSettings()
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let browseSetttingsController = mainStoryboard.instantiateViewController(withIdentifier: "browseSettingsTableViewController") as! BrowseSettingsTableViewController
        self.navigationController?.pushViewController(browseSetttingsController, animated: true)

    }
    
    func presseTakePhotoButton(button: UIButton) {
        
        // At the end of this, remember to add this.
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
        self.navigationController?.pushViewController(cameraViewController, animated: true)
        
    }
    
    func addSellItemButton()
    {
        var takePhotoButton = UIButton()
        takePhotoButton.layer.cornerRadius = 25
        takePhotoButton.layer.masksToBounds = true
        takePhotoButton.frame = CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 75 , width:150 , height:60)
        takePhotoButton.backgroundColor = Constants.FirstColor
        takePhotoButton.layer.shadowOpacity = 5
      //  takePhotoButton.tintColor = UIColor.red
        takePhotoButton.layer.shadowColor = UIColor.black.cgColor
        takePhotoButton.layer.shadowOffset = CGSize.zero
        takePhotoButton.layer.shadowRadius = 10
        takePhotoButton.setTitle("بيع الاشياء خاصتك", for: UIControlState.normal)
        takePhotoButton.addTarget(self, action: #selector(presseTakePhotoButton(button:)), for: .touchUpInside)
        //then make a action method :
        super.view.addSubview(takePhotoButton)
    }
    
    func initializeIndicatior() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
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
                print(itemKey)
            }

            self.collectionView?.reloadData()
            // ...
        })
        
        { (error) in
            
            print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    
    func setupLefMenuProfileImage()
    {
        
        var imageStorageRef: FIRStorageReference = FIRStorage.storage().reference(withPath: "Profile_Pictures")
        imageStorageRef = imageStorageRef.child(userID + "/" + "Profile.jpg")
        LeftMenuTableViewController.profileImageView.sd_setImage(with: imageStorageRef)
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        // #warning Incomplete implementation, return the number of items
        return itemKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemsCell
        cell.backgroundColor = UIColor.yellow
        let imageRef = storageRef.child(itemKeys[indexPath.row]).child("1.jpeg")
       // let placeholderImage = UIImage(named: "placeholder.jpg")
        
        //var image = UIImage()
        cell.itemImageView.sd_setImage(with: imageRef)
        //cell.itemImageView.sd_showActivityIndicatorView()
        //cell.itemImageView.sd_setIndicatorStyle(.gray)
        
        if (indexPath.row == itemKeys.count - 1)
        {
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true

        }
        
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
       return true
        
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.navigationController?.navigationBar.isTranslucent = false
 
        
        ItemViewController.itemKey = itemKeys[indexPath.item]
        let itemStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //self.navigationController?.navigationBar.isTranslucent = true
        let itemViewController = itemStoryBoard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        self.navigationController?.pushViewController(itemViewController, animated: true)
        
        ItemViewController.isItOpenedFromProfileView = false

    }
    
    //These for the number of items my lord
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 16, height: collectionView.bounds.size.height/3 - 16)
        
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
}
