//
//  ExerciseController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 1/3/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase


class ExerciseController: UIViewController {
    // Instance methods.
    var count:Float = 0.0
    var timer = Timer()
    var userArray:NSDictionary? = [:]
    var cnt:Int = 1
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello world, lets exercise."
        label.textColor = FlatPowderBlue()
        label.textAlignment = .center
        return label
    } ()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.textColor = FlatPowderBlue()
        label.textAlignment = .center
        return label
    } ()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    } ()
    
    
    let flexTargetInput : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "Target flex angle."
        txtField.clearButtonMode = UITextFieldViewMode.whileEditing
        txtField.resignFirstResponder()
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 5
        txtField.layer.borderColor = UIColor.purple.cgColor
        txtField.layer.borderWidth = 1
        txtField.keyboardType = UIKeyboardType.decimalPad
        return txtField
    } ()
    
    let extensionTargetInput : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "Target extension angle."
        txtField.clearButtonMode = UITextFieldViewMode.whileEditing
        txtField.resignFirstResponder()
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 5
        txtField.layer.borderColor = UIColor.purple.cgColor
        txtField.layer.borderWidth = 1
        txtField.keyboardType = UIKeyboardType.decimalPad
        return txtField
    } ()
    
    let repetionsTargetInput : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "Target number of repetitions angle."
        txtField.clearButtonMode = UITextFieldViewMode.whileEditing
        txtField.resignFirstResponder()
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 5
        txtField.layer.borderColor = UIColor.purple.cgColor
        txtField.layer.borderWidth = 1
        txtField.keyboardType = UIKeyboardType.decimalPad
        return txtField
    } ()
    
    
    
    override func viewDidLoad() {
        var ref: FIRDatabaseReference!
        var userID:String? = ""
        print("In Exercise view controller!")
        if (FIRAuth.auth()?.currentUser) != nil {
            ref = FIRDatabase.database().reference()
            userID = FIRAuth.auth()?.currentUser?.uid
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        self.view.addGestureRecognizer(tapGesture);
        
        
        
        super.viewDidLoad()
        view.backgroundColor = FlatOrange ()
        self.view.addSubview (testLabel)
        self.view.addSubview (flexTargetInput)
        self.view.addSubview (extensionTargetInput)
        self.view.addSubview (repetionsTargetInput)
        self.view.addSubview (startButton)
        
        self.setUpTestLabelConstraints ()
        self.setUpConstrainstForFlexTargetInput ()
        self.setUpConstrainstForExtensionTargetInput ()
        self.setUpConstrainstForRepetitionsTargetInput ()
        self.setUpConstraintsForStartButton ()
        self.setUpNavigationControls ()
        
        if let displayName = fetchCurUserName () {
            testLabel.text = "Hi, \(displayName) ready to exercise?"
        } else {
            testLabel.text = "Hi, ready to exercise?"
        }
    }
    
    func setUpTestLabelConstraints () {
        testLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        testLabel.centerYAnchor.constraint (equalTo: view.topAnchor, constant: 30).isActive = true
        testLabel.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true
        testLabel.heightAnchor.constraint (equalToConstant: 40).isActive = true
    }
    
    func setUpConstrainstForFlexTargetInput () {
        flexTargetInput.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        flexTargetInput.topAnchor.constraint (equalTo: testLabel.bottomAnchor, constant: 5).isActive = true
        flexTargetInput.topAnchor.constraint (equalTo: testLabel.bottomAnchor).isActive = true
        flexTargetInput.widthAnchor.constraint (equalTo: testLabel.widthAnchor, constant: -20).isActive = true
        flexTargetInput.heightAnchor.constraint (equalToConstant: 50).isActive = true
    }
    
    func setUpConstrainstForExtensionTargetInput () {
        extensionTargetInput.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        extensionTargetInput.topAnchor.constraint (equalTo: flexTargetInput.bottomAnchor, constant: 5).isActive = true
        extensionTargetInput.widthAnchor.constraint (equalTo: testLabel.widthAnchor, constant: -20).isActive = true
        extensionTargetInput.heightAnchor.constraint (equalToConstant: 50).isActive = true
    }
    
    func setUpConstrainstForRepetitionsTargetInput () {
        repetionsTargetInput.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        repetionsTargetInput.topAnchor.constraint (equalTo: extensionTargetInput.bottomAnchor, constant: 5).isActive = true
        repetionsTargetInput.widthAnchor.constraint (equalTo: testLabel.widthAnchor, constant: -20).isActive = true
        repetionsTargetInput.heightAnchor.constraint (equalToConstant: 50).isActive = true
    }
    
    func setUpConstraintsForStartButton () {
        startButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        startButton.topAnchor.constraint (equalTo: repetionsTargetInput.bottomAnchor, constant: 12).isActive = true
        startButton.widthAnchor.constraint (equalTo: testLabel.widthAnchor).isActive = true
        startButton.heightAnchor.constraint (equalToConstant: 50).isActive = true
    }
    
    func setUpNavigationControls () {
        navigationItem.leftBarButtonItem = UIBarButtonItem (title: "Go back", style: .plain, target: self, action: #selector(handleBackBarButton))
        navigationItem.leftBarButtonItem?.tintColor = ComplementaryFlatColorOf(FlatOrange())
    }
    
    func handleBackBarButton () {
        if let navController = self.navigationController {
            timer.invalidate ()
            navController.popViewController (animated: true)
        }
    }
    
    func handleStart () {
        
        let flexError = flexTargetInput.text == "" ? true : false
        let extError = extensionTargetInput.text == "" ? true : false
        let repError = repetionsTargetInput.text == "" ? true : false
        
        if (flexError || extError || repError) {
            let alertCntrl = UIAlertController (
                title: "Ooops!",
                message:  "Please enter target flex angle, target extension angle and number of reps. Thanks!",
                preferredStyle: .alert
            )
            
            let defltActn = UIAlertAction (
                title: "OK",
                style: .cancel,
                handler: nil
            )
            
            alertCntrl.addAction (defltActn)
            self.present (
                alertCntrl,
                animated: true,
                completion: nil
            )
            
        } else {
            var ref: FIRDatabaseReference!
            
            ref = FIRDatabase.database().reference()
            
            if let num1 = Int(repetionsTargetInput.text!),
                let num2 = Int(extensionTargetInput.text!),
                let num3 = Int(flexTargetInput.text!) {
                print ("Good.");
            } else {
                exit(EXIT_FAILURE);
            }
            let numRep = Int(repetionsTargetInput.text!)
            let numRepsNS = NSNumber(value: numRep!)
            let extAngle = Int(extensionTargetInput.text!)
            let extAngleNS = NSNumber(value: extAngle!)
            let flexAngle = Int(flexTargetInput.text!)
            let flexAngleNS = NSNumber(value: flexAngle!)
            let user = FIRAuth.auth()?.currentUser
            let userID = user?.uid
            getUserArray()
            
            let userEmail = user!.email! as NSString
            print (userEmail)
            
            let valuesToBeSet = [
                "targetExtension" : extAngleNS,
                "start": true,
                "targetFlex": flexAngleNS,
                "reps": numRepsNS,
                "email" : userEmail
                ] as [String : Any]
            
            ref.child("patients").child(userID!).setValue(valuesToBeSet)
            
            sendAlert(
                message: "Data sent to database. Arduino will attempt to read. After 30 seconds the \"start\" flag will be set to false"
            )
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute: {
                
                var cpyVales = valuesToBeSet
                cpyVales["start"] = false
                self.changeStartToFalse(dictionary: cpyVales as [String : Any])
                self.sendAlert(message: "\"start\" flag is set to false now.")
            })
        }
    }
    
    func handlePause() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    func counter () {
        count += 0.10
        let numberOfPlaces:Float = 1.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(count * multiplier)/multiplier
        print(rounded)
        testLabel.text = "\(rounded)"
        testLabel.highlightedTextColor = ComplementaryFlatColorOf(FlatOrange())
    }
    
    func fetchCurUserName () ->String? {
        if let user = FIRAuth.auth()?.currentUser {
            return parseForEmailHanlder(email: user.email);
        }
        else{
            return nil;
        }
    }
    
    func changeStartToFalse (dictionary: [String : Any]) {
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("patients").child(userID!).setValue(dictionary)
    }
    
    func getUserArray () {
        if cnt == 1 {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("patients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print ("got to updating shit")
                let email = value?["email"] as? String ?? ""
                let name = value?["name"] as? String ?? ""
                dump(value)
                self.userArray = value
            }) { (error) in
                print(error.localizedDescription)
            }
            cnt += 1
        }
    }
    
    func sendAlert (message: String) -> Void {
        let alertCntrl = UIAlertController (
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        let defltActn = UIAlertAction (
            title: "OK",
            style: .cancel,
            handler: nil
        )
        
        alertCntrl.addAction (defltActn)
        
        self.present (
            alertCntrl,
            animated: true,
            completion: nil
        )
        
    }
    
    /*
     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
     blackView.addGestureRecognizer(tapGesture)
     func handleDismiss(){
     UIView.animate(withDuration: 0.5) {
     self.blackView.alpha = 0
     if let window = UIApplication.shared.keyWindow{
     self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
     }
     }
     }
     */
    func handleDismiss() {
        self.view.endEditing(true)
    }
}
