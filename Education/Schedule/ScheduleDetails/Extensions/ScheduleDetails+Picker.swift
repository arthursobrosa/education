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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if (pickerLabel == nil){
            pickerLabel = UILabel()
            pickerLabel!.font = UIFont(name: Fonts.darkModeOnRegular, size: 20)
            pickerLabel!.textColor = .gray
            pickerLabel!.textAlignment = .center
        }
        
        switch pickerView.tag {
            case 0:
                pickerLabel!.text = self.viewModel.days[row]
                return pickerLabel!
            case 1:
                pickerLabel!.text = self.viewModel.subjectsNames[row]
                return pickerLabel!
            default:
                break
        }

        return UILabel()
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
