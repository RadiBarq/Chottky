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
    
    var categoryLable: UILabel = {
        
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
        label.textAlignment = .right
        label.textColor = Constants.SecondColor
        return label
        
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        self.addSubview(categoryLable)
        categoryLable.translatesAutoresizingMaskIntoConstraints = false
       // categoryLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        categoryLable.heightAnchor.constraint(equalToConstant: 10).isActive = true
        categoryLable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryLable.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    
    func setUpLabel(text: String)
    {
        
        categoryLable.text = text
        
    }
    
    
    func setImage(image: UIImage) -> Void
    {
        
        self.backgroundColor = UIColor.white
        imageView.image = image
        
    }
    
}
