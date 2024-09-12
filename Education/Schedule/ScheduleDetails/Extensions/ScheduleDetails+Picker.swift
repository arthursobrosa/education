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
            case 2:
                return self.viewModel.subjectsNames.count
            case 0:
                return self.viewModel.days.count
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
            case 2:
                pickerLabel!.text = self.viewModel.subjectsNames[row]
                return pickerLabel!
            default:
                break
        }

        return UILabel()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tableRow = 0
        let cell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: tableRow, section: pickerView.tag))
        
        switch pickerView.tag {
            case 0:
                self.viewModel.selectedDay = self.viewModel.days[row]
            
                let label = UILabel()
                label.text = "\(self.viewModel.selectedDay)"
               
                let containerView = self.createAttributedLabel(withText: "\(self.viewModel.selectedDay)", symbolName: "chevron.up.chevron.down", symbolColor: .secondaryLabel,  textColor: .secondaryLabel)
                cell?.accessoryView = containerView
            case 2:
                self.viewModel.selectedSubjectName = self.viewModel.subjectsNames[row]
            
                let containerView = self.createAttributedLabel(withText: "\(self.viewModel.selectedSubjectName)", symbolName: "chevron.up.chevron.down", symbolColor: .secondaryLabel,  textColor: .secondaryLabel)
                cell?.accessoryView = containerView
            default:
                break
        }
    }
}
