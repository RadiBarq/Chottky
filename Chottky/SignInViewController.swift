//
//  SignInViewController.swift
//  Chottky
//
//  Created by Radi Barq on 3/9/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import SideMenu
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let passwordMaxLength  = 30
    let emailMaxLength = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
         return newString.length <= passwordMaxLength
    }
    
    
    @IBAction func onClickSingIn(_ sender: UIButton) {
        
        signIn()
        
    }
    
    
    func signIn()
    {
        
        let alertEmailController = UIAlertController(title: "صيغة البريد الالكتروني غير صحيحة", message: "الرجاء اعد المحاولة", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
         alertEmailController.addAction(defaultAction)
        
        let emailText:String = emailTextField.text!
        let passwordText:String = passwordTextField.text!
        
        
        if (emailText.isEmail == false)
        {
            present(alertEmailController, animated: true, completion: nil)
        }
            
        else
        {
            
            authenticateWithFirebase(email: emailText, password: passwordText)
            
        }
    }
    
    
    func authenticateWithFirebase(email:String, password:String)
    {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
        var alertEmailController:UIAlertController = UIAlertController()
            
        if ((error) != nil)
        {
            if (error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.")
            {
                    
                alertEmailController = UIAlertController(title: "عذرا", message: "البريد الالكتروني الذي تم ادخاله غير صحيح", preferredStyle: .alert)
                    
            }
                
            else if (error!.localizedDescription == "The password is invalid or the user does not have a password.")
            {
                    
                alertEmailController = UIAlertController(title: "عذرا", message: "كلمة المرور التي تم ادخالها غير صحيحة", preferredStyle: .alert)
            }
                    
                
            else if (error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.")
            {
                alertEmailController = UIAlertController(title: "عذرا", message: "خطأ في الشبكة الرجاء اعد المحاولة", preferredStyle: .alert)
            }
                    
                
            else
            {
                    alertEmailController = UIAlertController(title: "عذرا", message: "حدث خطأ ما الرجاء اعد المحاولة", preferredStyle: .alert)
            }
                
            print (error!.localizedDescription)
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertEmailController.addAction(defaultAction)
            self.present(alertEmailController, animated: true, completion: nil)
        }
                
            // Nothing Happened Here
            else
            {

                           //    SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
                
                let userEmail:String = (user?.email)!
                
                let endEmailTextIndex = userEmail.index(userEmail.endIndex, offsetBy: -4)
                var emailTruncatedDotCom = userEmail.substring(to: endEmailTextIndex)

                WelcomeViewController.user.setUserEmail(email: emailTruncatedDotCom)
                
                let ref = FIRDatabase.database().reference().child("Users").child(emailTruncatedDotCom).child("UserName")
                
                let userName = ref.observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
                    
                    
                WelcomeViewController.user.setUserDisplayName(name: (FIRDataSnapshot.value) as! String)
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let browseNavigationViewController = mainStoryboard.instantiateViewController(withIdentifier: "browseNavigationController")
                    self.present(browseNavigationViewController, animated: true, completion: nil)
                    
                })
               
            }
            
        }
    }
    
    @IBAction func onClickedSignUp(_ sender: UIButton) {
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.present(welcomeViewController, animated: true, completion: nil)
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
