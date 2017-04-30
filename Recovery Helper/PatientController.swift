//
//  PatientController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 12/30/16.
//  Copyright © 2016 Mario Hernandez. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class PatientController: UIViewController {
    
    //global variable for patient model
    var curPatient = PatientModel()
    
    let customView: UILabel = {
        let lable = UILabel()
        lable.text = "PatientView"
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = ComplementaryFlatColorOf(FlatBlue())
        lable.textAlignment = .center
        lable.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email =  parseForEmailHanlder(email: fetchCurUserInfo())
        navigationItem.title = email
        navigationItem.titleView?.backgroundColor = .white
        self.title = email
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        self.view.backgroundColor = ContrastColorOf(FlatBlue(), returnFlat: true)
        setUpNavigationItems()
    }
    
    func setUpNavigationItems(){
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        let email =  parseForEmailHanlder(email: fetchCurUserInfo())
        print(email)
        self.title = email
        navigationItem.title = email
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More Options", style: .plain, target: self, action:#selector(handleMoreOptions))
        
    }
    
    lazy var optionsLauncer: PatientOptionsLauncher = {
        let myOptions = PatientOptionsLauncher()
        myOptions.patientController = self
        return myOptions
    }()
    
    
    
    func handleMoreOptions(){
        optionsLauncer.showOptions()
    }
    
    func showControllerForOption(option: Options){
        
        if option.name == "Start Exercise" {
            
            print("Start Exercise")
            let exerciseController = ExerciseController()
            navigationController?.pushViewController(exerciseController, animated: true)
            
        } else{
            
            let dummyOptionsController = UIViewController()
            dummyOptionsController.navigationItem.title = option.name
            dummyOptionsController.navigationController?.navigationBar.tintColor = ComplementaryFlatColorOf(FlatPurpleDark())
            dummyOptionsController.view.backgroundColor = FlatPurpleDark()
            
            navigationController?.pushViewController(dummyOptionsController, animated: true)
        }
    }
    
    
    func handleLogout(){
        do{
            try FIRAuth.auth()?.signOut()
            print("User is logged out!")
        } catch let signOutError {
            print(signOutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    func fetchCurUserInfo()->String?{
        if let user = FIRAuth.auth()?.currentUser{
            
            return user.email;
        }
        else{
            return nil;
        }
    }
    
}
