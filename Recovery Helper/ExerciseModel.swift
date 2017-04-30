//
//  ExerciseModel.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 4/13/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import Foundation

class ExerciseModel {
    // Instance variables
    var extensionTarget = 0
    var flexTarget      = 0
    var numberReps      = 0
    
    // Constructor
    init() {
        self.extensionTarget = 0
        self.numberReps      = 0
        self.flexTarget      = 0
    }
    
    func setFlexTarget(flexTarget: Int) {
        self.flexTarget = flexTarget
    }
    
    func setNumberOfReps(numReps: Int) {
        self.numberReps = numReps
    }
    
    func setExtensionTarget(extTrg: Int) {
        self.extensionTarget = extTrg
    }
    
    func validate() -> Bool {
        let repValid = self.numberReps > 0 ? true : false
        let extValid = self.extensionTarget >= 0 && self.extensionTarget <= 180 ? true : false
        let flexValid = self.flexTarget >= 0 && self.flexTarget <= 180 ? true : false
        
        if !repValid && !extValid && !flexValid {
            return false
        } else {
            return true
        }
        
    }
    
    
}
