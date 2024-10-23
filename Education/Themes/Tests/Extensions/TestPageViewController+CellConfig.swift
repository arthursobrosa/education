//
//  TestPageViewController+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/09/24.
//

import UIKit

extension TestPageViewController {
    func getCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                return String(localized: "testDate")
            case 1:
                if row == 0 {
                    return String(localized: "totalQuestions")
                }
                
                return String(localized: "rightQuestions")
            default:
                return String()
        }
    }
    
    func getAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                let datePicker = FakeDatePicker()
                datePicker.maximumDate = Date()
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                datePicker.date = self.viewModel.date
                
                return datePicker
            case 1:
                let textField = UITextField()
                textField.tag = row
                textField.keyboardType = .numberPad
                textField.placeholder = String(repeating: " ", count: 30)
                textField.text = "\(row == 0 ? self.viewModel.totalQuestions : self.viewModel.rightQuestions)"
                textField.textAlignment = .right
                textField.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
                textField.textColor = .systemText50
                textField.sizeToFit()
                
                let toolbar = self.createToolbar(withTag: row)
                textField.inputAccessoryView = toolbar
            
                textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
                textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
            
                return textField
            default:
                return nil
        }
    }
    
    private func createToolbar(withTag tag: Int) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneKeyboardButtonTapped(_:)))
        doneButton.tag = tag
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        return toolbar
    }
}
