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
        
        let section = indexPath.section
        
        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.maxX,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section
        
        popoverVC.view = dayPicker
        
        let items = self.viewModel.days
        let selectedItem = self.viewModel.selectedDay
        
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
                toggleSwitch.isOn = self.viewModel.isNotificationActive.value
                toggleSwitch.onTintColor = UIColor(named: "bluePicker")
                toggleSwitch.addTarget(self, action: #selector(didChangeNotificationToggle(_:)), for: .valueChanged)
                
                return toggleSwitch
            case 1:
                let chevronImageView = UIImageView()
                chevronImageView.image = UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
                chevronImageView.tintColor = .secondaryLabel
                chevronImageView.contentMode = .scaleAspectFit
                
                return chevronImageView
            case 2:
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 5
                
                let dayLabel =  UILabel()
                dayLabel.text = self.viewModel.selectedDay
                dayLabel.tag = 0
                dayLabel.textColor = .secondaryLabel
                dayLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)
                
                let chevronImageView = UIImageView()
                chevronImageView.image = UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
                chevronImageView.tintColor = .secondaryLabel
                chevronImageView.contentMode = .scaleAspectFit
                
                stackView.addArrangedSubview(dayLabel)
                stackView.addArrangedSubview(chevronImageView)
                
                return stackView
            default:
                return nil
        }
    }
}

// MARK: - Popover Delegate
extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.selectedDay = self.viewModel.days[row]
        
        guard let cell = self.settingsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SettingsTableViewCell else {
            fatalError("Could not get cell")
        }
        
        guard let stackView = cell.customAccessoryView.subviews.first as? UIStackView,
              let dayOfWeekLabel = stackView.arrangedSubviews.first(where: { $0.tag == 0}) as? UILabel else { return }
        
        
        dayOfWeekLabel.text = self.viewModel.selectedDay
        
        if let dayIndex = self.viewModel.days.firstIndex(where: { $0 == self.viewModel.selectedDay }) {
            UserDefaults.dayOfWeek = Int(dayIndex)
        }
    }
}
