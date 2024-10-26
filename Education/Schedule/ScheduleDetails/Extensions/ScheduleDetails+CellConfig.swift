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
        case 0:
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
        case 1:
            return String(localized: "subject")
        case 2:
            return row == 0 ? String(localized: "alarmAtTime") : String(localized: "alarm5Min")
        case 3:
            return String(localized: "blockApps")
        default:
            return String()
        }
    }

    @objc private func switchToggled(_ sender: UISwitch) {
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

    func createLabel(with text: String) -> UILabel {
        let label = UILabel()

        var labelText = text
        let maxLenght = 22

        if text.count > maxLenght {
            labelText = String(text.prefix(maxLenght)) + "..."
        }

        label.text = labelText
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .secondaryLabel
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

    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row

        switch section {
        case 0:
            if row == 0 {
                let label = createLabel(with: viewModel.selectedDay)

                return label
            }

            let datePicker = FakeDatePicker()
            datePicker.datePickerMode = .time
            datePicker.date = row == 1 ? viewModel.selectedStartTime : viewModel.selectedEndTime
            datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            datePicker.addTarget(self, action: #selector(datePickerEditionBegan(_:)), for: .editingDidBegin)
            datePicker.addTarget(self, action: #selector(datePickerEditionEnded), for: .editingDidEnd)
            datePicker.tag = row

            return datePicker
        case 1:
            let label = createLabel(with: viewModel.selectedSubjectName)

            return label
        case 2:
            let isOn = row == 0 ? viewModel.alarmInTime : viewModel.alarmBefore
            let toggle = createToggle(withTag: row, isOn: isOn)

            return toggle
        case 3:
            let toggle = createToggle(withTag: 2, isOn: viewModel.blocksApps)

            return toggle
        default:
            return nil
        }
    }
}
