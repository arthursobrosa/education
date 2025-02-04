//
//  TestPageViewController+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/09/24.
//

import UIKit

extension TestPageViewController {
    func getCellTitle(for indexPath: IndexPath, numberOfSections: Int) -> String {
        let section = indexPath.section
        let row = indexPath.row

        if numberOfSections == 2 {
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
        
        switch section {
        case 0:
            return String(localized: "name")
        case 1:
            return String(localized: "testDate")
        case 2:
            if row == 0 {
                return String(localized: "totalQuestions")
            }

            return String(localized: "rightQuestions")
        default:
            return String()
        }
    }

    func getAccessoryView(for indexPath: IndexPath, numberOfSections: Int) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        if numberOfSections == 2 {
            switch section {
            case 0:
                let datePicker = FakeDatePicker()
                datePicker.maximumDate = Date()
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                datePicker.date = viewModel.date
                return datePicker
            case 1:
                let textField = UITextField()
                textField.tag = row + 1
                textField.keyboardType = .numberPad
                textField.placeholder = String(repeating: " ", count: 30)
                textField.text = "\(row == 0 ? viewModel.totalQuestions : viewModel.rightQuestions)"
                textField.textAlignment = .right
                textField.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
                textField.textColor = .systemText50
                textField.sizeToFit()
                textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
                textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
                return textField
            default:
                return nil
            }
        }

        switch section {
        case 0:
            let textField = UITextField()
            textField.tag = 0
            textField.font = .init(name: Fonts.darkModeOnRegular, size: 16)
            textField.textColor = .systemText50
                
            let placeholderTitle = String(localized: "themePlaceholder")
            let placeholderColor: UIColor = .systemText40
            let placeholderFont: UIFont = .init(name: Fonts.darkModeOnItalic, size: 16) ?? .italicSystemFont(ofSize: 16)
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .font: placeholderFont,
            ]
            let attributedPlaceholder = NSAttributedString(string: placeholderTitle, attributes: placeholderAttributes)
            textField.attributedPlaceholder = attributedPlaceholder
            textField.placeholder = String(localized: "themePlaceholder")
                
            textField.textAlignment = .right
            textField.sizeToFit()
            textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
            return textField
            
        case 1:
            let datePicker = FakeDatePicker()
            datePicker.maximumDate = Date()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            datePicker.date = viewModel.date
            return datePicker
        case 2:
            let textField = UITextField()
            textField.tag = row + 1
            textField.keyboardType = .numberPad
            textField.placeholder = String(repeating: " ", count: 30)
            textField.text = "\(row == 0 ? viewModel.totalQuestions : viewModel.rightQuestions)"
            textField.textAlignment = .right
            textField.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
            textField.textColor = .systemText50
            textField.sizeToFit()
            textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
            textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
            return textField
        default:
            return nil
        }
    }
}
