//
//  FocusEnd+Picker.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

extension FocusEndViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.subjectNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
            pickerLabel?.textColor = .systemText50
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = viewModel.subjectNames[row]
        return pickerLabel ?? UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let subjectName = viewModel.subjectNames[row]
        viewModel.selectedSubjectInfo = (name: subjectName, index: row)
        reloadTable()
    }
}
