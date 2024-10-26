//
//  ThemeListViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/10/24.
//

import Foundation

@objc protocol ThemeListDelegate: AnyObject {
    func addThemeButtonTapped()
    func dismissDeleteAlert()
    func removeTheme()
}

extension ThemeListViewController: ThemeListDelegate {
    func addThemeButtonTapped() {
        coordinator?.showThemeCreation(theme: nil)
    }

    func dismissDeleteAlert() {
        themeListView.changeAlertVisibility(isShowing: false)
    }

    func removeTheme() {
        let theme = viewModel.themes.value[viewModel.selectedThemeIndex]
        viewModel.removeTheme(theme)
        viewModel.fetchThemes()

        themeListView.changeAlertVisibility(isShowing: false)
    }
}
