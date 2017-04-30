//
//  PatientController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 12/30/16.
//  Copyright © 2016 Mario Hernandez. All rights reserved.
//


import LBTAComponents
import UIKit
import Firebase
import ChameleonFramework


class PhysicianController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
        let setExercise = SetExercise()
        let setExNavBar = UINavigationController(rootViewController: setExercise)
        setExNavBar.tabBarItem.title = "Set Exercise"
        self.navigationItem.title = "Physician Home"
        
        
        self.viewControllers = [setExNavBar,createDummyViewController(name: "History") ]
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
    
    private func createDummyViewController(name:String)-> UINavigationController{
        let viewController = UIViewController()
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = name
        return nav
    }
    
}
