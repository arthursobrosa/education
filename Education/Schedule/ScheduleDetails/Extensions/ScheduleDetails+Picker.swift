//
//  ScheduleDetails+Picker.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate
extension ScheduleDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case 0:
                return self.viewModel.days.count
            case 1:
                return self.viewModel.subjectsNames.count
            default:
                break
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 0:
                return self.viewModel.days[row]
            case 1:
                return self.viewModel.subjectsNames[row]
            default:
                break
        }
        
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 0, section: pickerView.tag))
        
        switch pickerView.tag {
            case 0:
                self.viewModel.selectedDay = self.viewModel.days[row]
            
                let label = self.createLabel(with: self.viewModel.selectedDay)
     
                cell?.accessoryView = label
            case 1:
                self.viewModel.selectedSubjectName = self.viewModel.subjectsNames[row]
                
                let label = self.createLabel(with: self.viewModel.selectedSubjectName)
            
                cell?.accessoryView = label
            default:
                break
        }
    }
}
