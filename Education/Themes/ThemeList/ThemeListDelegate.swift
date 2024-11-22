//
//  ThemeListViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/10/24.
//

import Foundation

@objc 
protocol ThemeListDelegate: AnyObject {
    func addThemeButtonTapped()
    func trashButtonTapped()
    func didCancel()
    func didDeleteTheme()
}

extension ThemeListViewController: ThemeListDelegate {
    func addThemeButtonTapped() {
        coordinator?.showTestPage(theme: nil, test: nil)
    }

    func trashButtonTapped() {
        let alertCase: AlertCase = .deletingTheme
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: themeListView)
        themeListView.deleteAlertView.config = alertConfig
        themeListView.deleteAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        themeListView.deleteAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        themeListView.changeAlertVisibility(isShowing: true)
    }
    
    func didCancel() {
        themeListView.changeAlertVisibility(isShowing: false)
    }
    
    func didDeleteTheme() {
        let theme = viewModel.themes.value[viewModel.selectedThemeIndex]
        viewModel.removeTheme(theme)
        viewModel.fetchThemes()
        themeListView.changeAlertVisibility(isShowing: false)
    }
}
