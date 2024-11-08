//
//  ScheduleDetails+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

extension ScheduleDetailsViewController {
    func createCellTitle(for indexPath: IndexPath, numberOfSections: Int) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        // Subject section
        if section == 0 {
            return String(localized: "subject")
        }
        
        // Alarm section
        if section == numberOfSections - 2 {
            return row == 0 ? String(localized: "alarmAtTime") : String(localized: "alarm5Min")
        }
        
        // App Blocking section
        if section == numberOfSections - 1 {
            return String(localized: "blockApps")
        }
        
        // Day section
        switch row {
        case 0:
            return String(localized: "dayOfWeek")
        case 1:
            return String(localized: "startDate")
        case 2:
            return String(localized: "endDate")
        default:
            return String()
        }
    }

    @objc 
    private func switchToggled(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            viewModel.alarmInTime = sender.isOn

            guard viewModel.alarmInTime else { return }

            viewModel.requestNotificationsAuthorization()
        case 1:
            viewModel.alarmBefore = sender.isOn

            guard viewModel.alarmBefore else { return }

            viewModel.requestNotificationsAuthorization()
        case 2:
            viewModel.blocksApps = sender.isOn
        default:
            break
        }
    }

    func createLabel(text: String, color: String?) -> UILabel {
        let label = UILabel()

        var labelText = text
        
        if text.isEmpty {
            labelText = String(localized: "createNewSubject")
        }
        
        let maxLength = 22

        if text.count > maxLength {
            labelText = String(text.prefix(maxLength)) + "..."
        }

        label.text = labelText
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
        
        if let color {
            label.textColor = UIColor(named: color)?.darker(by: 0.8)
        } else {
            label.textColor = UIColor(named: "system-text-50")
        }

        label.sizeToFit()

        return label
    }

    private func createToggle(withTag tag: Int, isOn: Bool) -> UIView {
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.tag = tag
        toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .touchUpInside)
        toggle.onTintColor = UIColor(named: "bluePicker")
        toggle.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView(frame: toggle.bounds)
        containerView.addSubview(toggle)

        NSLayoutConstraint.activate([
            toggle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: toggle.bounds.width * 0.05),
        ])

        return containerView
    }

    func createAccessoryView(for indexPath: IndexPath, numberOfSections: Int) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        // Subject section
        if section == 0 {
            let color = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
            let label = createLabel(text: viewModel.selectedSubjectName, color: color)
            return label
        }
        
        // Alarm section
        if section == numberOfSections - 2 {
            let isOn = row == 0 ? viewModel.alarmInTime : viewModel.alarmBefore
            let toggle = createToggle(withTag: row, isOn: isOn)
            return toggle
        }
        
        // App Blocking section
        if section == numberOfSections - 1 {
            let toggle = createToggle(withTag: 2, isOn: viewModel.blocksApps)
            return toggle
        }
        
        // Day section
        let isUpdating = viewModel.isUpdatingSchedule()
        
        if isUpdating {
            if row == 0 {
                let label = createLabel(text: viewModel.editingScheduleDay, color: nil)
                return label
            }
            
            let datePicker = FakeDatePicker()
            datePicker.datePickerMode = .time
            datePicker.date = row == 1 ? viewModel.selectedStartTime : viewModel.selectedEndTime
            datePicker.addTarget(self, action: #selector(datePickerEditionBegan(_:)), for: .editingDidBegin)
            datePicker.addTarget(self, action: #selector(datePickerEditionEnded), for: .editingDidEnd)
            datePicker.tag = row

            return datePicker
        }
        
        let index = section - 1
        
        if row == 0 {
            let label = createLabel(text: viewModel.selectedDays[index].name, color: nil)
            return label
        }
        
        let selectedStartTime = viewModel.selectedDays[index].startTime
        let selectedEndTime = viewModel.selectedDays[index].endTime
        
        let datePicker = FakeDatePicker()
        datePicker.datePickerMode = .time
        datePicker.date = row == 1 ? selectedStartTime : selectedEndTime
        datePicker.addTarget(self, action: #selector(datePickerEditionBegan(_:)), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(datePickerEditionEnded(_:)), for: .editingDidEnd)
        datePicker.tag = (index * 2) + row

        return datePicker
    }
}
