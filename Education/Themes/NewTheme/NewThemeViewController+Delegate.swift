//
//  NewThemeViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import Foundation

protocol NewThemeDelegate: AnyObject {
    func didTapCancelButton()
    func didTapContinueButton()
    func textFieldDidChange(newText: String)
}

extension NewThemeViewController: NewThemeDelegate {
    func didTapCancelButton() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func didTapContinueButton() {
        guard !self.viewModel.newThemeName.isEmpty else { return }
        
        self.viewModel.addTheme()
        self.viewModel.newThemeName = String()
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func textFieldDidChange(newText: String) {
        self.viewModel.newThemeName = newText
    }
}
