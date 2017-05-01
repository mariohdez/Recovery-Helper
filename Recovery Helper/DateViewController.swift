//
//  DateViewController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 4/30/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import UIKit
import Firebase
import JTAppleCalendar

class DateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // instance varible
    var date:Date? = nil
    var name:String? = nil
    var exercFlag = false
    var targetExtenion = 0
    var targetFlex = 0
    var repetitions = 0
    var cnt:Int = 1
    var userArray:NSDictionary? = [:]
    
    
    var repTargetArray = [String]()
    var extensionTargetArray = [String]()
    var flexTargetArray = [String]()
    
    let months = [
        "January", "Febuary", "March",
        "April", "May","June",
        "July", "August", "September",
        "October", "November", "December"
    ]
    
    var dummyData = [String]()
    
    var dummyData2 = [String]()
    
    var dummyData3 = [String]()
    
    var repToSendToFirebase = 0
    var targetExtensionToSendToFirebase = 0
    var taretFlexToSendToFirebase = 0
    
    var ref = FIRDatabase.database().reference()
    
    // Information for user
    let todayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // View of date, infomation for user
    let dateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // Information for date view
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(complementaryFlatColorOf: UIColor.init(r: 58, g: 41, b: 75))
        label.text = "month"
        label.textAlignment = .center
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 45.0)
        return label
    }()
    
    // Information for date view
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(complementaryFlatColorOf: UIColor.init(r: 58, g: 41, b: 75))
        label.text = "day"
        label.textAlignment = .center
        label.font = label.font.withSize(35)
        return label
    }()
    
    // No exercise today view
    let noneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "No exercises today."
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.layer.borderColor = UIColor.black.cgColor
        label.backgroundColor = UIColor.init(complementaryFlatColorOf: UIColor.init(r: 58, g: 41, b: 75))
        return label
    }()
    
    // ****** REPITIONS VIEWS NEEDED ****** //
    let repititionsInputView: UITextView = {
        let input = UITextView()
        input.text = "Number of repitions"
        input.textColor = UIColor.lightGray
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    let repPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    // ****** REPITIONS VIEWS NEEDED ****** //
    
    // Adri**987 adri**987
    
    // ****** Target Extension Angle VIEWS NEEDED ****** //
    let targetExtensionInputView: UITextView = {
        let input = UITextView()
        input.text = "Target Extension Angle"
        input.textColor = UIColor.lightGray
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    let targetExtensionPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    // ****** Target Extension Angle VIEWS NEEDED ****** //
    
    // ****** Target Flexion Angle VIEWS NEEDED ****** //
    let targetFlexInputView: UITextView = {
        let input = UITextView()
        input.text = "Target Flex Angle"
        input.textColor = UIColor.lightGray
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    let targetFlexPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    // ****** Target Flexion Angle VIEWS NEEDED ****** //
    
    let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(complementaryFlatColorOf: UIColor.init(r: 58, g: 41, b: 75))
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(r: 58, g: 41, b: 75)
        setUpNavigationBar()
        var dia = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let day = date {
            dia = formatter.string(from: day)
            todayLabel.text = dia
        } else {
            todayLabel.text = "Today"
        }
        let dateArray = dia.components(separatedBy: "-")
        if dateArray.count != 3 {
            todayLabel.text = dia
            self.view.addSubview (todayLabel)
            setUpTodayLabelConstrainst()
        } else {
            self.view.addSubview(dateView)
            setUpDateViewViews(date: dateArray)
            setUpDateView()
        }
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        exerciseToday(who: userID)
        
        repititionsInputView.inputView = repPicker
        targetExtensionInputView.inputView = targetExtensionPicker
        targetFlexInputView.inputView = targetFlexPicker
        
    }
    
    func setUpTodayLabelConstrainst(){
        todayLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        todayLabel.centerYAnchor.constraint (equalTo: view.topAnchor, constant: 100).isActive = true
        todayLabel.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true
        todayLabel.heightAnchor.constraint (equalToConstant: 40).isActive = true
    }
    
    func setUpDateView() {
        dateView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        dateView.centerYAnchor.constraint (equalTo: view.topAnchor, constant: 80).isActive = true
        dateView.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true
        dateView.heightAnchor.constraint (equalToConstant: 80).isActive = true
    }
    
    func setUpDateViewViews(date: [String]) {
        if let monthInt = Int(date[1]) {
            let monthStr = self.months[monthInt - 1]
            self.monthLabel.text = monthStr
            self.monthLabel.text = self.monthLabel.text! + " "
        }
        if let dayInt = Int(date[2]) {
            let dayStr = String(dayInt)
            self.dayLabel.text = dayStr
            self.monthLabel.text = self.monthLabel.text! + self.dayLabel.text!
        }
        dateView.addSubview(monthLabel)
        dateView.addSubview(dayLabel)
        
        setUpDate()
    }
    
    func setUpDate() {
        monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLabel.centerYAnchor.constraint (equalTo: dateView.topAnchor, constant: 50).isActive = true
        monthLabel.widthAnchor.constraint(equalTo: dateView.widthAnchor).isActive = true
        monthLabel.heightAnchor.constraint (equalTo: dateView.heightAnchor, constant: -20).isActive = true
    }
    
    func finishSetUp() {
        
        let startIndexExt = 10 - 5
        let startIndexflex = 105 - 5
        let startIndexReps = 5 - 1
        
        let endIndexExt = 10 + 5
        let endIndexflex = 105 + 5
        let endIndexReps = 5 + 1
        
        print("ext: \(startIndexExt)")
        print("flex: targ: \(startIndexflex)")
        print("number of resp: \(startIndexReps)")
        
        print("ext: \(endIndexExt)")
        print("flex: targ: \(endIndexflex)")
        print("number of resp: \(endIndexReps)")
        
        
        dummyData2 = [String]()
        for var i in startIndexExt...endIndexExt {
            dummyData2.append(String(i))
        }
        
        dummyData3 = [String]()
        for var j in startIndexflex...endIndexflex {
            dummyData3.append(String(j))
        }
        
        dummyData = [String]()
        
        for var k in startIndexReps...endIndexReps{
            dummyData.append(String(k))
        }
        
        
        print("flex target array: \(flexTargetArray)")
        print("rep target array:\(repTargetArray)")
        print("flex extension array: \(extensionTargetArray)")
        
        
        if !exercFlag {
            view.addSubview(noneLabel)
            setUpNoneLabelConstrainst()
        } else {
            setupToggles()
        }
    }
    
    func setupToggles() {
        repPicker.dataSource = self
        repPicker.delegate = self
        view.addSubview(repititionsInputView)
        
        repititionsInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        repititionsInputView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 20).isActive = true
        repititionsInputView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        repititionsInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        targetExtensionPicker.dataSource = self
        targetExtensionPicker.delegate = self
        view.addSubview(targetExtensionInputView)
        
        targetExtensionInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        targetExtensionInputView.topAnchor.constraint(equalTo: repititionsInputView.bottomAnchor, constant: 20).isActive = true
        targetExtensionInputView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        targetExtensionInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        targetFlexPicker.dataSource = self
        targetFlexPicker.delegate = self
        view.addSubview(targetFlexInputView)
        
        targetFlexInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        targetFlexInputView.topAnchor.constraint(equalTo: targetExtensionInputView.bottomAnchor, constant: 20).isActive = true
        targetFlexInputView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        targetFlexInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(startButton)
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.topAnchor.constraint(equalTo: targetFlexInputView.bottomAnchor, constant: 40).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == repPicker {
            return dummyData.count
        } else if pickerView == targetExtensionPicker {
            return dummyData2.count
        } else  { //pickerView == targetFlexPicker
            return dummyData3.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == repPicker {
            repititionsInputView.text = dummyData[row]
            repToSendToFirebase = Int(dummyData[row])!
        } else if pickerView == targetExtensionPicker {
            targetExtensionInputView.text = dummyData2[row]
            targetExtensionToSendToFirebase = Int(dummyData2[row])!
        } else { // pickerView == targetFlexPicker
            targetFlexInputView.text = dummyData3[row]
            taretFlexToSendToFirebase = Int(dummyData3[row])!
        }
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == repPicker{
            return dummyData[row]
        } else if pickerView == targetExtensionPicker {
            return dummyData2[row]
        } else {
            return dummyData3[row]
        }
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.init(
            r: 81,
            g: 51,
            b: 93
        )
        
        navigationItem.title = "Exercise"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(handleBack)
        )
    }
    
    func handleBack() {
        navigationController?.popViewController( animated: false )
        dismiss( animated: true, completion: nil )
        let userID = FIRAuth.auth()?.currentUser?.uid
        //        exerciseToday(who: userID!)
    }
    
    func setUpNoneLabelConstrainst(){
        noneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noneLabel.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 20).isActive = true
        noneLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        noneLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
    func exerciseToday(who: String?) {
        ref.child("patients").child(who!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let flag = value?["exerciseToday"] as? Bool ?? true
            
            let targetFlextion = value?["targetFlex"] as? String  ?? ""
            let targetExt = value?["targetExtension"] as? String ?? ""
            let reps = value?["reps"] as? String ?? ""
            
            print("printing if ther is an exercize to do: \(flag)")
            print("printing target Flextion: \(targetFlextion)")
            print("printing target Extension: \(targetExt)")
            print("printing target Repititions: \(reps)")
            
            self.exercFlag = flag
            self.targetFlex = Int(targetFlextion)!
            self.targetExtenion = Int(targetExt)!
            self.repetitions = Int(reps)!
            self.finishSetUp()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func handleStart() {
        let flexError = taretFlexToSendToFirebase == 0 ? true : false
        let extError = targetExtensionToSendToFirebase == 0 ? true : false
        let repError = repToSendToFirebase == 0 ? true : false
        
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
            let user = FIRAuth.auth()?.currentUser
            let userID = user?.uid
            print(userID)
            
            let userEmail = user!.email! as NSString
            
            print (userEmail)
            
            let numRepsNS = NSString(string: String(repToSendToFirebase))
            let flexAngleNS = NSString(string: String(taretFlexToSendToFirebase))
            let extAngleNS = NSString(string: String(targetExtensionToSendToFirebase))
            
            getUserArray()
            
            let valuesToBeSet = [
                "targetExtension" : extAngleNS,
                "start": true,
                "targetFlex": flexAngleNS,
                "reps": numRepsNS,
                "email" : userEmail,
                "exerciseToday" : true
                ] as [String : Any]
            
            if let id = userID {
                print(valuesToBeSet)
                
                
                ref.child("patients").child(id).setValue(valuesToBeSet)
            }
            
            sendAlert(
                title:"Notice",
                message: "Exercise will start shortly"
            )
            // has to be 3 digits for flex
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
                
                ref.child("patients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    print("I am in checker")
                    let feedbackAngle = value?["angleFeedback"] as? String ?? ""
                    print("feedback: \(feedbackAngle)")
                    if feedbackAngle != "" {
                        self.sendAlert (
                            title: "Great job",
                            message: "You reached \(feedbackAngle) degrees."
                        )
                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func getUserArray () {
        if cnt == 1 {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("patients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print ("got to updating")
                self.userArray = value
            }) { (error) in
                print(error.localizedDescription)
            }
            cnt += 1
        }
    }
    
    
    func sendAlert (title: String, message: String) -> Void {
        let alertCntrl = UIAlertController (
            title: title,
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
    
}

