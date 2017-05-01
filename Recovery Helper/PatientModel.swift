//
//  PatientModel.swift
//  Road To Recovery
//
//  Created by Mario Hernandez on 12/2/16.
//  Copyright © 2016 Mario Hernandez. All rights reserved.
//

import Foundation
import Firebase


class PatientModel {
    
    fileprivate var firstName = ""
    fileprivate var lastName = ""
    fileprivate var email = ""
    fileprivate var profilePicURL = ""
    fileprivate var patientFrqHistory:[Double] = []
    fileprivate var patientAngHistory:[Double] = []
    fileprivate var usrID:String = ""

    init() {
        // get data from cur user swift
        
        if let curUser = FIRAuth.auth()?.currentUser{
            email = curUser.email!
            usrID = curUser.uid
        }
        else{
            return;
        }
        
    }
    
    
    func setPatientFrequencyHistory(_ frequencies: [Double]){
        for frq in frequencies{
            patientFrqHistory.append(frq)
        }
    }
    
    
    
    func setPatientAngleHistory(_ angles: [Double]){
        for ang in angles{
            patientAngHistory.append(ang)
        }
    }
    
    
    func getNumberOfAngles()-> Int{
        return self.patientAngHistory.count
    }
    
    func getNumberOfFrequencies()-> Int{
        return self.patientFrqHistory.count
    }
    
    func arrayFromContentsOfFileWithName(_ fileName: String) -> [String]? {
        var content: String = ""
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt")
            else {
                return nil
        }
        
        do {
            content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            let hello = content.components(separatedBy: "\n")
            
            return hello
        } catch _ as NSError {
            return nil
        }
    }
}
