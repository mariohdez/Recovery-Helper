//
//  Patients.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/16/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation
import UIKit

class PatientView: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello:)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Exercise", style: .plain, target: self, action: #selector(handleNewExercise))
    }
    func handleNewExercise(){
        let setNewExercise = SetExercise()
        let navController = UINavigationController(rootViewController: setNewExercise)
        present(navController, animated: true, completion: nil)
        
    }
}
