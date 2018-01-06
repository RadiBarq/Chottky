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
import GeoFire
import Foundation


private let reuseIdentifier = "itemCell"

class BrowseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, CLLocationManagerDelegate {
    
    static var browseNavigaionController: UINavigationController?
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    //This the array were we should declare the items keys.
    var itemKeys = [String]() // this is for the geofire here
    var takePhotoButton = UIButton()    
    var indicator = UIActivityIndicatorView()
    let userID = FIRAuth.auth()!.currentUser!.uid
    var stringLocation = String()
    var locationManager: CLLocationManager = CLLocationManager()
    let geofireRef = FIRDatabase.database().reference().child("items-location")
    var radius = Int()
    var weGotFirstLocation = false
    var locationDisabledLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var locationDisabledButton  = UIButton(frame: .zero)
    var noItemAvailableLabel = UILabel(frame: .zero)
    var itemsDictionary: [String:Item] = [:]
    
    // these are the category-array of values here mother fucker
    var carCategoryArray = [String]()
    var phoneCategoryArray = [String]()
    var apartmentCategoryArray = [String]()
    var homeCategoryArray = [String]()
    var dogCategoryArray = [String]()
    var sportCategoryArray = [String]()
    var clothesCategoryArray = [String]()
    var kidsCategoryArray = [String]()
    var booksCategoryArray = [String]()
    var otherCategoryArray = [String]()
    static var queryChanged = false
    var finalArray =  [String]()
    var maximumRadius = Int()
    static var arrayLocation = [String]()
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //   UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        //        navigationController??.navigationBar.barTintColor = .orange
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.rgb(red: 41, green: 121, blue: 255)
        setupLefMenuProfileImage()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if (BrowseCollectionViewController.queryChanged == true)
        {
            itemKeys = []
            self.locationDisabledLabel.removeFromSuperview()
            self.locationDisabledButton.removeFromSuperview()
            
            if (BrowseSettingsTableViewController.selectedDistanceIndex == 0)
            {
                 maximumRadius = 1
                
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 1)
            {
                maximumRadius = 5
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 2)
            {
                maximumRadius = 10
                
            }
            
            else if (BrowseSettingsTableViewController.selectedDistanceIndex == 3)
            {
                maximumRadius = 100
                
            }
            
            getItems()
            BrowseCollectionViewController.queryChanged = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(ItemsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        BrowseCollectionViewController.browseNavigaionController = self.navigationController
        
        self.navigationController?.navigationBar.isTranslucent = false
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.rgb(red: 41, green: 121, blue: 255)
        //statusBar.tintColor = UIColor.white
        
         radius = 10
        
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
        
        initializeIndicatior()
        indicator.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        setupNavigationBarItems()
        
        _ = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { (
            time) in
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.weGotFirstLocation = false
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
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
    
    func initializeNoItemAvailable()
    {
        self.view.addSubview(noItemAvailableLabel)
        noItemAvailableLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemAvailableLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        noItemAvailableLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        noItemAvailableLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        noItemAvailableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noItemAvailableLabel.textColor = Constants.FirstColor
        noItemAvailableLabel.lineBreakMode = .byWordWrapping
        noItemAvailableLabel.numberOfLines = 2
        noItemAvailableLabel.text = "لم نتمكن من ايجاد اي نتائج بالقرب منك، حاول البحث عن شئ اخر او حاول في وقت لاحق!"
        noItemAvailableLabel.textAlignment = .center
    }
    
    func fetchGeofireDataToDictionary()
    {
        itemsDictionary = [:] // this is how to make the dictionary empty in this case
        for i in 0..<itemKeys.count
        {
            var oneItem = Item()
            var valueRef = FIRDatabase.database().reference().child("items").child(itemKeys[i]).observeSingleEvent(of: .value, with: {(snapshot)
                in
                for item in snapshot.children
                {
                    let childValue = String(describing: (item as! FIRDataSnapshot).value!) // Remeber this value maybe value.
                    let childKey = String(describing: (item as! FIRDataSnapshot).key)
                    
                    if (childKey == "category")
                    {
                        oneItem.category = childValue as! String
                        
                        if (childValue == "category-car")
                        {
                            self.carCategoryArray.append(self.itemKeys[i])
                        }
                            
                        else if (childValue == "phone-category")
                        {
                            self.phoneCategoryArray.append(self.itemKeys[i])
                        }
                            
                            
                        else if (childValue == "category-aparment")
                        {
                            self.apartmentCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else if (childValue == "category-home")
                        {
                            self.homeCategoryArray.append(self.itemKeys[i])
                        }
                            
                        else if (childValue == "category-dog")
                        {
                            
                            self.dogCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else if (childValue == "category-sport")
                        {
                            self.sportCategoryArray.append(self.itemKeys[i])
                        }
                            
                        else if (childValue == "category-clothes")
                        {
                            
                            self.clothesCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else if (childValue == "category-kids")
                        {
                            self.kidsCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else if (childValue == "category-books")
                        {
                            
                            self.booksCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else if (childValue == "category-others")
                        {
                            self.otherCategoryArray.append(self.itemKeys[i])
                            
                        }
                            
                        else
                        {
                            print("There is an issue with the category-type fellow")
                            
                        }
                    }
                        
                    else if (childKey == "currency")
                    {
                        oneItem.currency = childValue as! String
                        
                    }
                        
                    else if (childKey == "description")
                    {
                        
                        oneItem.description = childValue as String
                    }
                        
                    else if (childKey == "displayName")
                    {
                        
                        oneItem.displayName = childValue as! String
                        
                    }
                        
                    else if (childKey == "imagesCount")
                    {
                        
                        oneItem.imagesCount = childValue as! String
                    }
                        
                    else if (childKey == "price")
                    {
                        
                        oneItem.price = childValue as! String
                    }
                        
                    else if (childKey == "timestamp")
                    {
                        
                        oneItem.timestamp = childValue as! String
                    }
                        
                    else if (childKey == "title")
                    {
                        
                        oneItem.title = childValue as! String
                    }
                        
                    else if (childKey == "userId")
                    {
                        oneItem.userId = childValue as! String
                    }
                        
                    else
                    {
                        print("On of the keys is wrong in this case my lord.")
                    }
            
                    self.itemsDictionary[self.itemKeys[i]] = oneItem
                }
                
                if (i == self.itemKeys.count - 1)
                {
                    self.categoryQuery()
                    self.collectionView?.reloadData()
                }
            })
        }
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
        return finalArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemsCell
        cell.backgroundColor = UIColor.white
        let imageRef = storageRef.child(finalArray[indexPath.row]).child("1.jpeg")
        // let placeholderImage = UIImage(named: "placeholder.jpg")
        
        //var image = UIImage()
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.gray)
        cell.itemImageView.sd_addActivityIndicator()
        cell.itemImageView.sd_setImage(with: imageRef,  placeholderImage: nil, completion:
            
            {  (image, error, cache, ref) in
                
                cell.itemImageView.sd_removeActivityIndicator()
                //  self.loadedImages[indexPath.item] = image
        })
        
        //cell.itemImageView.sd_showActivityIndicatorView()
        //cell.itemImageView.sd_setIndicatorStyle(.gray)
        
        if (indexPath.row == finalArray.count - 1)
        {
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
        
        return cell
    }
    
    @IBAction func onClickShowMenu(_ sender: UIButton) {
        
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
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
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        
        if (weGotFirstLocation == false)
        {
            let latestLocation: CLLocation = locations[locations.count - 1]
            stringLocation = String(latestLocation.coordinate.latitude)  + " " + String(latestLocation.coordinate.longitude)
            print(stringLocation)
            locationManager.stopUpdatingLocation()
            weGotFirstLocation = true
            itemKeys = []
            self.locationDisabledLabel.removeFromSuperview()
            self.locationDisabledButton.removeFromSuperview()
            getItems()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                initializeDisabledLocationComponents()
                print("Location services are not enabled")
                itemKeys = []
                weGotFirstLocation = false
                self.collectionView?.reloadData()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
            
            
        else {
            
        }
    }
    
    func initializeDisabledLocationComponents()
    {
        var alertEmailController = UIAlertController(title: "لم يتمكن جايلك من الحصول على موقعك", message: "لتمكين خدمة الموقع الرجاء الذهاب الى الاعدادات و من ثم Gayelak و من ثم الموقع و من ثم تمكين خدمة الموقع اثناء استخدام التطبيق", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
        alertEmailController.addAction(defaultAction)
        self.present(alertEmailController, animated: true, completion: nil)
        
        // initalize location disabled label
        self.view.addSubview(locationDisabledLabel)
        locationDisabledLabel.translatesAutoresizingMaskIntoConstraints = false
        locationDisabledLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        locationDisabledLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        locationDisabledLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationDisabledLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationDisabledLabel.textColor = Constants.FirstColor
        locationDisabledLabel.text = "لم يتمكن جايلك من الحصول على موقعك"
        
        locationDisabledButton.setTitle("الذهاب الى الاعدادات", for: .normal)
        locationDisabledButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(locationDisabledButton)
        locationDisabledButton.addTarget(self, action: #selector(goToLocationSettings), for: .touchUpInside)
        locationDisabledButton.backgroundColor = Constants.FirstColor
        locationDisabledButton.topAnchor.constraint(equalTo:  locationDisabledLabel.bottomAnchor, constant: 50).isActive = true
        locationDisabledButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationDisabledButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
        locationDisabledButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        locationDisabledButton.layer.cornerRadius = 35
        locationDisabledButton.layer.masksToBounds = true
    }
    
    func goToLocationSettings()
    {
        UIApplication.shared.open(URL(string:"App-Prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
        print("hi")
    }
    
    func getItems()
    {
        // we should make sure that the location is available here.
        indicator.startAnimating()
        BrowseCollectionViewController.arrayLocation = stringLocation.components(separatedBy: " ")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let lat = Double(BrowseCollectionViewController.arrayLocation[0])
        let lon = Double(BrowseCollectionViewController.arrayLocation[1])
        var queryHandle = geoFire?.query(at: CLLocation(latitude: lat!, longitude: lon!), withRadius: Double(radius))
        
        queryHandle?.observe(.keyEntered) { (key, location) in
            self.itemKeys.append(key!)
        }
    
        queryHandle?.observeReady({
            
            if (self.itemKeys.count == 0)
            {
                self.indicator.stopAnimating()
                self.initializeNoItemAvailable()
            }
                
            else if (self.itemKeys.count < 6 && self.radius <= self.maximumRadius )
            {
                
                self.radius = self.radius + 5
            }
                
            else
            {
                // this is when the items are ready in this scenario
                self.finalArray = self.itemKeys
                self.fetchGeofireDataToDictionary()
                queryHandle?.removeAllObservers()
                
            }
        })
    }

    
    func categoryQuery()
    {
        
        var itemsRef = FIRDatabase.database().reference().child("items")
        let givenSet:Set<String> = Set(finalArray)
        var carsSet:Set<String> = Set(carCategoryArray)
        var phonesSet:Set<String> = Set(phoneCategoryArray)
        var apartmentSet:Set<String> = Set(apartmentCategoryArray)
        var homeSet: Set<String> = Set(homeCategoryArray)
        var dogSet: Set<String> = Set(dogCategoryArray)
        var sportSet: Set<String> = Set(sportCategoryArray)
        var clothesSet: Set<String> = Set(clothesCategoryArray)
        var kidsSet: Set<String> = Set(kidsCategoryArray)
        var booksSet: Set<String> = Set(booksCategoryArray)
        var othersSet: Set<String> = Set(otherCategoryArray)
        var finalSet: Set<String> = Set()
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![0] == 1)
        {
            //cars
           // carsSet = carsSet.intersection(givenSet)
            finalSet = finalSet.union(carsSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![1] == 1)
        {
            //electronics
            //phonesSet =  phonesSet.intersection(givenSet)
            finalSet =  finalSet.union(phonesSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![2] == 1)
        {
            // lands and aparatments
          //  apartmentSet =  apartmentSet.intersection(givenSet)
            finalSet = finalSet.union(apartmentSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![3] == 1)
        {
            // home and garden
           // homeSet = homeSet.intersection(givenSet)
            finalSet = finalSet.union(homeSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![4] == 1)
        {
            // animals
            //dogSet = dogSet.intersection(givenSet)
            finalSet = finalSet.union(dogSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![5] == 1)
        {
            //sports and games
           // sportSet = sportSet.intersection(givenSet)
            finalSet = finalSet.union(sportSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![6] == 1)
        {
            // clothes and accessories
           // clothesSet = clothesSet.intersection(givenSet)
            finalSet = finalSet.union(clothesSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![7] == 1)
        {
            //kids
            //kidsSet = kidsSet.intersection(givenSet)
            finalSet = finalSet.union(kidsSet)
            
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![8] == 1)
        {
            // books and movies
            //booksSet = booksSet.intersection(givenSet)
            finalSet = finalSet.union(booksSet)
        }
        
        if (BrowseSettingsTableViewController.selectedCategoriesIndexes![9] == 1)
        {
            // others
           // othersSet = othersSet.intersection(givenSet)
            finalSet = finalSet.union(othersSet)
        }
        
        if (finalSet.isEmpty == true)
        {
            finalArray = Array(givenSet)
        }
            
        else
        {
            finalArray = Array(finalSet)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.navigationController?.navigationBar.isTranslucent = false
        
        ItemViewController.itemKey = finalArray[indexPath.item]
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
    
    
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, unit: String) -> Double
    {
        
        // this function will return the distance my lord.
        
        var radlat1 = Double.pi * lat1 / 180
        
        var radlat2 = Double.pi * lat2 / 180
        
        var radlon1 = Double.pi * lon1 / 180
        
        var radlon2 = Double.pi * lon2 / 180
        
        var theta = lon1 - lon2
        
        var radtheta = Double.pi * theta/180
        
        var dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta)
        
        dist = acos(dist)
        
        dist = dist * 180 / Double.pi
        
        dist = dist * 60 * 1.1515
        
        if unit == "k"
        {
            dist = dist * 1.609344
        }
        
        if unit == "m"
        {
            dist = dist * 0.8684
        }
        
        return dist
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
