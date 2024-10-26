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

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return viewModel.days.count
        case 1:
            return viewModel.subjectsNames.count
        default:
            break
        }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel!.font = UIFont(name: Fonts.darkModeOnRegular, size: 20)
            pickerLabel!.textColor = .gray
            pickerLabel!.textAlignment = .center
        }

        switch pickerView.tag {
        case 0:
            pickerLabel!.text = viewModel.days[row]
            return pickerLabel!
        case 1:
            pickerLabel!.text = viewModel.subjectsNames[row]
            return pickerLabel!
        default:
            break
        }

        return UILabel()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        let cell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 0, section: pickerView.tag))

        switch pickerView.tag {
        case 0:
            viewModel.selectedDay = viewModel.days[row]

            let label = createLabel(with: viewModel.selectedDay)

            cell?.accessoryView = label
        case 1:
            viewModel.selectedSubjectName = viewModel.subjectsNames[row]

            let label = createLabel(with: viewModel.selectedSubjectName)

            cell?.accessoryView = label
        default:
            break
        }
    }
}
