//
//  FocusSessionSettings+Picker.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

// MARK: - Picker Delegate
extension FocusSessionSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.subjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.subjects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.selectedSubject.value = self.viewModel.subjects[row]
        let cell = self.timerSettingsView.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cell?.textLabel?.text = self.viewModel.selectedSubject.value
    }
}
