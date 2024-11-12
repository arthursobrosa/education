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
        let numberOfAlarmSections = viewModel.numberOfAlarmSections()
        
        // Subject section
        if section == 0 {
            return String(localized: "subject")
        }
        
        // App Blocking section
        if section == numberOfSections - 1 {
            return String(localized: "blockApps")
        }
        
        // Alarm section
        if section >= (numberOfSections - 1) - numberOfAlarmSections {
            return String(localized: "scheduleAlarm")
        }
        
        return String()
    }

    @objc 
    private func switchToggled(_ sender: UISwitch) {
//        switch sender.tag {
//        case 0:
//            viewModel.alarmInTime = sender.isOn
//
//            guard viewModel.alarmInTime else { return }
//
//            viewModel.requestNotificationsAuthorization()
//        case 1:
//            viewModel.alarmBefore = sender.isOn
//
//            guard viewModel.alarmBefore else { return }
//
//            viewModel.requestNotificationsAuthorization()
//        case 2:
//            viewModel.blocksApps = sender.isOn
//        default:
//            break
//        }
    }

    func createLabel(text: String, color: String?) -> UILabel {
        let label = UILabel()
        var labelText = text
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
        let numberOfDaySections = viewModel.numberOfDaySections()
        let numberOfAlarmSections = viewModel.numberOfAlarmSections()
        
        // Subject section
        if section == 0 {
            let color = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
            let subjectName = viewModel.getSubjectName()
            let label = createLabel(text: subjectName, color: color)
            return label
        }
        
        // App Blocking section
        if section == numberOfSections - 1 {
            let toggle = createToggle(withTag: 2, isOn: viewModel.blocksApps)
            return toggle
        }
        
        // Alarms section
        if section >= (numberOfSections - 1) - numberOfAlarmSections {
            let index = section - 1 - numberOfDaySections
            let text = viewModel.getAlarmText(forIndex: index)
            let label = createLabel(text: text, color: nil)
            return label
        }
        
        return UIView()
        
//        // Alarm section
//        if section == numberOfSections - 2 {
//            let isOn = row == 0 ? viewModel.alarmInTime : viewModel.alarmBefore
//            let toggle = createToggle(withTag: row, isOn: isOn)
//            return toggle
//        }
    }
}
