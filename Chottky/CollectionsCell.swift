//
//  CollectionsCell.swift
//  Chottky
//
//  Created by Radi Barq on 5/14/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class CollectionsCell: UICollectionViewCell {
    
    
    
    
    var imageView: UIImageView =
        {
            
            var imageView = UIImageView()
            return imageView
            
    }()
    
    
    
    override init (frame: CGRect)
    {
        
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")

    }
    

    func setupViews()
    {
        
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    
    func setImage(image: UIImage) -> Void
    {
        
        self.backgroundColor = UIColor.white
        imageView.image = image
        
    }
}
