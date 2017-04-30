//
//  Helpers.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/2/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import Firebase


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}


func parseForEmailHanlder(email: String?) -> String{
    var strPrime = "";
    if email != nil {
        for c in (email?.characters)! {
            
            if c == "@"{
                break;
            }
            else{
                strPrime.append(c)
            }
        }
    }
    
    return strPrime
}






