//
//  FocusPickerViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

protocol FocusPickerDelegate: AnyObject {
    func setDate(_ date: Date)
}

extension FocusPickerViewController: FocusPickerDelegate {
    func setDate(_ date: Date) {
        self.viewModel.setSelectedTime(date)
    }
}
