//
//  SetExercise.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/16/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation
import UIKit

class SetExercise:UITableViewController{
    

    
    override func viewDidLoad() {
        print("hello Set Exersize!")
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.title = "Set Exercise"
    }
    func cancel(){
        print("hellow.... cancel")
        dismiss(animated: true, completion: nil)
        
    }
}
