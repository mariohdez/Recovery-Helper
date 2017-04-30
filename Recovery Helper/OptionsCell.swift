//
//  OptionsCell.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/2/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework


class OptionsCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted == true ? FlatBlack(): FlatSkyBlue()
        }
    }
    
    var option: Options? {
        didSet{
            nameLabel.text = option?.name
            if let imageName = option?.imageName{
                iconImageView.image = UIImage(named: imageName)
            }
            else{
                iconImageView.image = UIImage(named: "settings")
            }
        }
    }
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Options"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "settings")
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubViews()
        addConstraints()
        
    }
    func addConstraints(){
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0(30)]|", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    func addSubViews(){
        addSubview(nameLabel)
        addSubview(iconImageView)
    }
    
    
    
}
