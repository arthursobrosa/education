//
//  SettingsViewController+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 29/08/24.
//

import UIKit

extension SettingsViewController {
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
    
    func createCellAccessoryView(for indexPath: IndexPath) -> UIView? {
        let row = indexPath.row
        
        switch row {
            case 0:
                let toggleSwitch = UISwitch()
                toggleSwitch.isOn = self.viewModel.isNotificationActive.value
                toggleSwitch.addTarget(self, action: #selector(didChangeNotificationToggle(_:)), for: .valueChanged)
                
                return toggleSwitch
            case 1:
                return nil
            default:
                return nil
        }
    }
}
