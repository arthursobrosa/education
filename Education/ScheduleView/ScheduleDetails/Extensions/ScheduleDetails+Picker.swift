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
                return self.viewModel.subjectsNames.count
            case 1:
                return self.viewModel.days.count
            default:
                break
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 0:
                return self.viewModel.subjectsNames[row]
            case 1:
                return self.viewModel.days[row]
            default:
                break
        }
        
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tableRow = pickerView.tag == 0 ? 1 : 0
        let cell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: tableRow, section: pickerView.tag))
        
        switch pickerView.tag {
            case 0:
                self.viewModel.selectedSubjectName = self.viewModel.subjectsNames[row]
                cell?.textLabel?.text = self.viewModel.selectedSubjectName
            case 1:
                self.viewModel.selectedDay = self.viewModel.days[row]
                cell?.textLabel?.text = self.viewModel.selectedDay
            default:
                break
        }
    }
}
