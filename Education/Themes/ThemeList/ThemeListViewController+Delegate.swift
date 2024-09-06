//
//  ThemeListViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

protocol ThemeListDelegate: AnyObject {
    func didTapCancelButton()
    func didTapContinueButton()
    func setTextFieldDelegate(_ textField: UITextField)
}

extension ThemeListViewController: ThemeListDelegate {
    func didTapCancelButton() {
        self.themeListView.newThemeAlert.isHidden = true
    }
    
    func didTapContinueButton() {
        guard !self.viewModel.newThemeName.isEmpty else {
            return
        }
        
        self.viewModel.addTheme()
        self.viewModel.newThemeName = String()
        
        self.themeListView.newThemeAlert.isHidden = true
    }
    
    func setTextFieldDelegate(_ textField: UITextField) {
        textField.delegate = self
    }
}
