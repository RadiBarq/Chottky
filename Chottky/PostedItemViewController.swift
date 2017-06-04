//
//  AddPriceViewController.swift
//  Chottky
//
//  Created by Radi Barq on 5/19/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase


class PostedItemViewController: UIViewController, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var cellId = "cellId"
    static var imagesValid = [false, false, false, false]
    static var images:[UIImage?] = [nil, nil, nil, nil]
    static var imageClickedNumber: Int = 0
    static var imageClicked: UIImage?
    var imageLibraryController = UIImagePickerController()
    // This is to check weather the view disappear for the backbutton or others
    var isBackButtonClicked: Bool = true
    static var isItFirstTimeOnThisView: Bool = true
    
    
   // static var firstImage: UIImage?
    let ref = FIRDatabase.database().reference().child("Users").childByAutoId()
    
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var currencySegemnted: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // imagesCollectionView.register(PostedImageCell.self, forCellWithReuseIdentifier: cellId)
        // Here the place where to put the right currency
        currencySegemnted.setTitle("ILS", forSegmentAt: 0)
        currencySegemnted.setTitle("$", forSegmentAt: 1)
        titleField.delegate = self
        priceField.delegate = self
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        PostedItemViewController.images[PostedItemViewController.imageClickedNumber] = (PostedItemViewController.imageClicked!)
        PostedItemViewController.imagesValid[PostedItemViewController.imageClickedNumber] = true
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor(red: 203/255, green: 202/255, blue: 203/255, alpha: 1)
        {
            textView.text = nil
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
        
        let newText = (descriptionTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 600;
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if (textField == titleField)
            {
                let maxLength = 30
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
            self.navigationController?.present(cameraViewController, animated: true, completion: nil)
                
        }))
        
        alert.addAction(UIAlertAction(title: "مكتبة الصور", style: .default, handler: { (action) in
            //execute some code when this option is selected
           // self.skinType = "Dark Skin"
            //let image = UIImagePickerController()
            self.imageLibraryController.delegate = self
            self.isBackButtonClicked = false
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
        
        isBackButtonClicked = true
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
    
    
    @IBAction func handlePost(_ sender: UIButton) {
        
        if descriptionTextView.text == "" || titleField.text == "" || priceField.text == ""
        {
            let alertEmailController = UIAlertController(title: "المعلومات المدخلة غير مكتملة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else
        {
             let timestamp = Int(NSDate().timeIntervalSince1970)
             ref.updateChildValues(["title": titleField.text, "description": descriptionTextView.text, "price": priceField.text, "currency": currencySegemnted.titleForSegment(at: currencySegemnted.selectedSegmentIndex) , "userEmail": " testUser", "timestamp": timestamp])
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if isBackButtonClicked
        {
            self.navigationController?.navigationBar.isHidden = false
            UIApplication.shared.isStatusBarHidden = false
            let  vc =  self.navigationController?.viewControllers.filter({$0 is CameraViewController}).first
            self.navigationController?.popToViewController(vc!, animated: false)
            
        }
    }
}
