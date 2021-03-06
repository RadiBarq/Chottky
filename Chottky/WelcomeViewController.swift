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
    
    @IBOutlet weak var backgroundView: UIView!
    public static var user = User()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        
        if( FIRAuth.auth()!.currentUser != nil)
        {
            let user = FIRAuth.auth()?.currentUser!
            WelcomeViewController.user.setUpUserId(userId: (user!.uid))
            WelcomeViewController.user.setUserEmail(email: (user!.email)!)
            WelcomeViewController.user.setUserDisplayName(name: user!.displayName!)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
            self.present(tabViewController, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
       // let loginButton = LoginButton(readPermissions: [.publicProfile])
        //loginButton.center = view.center
        //view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
        
       // setUpMenuBar()
        
        self.view.backgroundColor = UIColor.clear
        var backgroundImage = UIImageView()
        backgroundImage.image = #imageLiteral(resourceName: "house-photo")
        backgroundImage.frame = self.backgroundView.bounds
        self.backgroundView.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImage.widthAnchor.constraint(equalToConstant: self.backgroundView.frame.width).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: self.backgroundView.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true

        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.clear
       // let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
      //  let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
       // blurEffectView.frame = self.view.bounds
       // blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // self.backgroundView.addSubview(blurEffectView)
        

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
                            
                                print(error)
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
        self.present(loginViewController, animated: false, completion: nil)
    }
    
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "signUpViewController")
        self.present(loginViewController, animated: true, completion: nil)
        
    }
   
    
}
