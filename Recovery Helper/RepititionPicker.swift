//
//  RepititionPicker.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 4/30/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import UIKit

class RepititionPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let dummyData = [ "1", "2", "3", "4", "5" ]
    
    var repitionPicker = UIPickerView()
    
    
    repitionPicker.dataSource = self
    repitionPicker.delegate = self

    
    let repLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of repitions"
        label.font = label.font.withSize(23)
        return label
    }()
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dummyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repititionsInputView.text = dummyData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dummyData[row]
    }
    
    
    
    
    
}
