//
//  ScheduleDetails+Picker.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate

extension ScheduleDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return viewModel.days.count
        case 1:
            return viewModel.subjectsNames.count + 1
        default:
            break
        }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
            pickerLabel?.textColor = .systemText30
            pickerLabel?.textAlignment = .center
        }

        switch pickerView.tag {
        case 0:
            pickerLabel?.text = viewModel.days[row]
        case 1:
            if row < viewModel.subjectsNames.count {
                pickerLabel?.text = viewModel.subjectsNames[row]
            } else {
                pickerLabel?.text = "Criar Nova"
                pickerLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
                pickerLabel?.textColor = .bluePicker
            }
        default:
            break
        }
        
        let selectedRow = pickerView.selectedRow(inComponent: component)
        if row == selectedRow {
            if row < viewModel.subjectsNames.count {
                let subjectColorName = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
                pickerLabel?.textColor = UIColor(named: subjectColorName)
            } else {
                pickerLabel?.textColor = .bluePicker
            }
        }

        return pickerLabel ?? UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            viewModel.selectedDay = viewModel.days[row]
            updateCellAccessory(for: viewModel.selectedDay, at: pickerView.tag, color: nil)
        case 1:
            if row < viewModel.subjectsNames.count {
                viewModel.selectedSubjectName = viewModel.subjectsNames[row]
                updateCellAccessory(for: viewModel.selectedSubjectName, at: pickerView.tag, color: viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName))
            } else {
                handleCreateNewSubject()
            }
        default:
            break
        }
        
        pickerView.reloadComponent(component)
    }
    
    private func updateCellAccessory(for text: String, at section: Int, color: String?) {
        let cell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 0, section: section))
        let label = createLabel(text: text, color: color)
        cell?.accessoryView = label
    }
    
    @objc func handleCreateNewSubject() {
        print("Criar Nova opção selecionada")
    }
}
