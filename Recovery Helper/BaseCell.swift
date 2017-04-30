//
//  BaseCell.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/2/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//


import Foundation
import UIKit
import ChameleonFramework

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpViews()
    }
    func setUpViews(){
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
