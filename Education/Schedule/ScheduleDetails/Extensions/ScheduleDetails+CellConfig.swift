//
//  ScheduleDetails+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import SwiftUI
import UIKit

extension ScheduleDetailsViewController {
    func createCellTitle(for indexPath: IndexPath, numberOfSections: Int) -> String {
        let section = indexPath.section
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
        viewModel.blocksApps = sender.isOn
        
        if sender.isOn {
            showFamilyActivityPicker()
        }
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

    private func createToggle(isOn: Bool) -> UIView {
        let toggle = UISwitch()
        toggle.isOn = isOn
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
    
    private func showFamilyActivityPicker() {
        // Create the hosting controller with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIFamilyPickerView)

        let swiftuiView = hostingController.view
        swiftuiView?.translatesAutoresizingMaskIntoConstraints = false

        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        
        guard let swiftuiView else { return }

        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftuiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        hostingController.didMove(toParent: self)
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
            let toggle = createToggle(isOn: viewModel.blocksApps)
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
    }
}
