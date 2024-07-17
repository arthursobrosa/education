//
//  ThemeListViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

protocol ThemeDelegate: AnyObject {
    func addTheme()
}

extension ThemeListViewController: ThemeDelegate {
    func addTheme() {
        self.showAddThemeAlert()
    }
}
