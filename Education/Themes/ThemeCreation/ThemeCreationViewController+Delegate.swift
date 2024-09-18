//
//  ThemeCreationViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

protocol ThemeCreationDelegate: AnyObject {
    func didTapCancelButton()
    func didTapContinueButton()
    func setTextFieldDelegate(_ textField: UITextField)
    func textFieldDidChange(newText: String)
}

extension ThemeCreationViewController: ThemeCreationDelegate {
    func didTapCancelButton() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func didTapContinueButton() {
        guard !self.viewModel.currentThemeName.isEmpty else { return }
        
        self.viewModel.saveTheme()
        self.viewModel.currentThemeName = String()
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func setTextFieldDelegate(_ textField: UITextField) {
        textField.delegate = self
    }
    
    func textFieldDidChange(newText: String) {
        self.viewModel.currentThemeName = newText
    }
}
