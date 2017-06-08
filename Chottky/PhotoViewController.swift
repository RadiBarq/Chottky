/*Copyright (c) 2016, Andrew Walz.

Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit

class PhotoViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        get {
            
            return true
        }
    }
    
	private var backgroundImage: UIImage
    
	init(image: UIImage) {
        
		self.backgroundImage = image
		super.init(nibName: nil, bundle: nil)
        
	}
    
	required init?(coder aDecoder: NSCoder) {
        
		fatalError("init(coder:) has not been implemented")
        
	}

    override func viewDidLoad() {
        
        
		super.viewDidLoad()
         		self.view.backgroundColor = UIColor.gray
		let backgroundImageView = UIImageView(frame: view.frame)
		backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
		backgroundImageView.image = backgroundImage
		view.addSubview(backgroundImageView)
		let cancelButton = UIButton(frame: CGRect(x: 20, y: 20, width: 15, height: 15.0))
		cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
		cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		view.addSubview(cancelButton)
        let postButton =  UIButton()
        postButton.frame = CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width:150 , height:60)
        postButton.layer.cornerRadius = 30
        postButton.layer.masksToBounds = true
        postButton.backgroundColor = Constants.FirstColor
        postButton.setTitle("مناسبة", for: UIControlState.normal)
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        view.addSubview(postButton)
	}
    
    
    override func viewWillAppear(_ animated: Bool) {
        
            super.viewWillAppear(true)
            self.navigationController?.navigationBar.isHidden = true
            UIApplication.shared.isStatusBarHidden = true
        
    }
	func cancel() {
        
        self.navigationController?.popViewController(animated: true)
	}

    
    func post()
    {
            self.navigationController?.navigationBar.isHidden = false
            UIApplication.shared.isStatusBarHidden = false
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postedItemViewController = mainStoryboard.instantiateViewController(withIdentifier: "PostedItemViewController") as! PostedItemViewController
            PostedItemViewController.images[PostedItemViewController.imageClickedNumber] = backgroundImage
            PostedItemViewController.imagesValid[PostedItemViewController.imageClickedNumber] = true
            self.navigationController?.pushViewController(postedItemViewController, animated: true)
           // CameraViewController.isThisTheFirstTime = false
                //self.su.dismiss(animated: true, completion: nil)
            //let newVC = PostedItemViewController(image: backgroundImage)
           // self.navigationController?.pushViewController(newVC, animated: true)
    }
}
