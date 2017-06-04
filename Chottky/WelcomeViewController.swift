//
//  LoginScreen.swift
//  Chottky
//
//  Created by Radi Barq on 3/4/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FBSDKLoginKit

class WelcomeViewController: UIViewController {
    
    public static var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // let loginButton = LoginButton(readPermissions: [.publicProfile])
        //loginButton.center = view.center
        //view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
        
       // setUpMenuBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onFacebookButtonClicked(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
                switch loginResult {
        
                        case .failed(let error):
                        print(error)
                        case .cancelled:
                        print("User cancelled login.")
                        case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token:  let accessToken):
                            
                        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                            // ...
                            if let error = error {
                    
                                return
                            }
                            
                        print("Logged in!")
                    
                        };
            };
        }
    }
    
    
    
    
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "signInViewController")
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "signUpViewController")
        self.present(loginViewController, animated: true, completion: nil)
        
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
