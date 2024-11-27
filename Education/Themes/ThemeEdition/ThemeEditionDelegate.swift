//
//  ThemeEditionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

@objc
protocol ThemeEditionDelegate: AnyObject {
    func didTapCancelButton()
    func didTapContinueButton()
    func setTextFieldDelegate(_ textField: UITextField)
    func textFieldDidChange(newText: String)
}

extension ThemeEditionViewController: ThemeEditionDelegate {
    func didTapCancelButton() {
        coordinator?.dismiss(animated: true)
    }

    func didTapContinueButton() {
        guard !viewModel.currentThemeName.isEmpty else { return }

        viewModel.updateTheme()
        viewModel.currentThemeName = String()

        coordinator?.dismiss(animated: true)
    }

    func setTextFieldDelegate(_ textField: UITextField) {
        textField.delegate = self
    }

    func textFieldDidChange(newText: String) {
        viewModel.currentThemeName = newText
    }
}
