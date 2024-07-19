//
//  FocusSessionSettings+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 08/07/24.
//

import UIKit

// MARK: - Cell Configuration
extension FocusSessionSettingsViewController {
    func createCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                return self.viewModel.selectedSubjectName
            case 1:
                if row == 0 {
                    return String(localized: "focusEndsAt")
                }
                
                return String(localized: "focusAlarmWhenFinished")
            case 2:
                if row == 0 {
                    return String(localized: "focusBlock")
                }
                
                return String(localized: "focusApps")
            default:
                return String()
        }
    }
    
    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                return UIImageView(image: UIImage(systemName: "chevron.down"))
            case 1:
                if row == 0 {
                    let datePicker = UIDatePicker()
                    datePicker.setDate(self.viewModel.selectedDate, animated: false)
                    datePicker.minimumDate = Date.now
                    datePicker.datePickerMode = .time
                    datePicker.addTarget(self, action: #selector(timerPickerChange(_:)), for: .valueChanged)
                    return datePicker
                } else {
                    let toggle = self.createToggle(for: indexPath)
                    return toggle
                }
            case 2:
                if row == 0 {
                    let toggle = self.createToggle(for: indexPath)
                    return toggle
                } else {
                    return UIImageView(image: UIImage(systemName: "chevron.right"))
                }
            default:
                return nil
        }
    }
}
