//
//  SettingsViewController+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 29/08/24.
//

import UIKit

extension SettingsViewController {
    func createCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        
        switch section {
            case 0:
                return String(localized: "selectBlockedApps")
            case 1:
                return String(localized: "activateNotification")
            default:
                return String()
        }
    }
    
    func createCellAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        
        switch section {
            case 0:
                return nil
            case 1:
                let toggleSwitch = UISwitch()
                toggleSwitch.isOn = self.viewModel.isNotificationActive.value
                toggleSwitch.addTarget(self, action: #selector(didChangeNotificationToggle(_:)), for: .valueChanged)
                
                return toggleSwitch
            default:
                return nil
        }
    }
}
