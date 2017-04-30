//
//  ViewController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 12/23/16.
//  Copyright © 2016 Mario Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework


/***************************************************************/

class LoginController: UIViewController {
    
    //variables for login/register logic
    var inputViewHeightAnchor:NSLayoutConstraint?
    var nameFieldHeightAnchor:NSLayoutConstraint?
    var emailFieldHeightAnchor:NSLayoutConstraint?
    var passFieldHeightAnchor:NSLayoutConstraint?
    var patientPhysicianSegControlHeightAnchor:NSLayoutConstraint?
    
    /**** All views I need are here (For login view...) ****/
    // WELCOME TEXT VIEW
    let welcomeText: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = FlatWhiteDark()
        lable.text = "Welcome to X"
        lable.textAlignment = .center
        lable.font = UIFont.preferredFont(forTextStyle: .headline)
        
        lable.font = UIFont.boldSystemFont(ofSize: 30)
        return lable
    }()
    
    // Inputs VIEW
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        
        
        return view
    }()
    // login / Register button
    let loginRegistarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = FlatMint()
        button.setTitleColor(ContrastColorOf(FlatMint(), returnFlat: true), for: .normal)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    // nameField view
    let nameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        tf.resignFirstResponder()
        return tf
    }()
    
    // nameField seperate view
    let nameSeperatorView: UIView = {
        let nspartorView = UIView()
        nspartorView.translatesAutoresizingMaskIntoConstraints = false
        nspartorView.backgroundColor = FlatWhiteDark()
        return nspartorView
    }()
    
    // password seperate view
    let passwordSeperatorView: UIView = {
        let psv = UIView()
        psv.translatesAutoresizingMaskIntoConstraints = false
        psv.backgroundColor = FlatWhiteDark()
        return psv
    }()
    
    // email text field view
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.resignFirstResponder()
        return tf
    }()
    // email seperate view
    let emailSeperatorView: UIView = {
        let nspartorView = UIView()
        nspartorView.translatesAutoresizingMaskIntoConstraints = false
        nspartorView.backgroundColor = FlatWhiteDark()
        
        return nspartorView
    }()
    //password field view
    let passField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        tf.resignFirstResponder()
        return tf
    }()
    
    // Login register segmented controller view
    let loginRegistarSegmentedControl: UISegmentedControl = {
        let items = ["Login", "Register"]
        let sc = UISegmentedControl(items: items)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = FlatWhite()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    // Patient physician segmented controller view
    let patientPhysicianSegmentedControl: UISegmentedControl = {
        let items = ["Patient", "Physician"]
        let sc = UISegmentedControl(items: items)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = FlatGray()
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handlePatientPhysicianChange), for: .valueChanged)
        return sc
    }()
    
    /********************** Logic for starting up the views. ****************************/
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        print("viewDidAppear")
        
        
        
        if (FIRAuth.auth()?.currentUser) != nil {
            
            print("Message from viewDidAppear: User is logged in...")
            print("User is logged in... So lets see what is up!")
            
            /*********************************************************************************/
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            
            
            ref.child("patients").child(userID!).observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                    self.goToPatientView()
                }
                else {
                    self.goToPhysicianView()
                }
            })
            
        }else{
            print("Message from viewWillAppear: User is not logged in...")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlatBlue()
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        
        /************* Putting all major components in place **************/
        
        self.view.addSubview(inputContainerView)
        self.view.addSubview(loginRegistarButton)
        self.view.addSubview(loginRegistarSegmentedControl)
        self.view.addSubview(welcomeText)
        
        /************* Setting up all constraints. **************/
        
        setUpInputContainerView()
        setUpLoginRegistarContraints()
        setUpLoginRegisterSegmentedControl()
        setUpWelcomeTextConstraints()
    }
    
    func handleLoginRegisterChange(){
        
        let title = loginRegistarSegmentedControl.titleForSegment(at: loginRegistarSegmentedControl.selectedSegmentIndex)
        
        loginRegistarButton.setTitle(title, for: .normal)
        
        inputViewHeightAnchor?.constant = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? 150 : 200
        
        let nameMultipler = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? 0 as CGFloat : 1/4 as CGFloat
        let emailMultipler = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? 1/3 as CGFloat: 1/4 as CGFloat
        let passwordMultipler = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? 1/3 as CGFloat : 1/4 as CGFloat
        let patPhysMultipler = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? (1/3 as CGFloat) : 1/4 as CGFloat
        
        
        print("Name mulitplier: \(nameMultipler)")
        print("Email multipler: \(emailMultipler)")
        print("Password multipler: \(passwordMultipler)")
        print("patPhysSegControl multipler: \(patPhysMultipler)")
        
        /* Logic for hiding the name field */
        nameFieldHeightAnchor?.isActive = false
        nameFieldHeightAnchor = nameField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: nameMultipler)
        nameField.isHidden = loginRegistarSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameFieldHeightAnchor?.isActive = true
        
        /* Logic for shrinking email field */
        emailFieldHeightAnchor?.isActive = false
        emailFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: emailMultipler)
        emailFieldHeightAnchor?.isActive = true
        
        /* Logic for shrinking password field */
        passFieldHeightAnchor?.isActive = false
        passFieldHeightAnchor = passField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: passwordMultipler)
        passFieldHeightAnchor?.isActive = true
        
        /* logic for shrinking patient physcian segmented controller */
        patientPhysicianSegControlHeightAnchor?.isActive = false
        patientPhysicianSegControlHeightAnchor = patientPhysicianSegmentedControl.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: patPhysMultipler)
        patientPhysicianSegControlHeightAnchor?.isActive = true
        
    }
    
    func handlePatientPhysicianChange(){
        print(patientPhysicianSegmentedControl.selectedSegmentIndex)
        if patientPhysicianSegmentedControl.selectedSegmentIndex == 0 {
            print("I'm a patient")
        }
        else {
            print("I'm a Physician")
        }
    }
    
    /*****************************************************************/
    
    //I will use this function to make sure the keyboard is working properly
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("touchesBegan")
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    func setUpWelcomeTextConstraints(){
        welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeText.centerYAnchor.constraint(equalTo: loginRegistarSegmentedControl.topAnchor, constant: -60).isActive = true
        welcomeText.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    
    func setUpLoginRegisterSegmentedControl(){
        loginRegistarSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegistarSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegistarSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegistarSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    
    func setUpInputContainerView(){
        // center X contraint
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // center Y contraint
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // Setting width anchor
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        //setting Height Contraint
        inputViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputViewHeightAnchor?.isActive = true
        
        
        
        
        /*ADDING ALL OF THE SUB VIEWS THAT I NEED*/
        inputContainerView.addSubview(nameField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passField)
        inputContainerView.addSubview(patientPhysicianSegmentedControl)
        inputContainerView.addSubview(passwordSeperatorView)
        
        
        
        //setting containts for name field
        nameField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameFieldHeightAnchor = nameField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        nameFieldHeightAnchor?.isActive = true
        
        
        //setting containts for name field seperator
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //setting containts for email field
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4 as CGFloat)
        
        emailFieldHeightAnchor?.isActive = true
        
        //setting containts for email field seperator
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //setting containts for password field
        passField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passFieldHeightAnchor = passField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        passFieldHeightAnchor?.isActive = true
        
        //setting up constraints for password seperator
        passwordSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        passwordSeperatorView.topAnchor.constraint(equalTo: passField.bottomAnchor).isActive = true
        passwordSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //setting up constraints for patientPhysicianSegmentedControl
        patientPhysicianSegmentedControl.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        patientPhysicianSegmentedControl.topAnchor.constraint(equalTo: passField.bottomAnchor).isActive = true
        patientPhysicianSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        patientPhysicianSegControlHeightAnchor = patientPhysicianSegmentedControl.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        patientPhysicianSegControlHeightAnchor?.isActive = true
        
        
    }
    
    
    func setUpLoginRegistarContraints(){
        loginRegistarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegistarButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegistarButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegistarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func goToPatientView(){
        let patientController:PatientController = PatientController()
        
        let navigationController = UINavigationController(rootViewController: patientController)
        
        present(navigationController, animated: false, completion: nil)
    }
    
    func goToPhysicianView(){
        
        let physicianController = PhysicianController()
        
        let navigationController = UINavigationController(rootViewController: physicianController)
        
        present(navigationController, animated: false, completion: nil)
    }
    
    
    func handleLoginRegister(){
        
        if loginRegistarSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        //        var patientBool:Bool = false
        if(emailTextField.text == "" || passField.text == ""){
            let alertCntrl = UIAlertController(title: "Ooops!", message:  "Please enter both email and password.", preferredStyle: .alert)
            let defltActn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertCntrl.addAction(defltActn)
            self.present(alertCntrl, animated: true, completion: nil)
        } else{
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passField.text!, completion: {(user, error) in
                
                if error == nil{
                    print("segmented\(self.loginRegistarSegmentedControl.selectedSegmentIndex)")
                    
                    if self.patientPhysicianSegmentedControl.selectedSegmentIndex == 0 {
                        print("PATIENThi...")
                        self.goToPatientView()
                    }
                    else{
                        print("Physicianhi...")
                        self.goToPhysicianView()
                    }
                    
                }
                else{
                    let alertCntrl = UIAlertController(title: "Ooops!", message:  error?.localizedDescription, preferredStyle: .alert)
                    let defltActn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertCntrl.addAction(defltActn)
                    self.present(alertCntrl, animated: true, completion: nil)
                    
                }
            })
        }
        
    }
    
    
    /***************/
    func handleRegister(){
        if(nameField.text == "" || emailTextField.text == "" || passField.text == ""){
            let alertCntrl = UIAlertController(title: "Ooops!", message:  "Please enter both email and password.", preferredStyle: .alert)
            let defltActn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertCntrl.addAction(defltActn)
            self.present(alertCntrl, animated: true, completion: nil)
        } else{
            print("in handleRegister()")
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passField.text!, completion: {(user, error) in
                if error == nil{
                    guard let usrID = user?.uid else{
                        return
                    }
                    weak var selfWeak = self
                    let dataBaseReference = FIRDatabase.database().reference(fromURL: "https://recovery-helper.firebaseio.com/")
                    let values = ["email": selfWeak?.emailTextField.text, "name": selfWeak?.nameField.text]
                    if self.patientPhysicianSegmentedControl.selectedSegmentIndex == 0 {
                        let patientChild = dataBaseReference.child("patients").child(usrID)
                        patientChild.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err == nil{
                                print("Saved user successfully into Firebase's real time DB.")
                            }
                            else{
                                print(err!)
                            }
                        })
                    }
                    else {
                        let physicianChild = dataBaseReference.child("physicians").child(usrID)
                        physicianChild.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err == nil{
                                print("Saved user successfully into Firebase's real time DB.")
                            }
                            else{
                                print(err!)
                            }
                        })
                    }
                    if self.patientPhysicianSegmentedControl.selectedSegmentIndex == 0 {
                        self.goToPatientView()
                    }
                    else{
                        print("This user -> \(FIRAuth.auth()?.currentUser) is not a patient... So let's go to physician view!")
                        self.goToPhysicianView()
                    }
                } else {
                    let alertCntrl = UIAlertController(title: "Ooops!", message:  error?.localizedDescription, preferredStyle: .alert)
                    let defltActn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertCntrl.addAction(defltActn)
                    self.present(alertCntrl, animated: true, completion: nil)
                }
            })
        }
    }
}
/****************************************************************************************************************/

//Helper extension for keyboard hiding

// This is a sub class of the view controller.


extension UIViewController {
    /*
     name: hideKeyboardWhenTappedAround
     function: Enables a listener for a tap
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /*
     name: dismissKeyboard
     function: it ends the editing feature. I.E., gets rid of the keyboard.
     */
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
