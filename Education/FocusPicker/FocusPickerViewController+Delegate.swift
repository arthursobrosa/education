//
//  FocusPickerViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

protocol FocusPickerDelegate: AnyObject {
    func startButtonTapped()
    func cancelButtonTapped()
}

extension FocusPickerViewController: FocusPickerDelegate {
    func startButtonTapped() {
        self.viewModel.setSelectedTime()
    }
    
    func cancelButtonTapped() {
        self.coordinator?.dismiss()
    }
}
