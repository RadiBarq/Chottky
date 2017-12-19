//
//  SignUpViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/9/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    let passwordMaxLength  = 20
    let emailMaxLength = 30
    let userNameLength = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        UIApplication.shared.isStatusBarHidden = false
     //   UIApplication.shared.statusBarStyle = .lightContent
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == emailTextField)
        {
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= emailMaxLength
            
        }
        
        else if (textField == passwordTextField)
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= passwordMaxLength
        }
        
        else
        {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= userNameLength
        }
    }
    
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        
        signUp()
    }
    
    func signUp()
    {
        
        var alertEmailController = UIAlertController(title: "صيغة البريد الالكتروني غير صحيحة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
        alertEmailController.addAction(defaultAction)
        let emailText:String = emailTextField.text!
        let passwordText:String = passwordTextField.text!
        
        
        if (emailText.isEmail == false)
        {
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else if (passwordText.characters.count < 6)
        {
            
            alertEmailController = UIAlertController(title: "كلمة السر قصيرة جدا", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
            
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else
        {
            authenticateWithFirebase(email: emailText, password: passwordText)
        }
    }
    
    func authenticateWithFirebase(email:String, password:String)
    {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in

            var alertEmailController:UIAlertController = UIAlertController()
            
            if ((error) != nil)
            {
                if (error!.localizedDescription == "The email address is already in use by another account.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "هاذا البريد الالكتروني تم تسجيله مسبقا", preferredStyle: .alert)
                }
                
                else if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "خطأ في الشبكة الرجاء اعد المحاولة", preferredStyle: .alert)
                }
                
                else
                {
                    alertEmailController = UIAlertController(title: "عذرا", message: "حدث خطأ ما الرجاء اعد المحاولة", preferredStyle: .alert)
                }
                
                print (error?.localizedDescription)
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertEmailController.addAction(defaultAction)
                self.present(alertEmailController, animated: true, completion: nil)
            }
                
            else
            {
                
                let userId = FIRAuth.auth()!.currentUser!.uid
                self.addNewUserInformationToFirebase(emailText: self.emailTextField.text!, userNameText:  self.userNameTextField.text!, passwordText: self.passwordTextField.text!, userId: userId)
            }
        
        }
    }
    
    // all the work here
    
    func addNewUserInformationToFirebase(emailText: String, userNameText:String, passwordText:String, userId: String)
    {
        let endEmailTextIndex = emailText.index(emailText.endIndex, offsetBy: -4)
        let emailTruncatedDotCom = emailText.substring(to: endEmailTextIndex)
        let user = ["Email":emailText, "UserName":userNameText, "UserId": userId, "ProfilePicture": "false"] // Here TODO The Location Name
        FIRDatabase.database().reference().child("Users").child(userId).setValue(user)
        
    }
    
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
      
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.present(welcomeViewController, animated: true, completion: nil)
        
    }
    
   

}
