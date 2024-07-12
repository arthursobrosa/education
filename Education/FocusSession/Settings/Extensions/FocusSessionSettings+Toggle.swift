//
//  FocusSessionSettings+Toggle.swift
//  Education
//
//  Created by Arthur Sobrosa on 08/07/24.
//

import UIKit

// MARK: - Toggle methods
extension FocusSessionSettingsViewController {
    func createToggle(for indexPath: IndexPath) -> UISwitch {
        let section = indexPath.section
        let row = indexPath.row
        
        let toggle = UISwitch()
        
        var selector = Selector(String())
        var isOn: Bool = false
        
        switch section {
            case 0:
                selector = #selector(subjectToggleSwitched(_:))
                toggle.tag = row - 1
                
                if let selectedData = self.viewModel.subjects.first(where: { $0 == self.viewModel.subjects[row - 1] }) {
                    isOn = selectedData == self.viewModel.selectedSubject
                }
            case 1:
                selector = #selector(alarmToggleSwiched(_:))
                isOn = self.viewModel.alarmWhenFinished
            case 2:
                selector = #selector(blockAppToggleSwitched(_:))
                isOn = self.viewModel.blockApps
            default:
                break
        }
        
        toggle.addTarget(self, action: selector, for: .valueChanged)
        toggle.isOn = isOn
        
        return toggle
    }
    
    @objc func blockAppToggleSwitched(_ sender: UISwitch) {
        self.viewModel.blockApps = sender.isOn
        self.reloadTable()
    }
    
    @objc func alarmToggleSwiched(_ sender: UISwitch) {
        self.viewModel.alarmWhenFinished = sender.isOn
    }
    
    @objc func subjectToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            self.unselectedToggles(sender.tag)
        } else {
            self.selectNoneToggle()
        }
        
        self.viewModel.selectedSubject = self.viewModel.subjects[(sender.isOn ? sender.tag : 0)]
    }
    
    func unselectedToggles(_ tag: Int) {
        for i in 0..<self.viewModel.subjects.count {
            let indexPath = IndexPath(row: i + 1, section: 0)
            let cell = self.timerSettingsView.tableView.cellForRow(at: indexPath)
            let toggle = cell?.accessoryView as! UISwitch
            
            if tag != toggle.tag {
                toggle.setOn(false, animated: true)
            }
        }
    }
    
    func selectNoneToggle() {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.timerSettingsView.tableView.cellForRow(at: indexPath)
        let toggle = cell?.accessoryView as! UISwitch
        toggle.isOn = true
        self.viewModel.selectedSubject = self.viewModel.subjects[toggle.tag]
    }
}
