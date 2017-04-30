//
//  SettingsLauncher.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/2/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework


class Options: NSObject {
    let name:String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
}

class PatientOptionsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Instance variables...
    let blackView = UIView()
    let cellID = "cellID"
    let cellHeight = 50
    
    // Data source...
    let options: [Options] = {
        return [Options(name: "Settings", imageName: "settings"), Options(name: "Start Exercise", imageName: "privacy"), Options(name: "Messages", imageName: "feedback"), Options(name: "History", imageName: "feedback"), Options(name: "Calendar", imageName: "switch_account"),Options(name: "Connect Sensor", imageName: "help"), Options(name: "Cancel", imageName: "cancel")]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = FlatSkyBlue()
        return cv
    }()

    var patientController: PatientController?
    
    
    func showOptions(){
        if let window = UIApplication.shared.keyWindow{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            blackView.addGestureRecognizer(tapGesture)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let hgt:CGFloat = CGFloat( options.count * cellHeight )
            let y = window.frame.height - hgt
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: hgt)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }

    func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! OptionsCell
        let opt = options[indexPath.item]
        cell.option = opt
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 as CGFloat
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            let curOption = self.options[indexPath.item]
            if curOption.name != "Cancel" {
                self.patientController?.showControllerForOption(option: curOption)
            }
        }
    }

    override init(){
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellID)
    }
}
