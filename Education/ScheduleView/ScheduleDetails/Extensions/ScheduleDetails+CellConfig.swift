//
//  ScheduleDetails+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

extension ScheduleDetailsViewController {
    func createCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 2:
                return self.viewModel.subjectsNames.isEmpty ? String(localized: "addSubjectAlertTitle") : (row == 0 ? String(localized: "addSubjectAlertTitle") : self.viewModel.selectedSubjectName)
            case 0:
            
                switch row {
                case 0:
                    return self.viewModel.selectedDay
                case 1:
                    return String(localized: "scheduleStartDate")
                case 2:
                    return String(localized: "scheduleEndDate")
                default:
                    return String()
                }
            case 1:
                return row == 0 ? "Alarme 5 min" : "Alarme"
          
                
            default:
                return String()
        }
    }
    
    @objc private func switchToggledBefore(_ sender: UISwitch){
        if sender.isOn{
            self.viewModel.alarmBefore = true
            
            NotificationService.shared.requestAuthorization{granted, error in
                if granted{
                    print("permitiu")
                } else if let error = error {
                    print(error.localizedDescription)
                }
                
            }
            
        } else {
            self.viewModel.alarmBefore = false
        }
    }
    
    @objc private func switchToggledInTime(_ sender: UISwitch){
        if sender.isOn{
            self.viewModel.alarmInTime = true
            
            
            
        } else {
            self.viewModel.alarmInTime = false
        }
    }
    
    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 2:
                let systemName = self.viewModel.subjectsNames.isEmpty ? "plus" : (row == 0 ? "plus" : "chevron.down")
                return UIImageView(image: UIImage(systemName: systemName))
            case 0:
            
                if(row == 0){
                    return UIImageView(image: UIImage(systemName: "chevron.down"))
                }
            
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.date = row == 0 ? self.viewModel.selectedStartTime : self.viewModel.selectedEndTime
                datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                datePicker.tag = row
                return datePicker
            
            case 1:
                
            if(row == 0){
                
                let toggleSwitch = UISwitch()
                toggleSwitch.addTarget(self, action: #selector(switchToggledBefore(_:)), for: .valueChanged)
                
                return toggleSwitch
            }
                
            
                let toggleSwitch = UISwitch()
                toggleSwitch.addTarget(self, action: #selector(switchToggledInTime(_:)), for: .valueChanged)
                
                return toggleSwitch
            default:
                return nil
        }
    }
}
