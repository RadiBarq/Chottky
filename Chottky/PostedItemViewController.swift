//
//  AddPriceViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/19/17.
//  Copyright © 2017 Chottky. All rights reserved.
//
import UIKit
import Firebase
import GeoFire
import CoreLocation

class PostedItemViewController: UIViewController, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate{
    
    
    var cellId = "cellId"
    static var imagesValid = [false, false, false, false]
    static var images:[UIImage?] = [nil, nil, nil, nil]
    // This is for testing should be removed later on
    var test_images: [UIImage?] = [UIImage(named: "nike_shoes-1"), UIImage(named: "nike_shoes"), UIImage(named: "nike_shoes-2")]
    
    var test_images_names: [String] = ["1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg"]
    
    var categoryItems = ["سيارات", "الكترونيات", "شقق و اراضي", ]
    
    @IBOutlet weak var postButton: UIButton!
    
    
    
    static var imageClickedNumber: Int = 0
    static var imageClicked: UIImage?
    var imageLibraryController = UIImagePickerController()
    // This is to check weather the view disappear for the backbutton or others
    static var isItFirstTimeOnThisView: Bool = true
    //static var backButtonPressed: Bool = false
    // static var firstImage: UIImage?
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var currencySegemnted: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceField: UITextField!
    
    let userID = FIRAuth.auth()!.currentUser!.uid
    var locationManager: CLLocationManager = CLLocationManager()
    var indicatior = UIActivityIndicatorView()
    var stringLocation:String = ""
    static var itemId = String()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // imagesCollectionView.register(PostedImageCell.self, forCellWithReuseIdentifier: cellId)
        // Here the place where to put the right currency
        currencySegemnted.setTitle("ILS", forSegmentAt: 0)
        currencySegemnted.setTitle("$", forSegmentAt: 1)
        titleField.delegate = self
        priceField.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "اغلاق", style: .plain, target: self, action: #selector(backTapped))
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClicked))
        doneButton.tintColor = Constants.FirstColor
        
        toolBar.setItems([doneButton], animated: true)
        self.titleField.inputAccessoryView = toolBar
        self.descriptionTextView.inputAccessoryView = toolBar
        self.priceField.inputAccessoryView = toolBar
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1).cgColor
        descriptionTextView.layer.cornerRadius = 5
        self.navigationController?.navigationBar.topItem?.title = ""
        
        descriptionTextView.text = "الوصف"
        descriptionTextView.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        PostedItemViewController.isItFirstTimeOnThisView = false
        initializeIndicator()
        self.titleField.tag = 0
        imageLibraryController.navigationBar.isTranslucent = false
        imageLibraryController.navigationBar.tintColor = UIColor.white
    
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func doneClicked()
    {
        view.endEditing(true)
        
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        stringLocation = String(latestLocation.coordinate.latitude)  + " " + String(latestLocation.coordinate.longitude)
        print(stringLocation)
        // print (AddPokemonViewController.stringLocation)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                var alertEmailController = UIAlertController(title: "لم يتمكن جايلك من الحصول على موقعك", message: "لتمكين خدمة الموقع الرجاء الذهاب الى الاعدادات و من ثم Gayelak و من ثم الموقع و من ثم تمكين خدمة الموقع اثناء استخدام التطبيق", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
            
        else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // PostedItemViewController.images[PostedItemViewController.imageClickedNumber] = (PostedItemViewController.imageClicked!)
        //  PostedItemViewController.imagesValid[PostedItemViewController.imageClickedNumber] = true
        self.imagesCollectionView.reloadData()
    }
    
    func initializeIndicator()
    {
        indicatior = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatior.color = Constants.FirstColor
        indicatior.center = self.view.center
        indicatior.backgroundColor = .clear
        self.view.addSubview(indicatior)
    }
    
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: font],
                                                         context: nil).size
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "الوصف")
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text.isEmpty)
        {
            textView.text = "الوصف"
            textView.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        }
        
            
        else if (textView.textColor == UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1))
        {
            var txt = textView.text
          //  textView.text = nil
            
            if (txt == "الوص")
            {
                
                textView.text = nil
                textView.textColor = UIColor.black
                
            }

            else
            {
            
            if let range = txt?.range(of: "الوصف") {
                txt?.removeSubrange(range)
            }
                
                
            textView.text = txt
            textView.textColor = UIColor.black
        }
    }
        
        else
        {
           
            textView.textColor = UIColor.black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "الوصف"
            textView.textColor = UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            var textWidth = textView.frame.width
            textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
            let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
            let numberOfLines = boundingRect.height / textView.font!.lineHeight;
            return numberOfLines <= 6;

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == titleField)
        {
            let maxLength = 40
            let currentString: NSString = titleField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else
        {
            let maxLength = 9
            let currentString: NSString = priceField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "تحميل الصور بواسطة", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "الكاميرة", style: .default, handler: { (action) in
            PostedItemViewController.imageClickedNumber = indexPath.item
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let cameraViewController = cameraStoryboard.instantiateViewController(withIdentifier: "cameraView") as! CameraViewController
            self.navigationController?.pushViewController(cameraViewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "مكتبة الصور", style: .default, handler: { (action) in
            //execute some code when this option is selected
            // self.skinType = "Dark Skin"
            //let image = UIImagePickerController()
            self.imageLibraryController.delegate = self
            //self.isBackButtonClicked = false
            PostedItemViewController.imageClickedNumber = indexPath.item
            self.imageLibraryController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imageLibraryController, animated: true)
            {
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "اغلاق", style: .cancel, handler: { (action) in
            //execute some code when this option is selected
            // self.skinType = "Dark Skin"
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        if (PostedItemViewController.imagesValid[indexPath.item] == true)
        {
            alert.addAction(UIAlertAction(title: "حذف الصورة", style: .default, handler: { (action) in
                //execute some code when this option is selected
                // self.skinType = "Dark Skin"
                PostedItemViewController.images[indexPath.item] = nil
                PostedItemViewController.imagesValid[indexPath.item] = false
                self.imagesCollectionView.reloadData()
                
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as?  UIImage
        {
            //PostedItemViewController.imageClicked = image
            PostedItemViewController.images[PostedItemViewController.imageClickedNumber] = image
            PostedItemViewController.imagesValid[PostedItemViewController.imageClickedNumber] = true
            self.imagesCollectionView.reloadData()
        }
            
        else
        {
            // There is an error here with the image as a result
        }
        
        //isBackButtonClicked = true
        imageLibraryController.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostedImageCell
        
        if PostedItemViewController.imagesValid[indexPath.item] == true
        {
            
            cell.setUpImage(image: PostedItemViewController.images[indexPath.item]!)
        }
            
        else
        {
            cell.setUpEmptyImage()
            // cell.itemImageView.backgroundColor = UIColor(red:51/255.0 , green: 204/255.0, blue: 255/255.0, alpha: 1)
        }
        
        cell.itemImageView.layer.masksToBounds = true
        cell.itemImageView.layer.cornerRadius = 5
        return cell
    }
    
    func checkIfThereIsAvailablePhotos()->Bool
    {
     
        var checker = false

        for item in PostedItemViewController.images
        {
            
            if item != nil
            {
                checker = true
            }
            
        }
    
        return checker
    }
    
    @IBAction func handlePost(_ sender: UIButton) {
        
        var isThereIsPhotos = checkIfThereIsAvailablePhotos()
        
        if (stringLocation == "")
        {
            var alertEmailController = UIAlertController(title: "لم يتمكن جايلك من الحصول على موقعك", message: "لتمكين خدمة الموقع الرجاء الذهاب الى الاعدادات و من ثم Gayelak و من ثم الموقع و من ثم تمكين خدمة الموقع اثناء استخدام التطبيق", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            self.present(alertEmailController, animated: true, completion: nil)
            
        }
            
        else
        {
        
        if descriptionTextView.text == "" || titleField.text == "" || priceField.text == "" || isThereIsPhotos == false
        {
            let alertEmailController = UIAlertController(title: "المعلومات المدخلة غير مكتملة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            present(alertEmailController, animated: true, completion: nil)
        }
        
        else
        {
            indicatior.startAnimating()
            var storageCounter = 1
            var dataBaseCounter = 1
            
            for image in PostedItemViewController.images
            {
                if (image != nil)
                {
                    
                    dataBaseCounter = dataBaseCounter + 1
                    
                }
            }
            
            let databaseRef = FIRDatabase.database().reference().child("items").childByAutoId()

            for image in PostedItemViewController.images
            {
                //What I will do basically the follwowing.
                let storageRef = FIRStorage.storage().reference().child("Items_Photos").child(databaseRef.key).child(String(storageCounter) + ".jpeg")
                
                if (image == nil)
                {
                    continue
                }

                if let uploadData = UIImageJPEGRepresentation(image!, 0.5)
                {
                    storageRef.put(uploadData, metadata: nil)
                    {
                        (metadata, error) in
                        
                        if error != nil
                        {
                            // Here ther is an error
                            print (error?.localizedDescription)
                            let alertEmailController = UIAlertController(title: "حدث خطأ ما", message: "الرجاء اعد المحاولة لاحقا", preferredStyle: .alert)
                            alertEmailController.view.tintColor = Constants.FirstColor
                            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                            alertEmailController.addAction(defaultAction)
                            self.present(alertEmailController, animated: true, completion: nil)
                            self.indicatior.stopAnimating()
                            return
                            
                        }
                        
                        else
                        {
                            //There everything is good and fine.
                            if (dataBaseCounter == storageCounter)
                            {
                                let timestamp = Int(NSDate().timeIntervalSince1970)
                                databaseRef.updateChildValues(["title": self.titleField.text, "description":self.descriptionTextView.text, "price": self.priceField.text, "currency": self.currencySegemnted.titleForSegment(at: self.currencySegemnted.selectedSegmentIndex) , "userId":
                                    self.userID,"imagesCount": dataBaseCounter - 1,  "timestamp": timestamp, "displayName": WelcomeViewController.user.getUserDisplayName()])
                                FIRDatabase.database().reference().child("Users").child(self.userID).child("items").updateChildValues([databaseRef.key :""])
                                print (metadata)
                                
                                // here the work of the geofire
                                self.postGeofireInformation(itemId: databaseRef.key)
                                
                                //self.backTapped()
                                
                                let collectionsStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let collectionsViewController = collectionsStoryboard.instantiateViewController(withIdentifier: "CollectionsCollectionViewController") as! CollectionsCollectionViewController
                                  CollectionsCollectionViewController.presentedFor = "sell"
                                PostedItemViewController.itemId = databaseRef.key
                                self.navigationController?.pushViewController(collectionsViewController, animated: true)
                               self.postButton.isEnabled = false
                                
                                self.indicatior.stopAnimating()
                        
    
                            }
                        }
                        
                       // dataBaseCounter = dataBaseCounter + 1
                    }
                }
                storageCounter = storageCounter + 1
            }
        }
    }
    }
    
    func postGeofireInformation(itemId: String)
    {
        
        let geofireRef = FIRDatabase.database().reference().child("items-location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        var userCoordinates = stringLocation.components(separatedBy: " ")
        let lat = CLLocationDegrees(userCoordinates[0])!
        let lon = CLLocationDegrees(userCoordinates[1])!
        
        geoFire?.setLocation(CLLocation(latitude: lat, longitude: lon), forKey: itemId)
        { (error) in
            
            if error != nil {
                
                print("An error occured: \(error)")
                
            } else {
                
                print("Saved location successfully!")
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func backTapped() {
        
        //self.navigationController?.popViewController(animated: false)
        // self.navigationController?.popViewController(animated: false)
        //  PostedItemViewController.backButtonPressed = true
        self.navigationController?.popToRootViewController(animated: true)
        PostedItemViewController.imagesValid = [false, false, false, false]
        PostedItemViewController.images = [nil, nil, nil, nil]
        PostedItemViewController.imageClickedNumber = 0
        PostedItemViewController.isItFirstTimeOnThisView = true
        indicatior.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(false)
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = false
        // let  vc =  self.navigationController?.viewControllers.filter({$0 is BrowseCollectionViewController}).first
        // self.navigationController?.popToViewController(vc!, animated: false)
        // let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let browseNavigationViewController = mainStoryboard.instantiateViewController(withIdentifier: "BrowseCollectionViewController")
        //self.navigationController?.pushViewController(browseNavigationViewController, animated: true)
  
    }
    
}
