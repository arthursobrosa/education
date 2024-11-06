//
//  SettingsViewController+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 29/08/24.
//

import UIKit

extension SettingsViewController {
    func createDayPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.maxX,
                                y: cell.bounds.midY + 110,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: [], sourceRect: sourceRect, delegate: self)

        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self

        popoverVC.view = dayPicker

        let items = viewModel.days
        let selectedItem = viewModel.selectedDay

        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            dayPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }

        return popoverVC
    }

    func createCellTitle(for indexPath: IndexPath) -> String {
        let row = indexPath.row

        switch row {
        case 0:
            return String(localized: "notificationsTitle")
        case 1:
            return String(localized: "selectBlockedApps")
        default:
            return String()
        }
    }

    func createCellAccessoryView(for row: Int) -> UIView? {
        switch row {
        case 0:
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = viewModel.isNotificationActive.value
            toggleSwitch.onTintColor = UIColor(named: "bluePicker")
            toggleSwitch.thumbTintColor = .systemBackground
            toggleSwitch.addTarget(self, action: #selector(didChangeNotificationToggle(_:)), for: .valueChanged)

            return toggleSwitch
        case 1:
            let chevronImageView = UIImageView()
            chevronImageView.image = UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
            chevronImageView.tintColor = .systemText50
            chevronImageView.contentMode = .scaleAspectFit

            return chevronImageView
        case 2:
            let dayLabel = UILabel()
            dayLabel.text = viewModel.selectedDay
            dayLabel.tag = 0
            dayLabel.textColor = .systemText50
            dayLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)

            return dayLabel
        default:
            return nil
        }
    }
}

// MARK: - Popover Delegate

extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - PickerView Data Source and Delegate

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        viewModel.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        34
    }

    func pickerView(_: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 20)
            pickerLabel?.textColor = UIColor(named: "system-text-80")
            pickerLabel?.textAlignment = .center
        }

        pickerLabel?.text = viewModel.days[row]
        return pickerLabel ?? UIView()
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        viewModel.selectedDay = viewModel.days[row]

        guard let cell = settingsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SettingsTableViewCell else {
            fatalError("Could not get cell")
        }

        guard let dayOfWeekLabel = cell.customAccessoryView.subviews.first as? UILabel else { return }

        dayOfWeekLabel.text = viewModel.selectedDay

        if let dayIndex = viewModel.days.firstIndex(where: { $0 == self.viewModel.selectedDay }) {
            UserDefaults.dayOfWeek = Int(dayIndex)
        }
    }
}
