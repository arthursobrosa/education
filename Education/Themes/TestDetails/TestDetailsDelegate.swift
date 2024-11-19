//
//  TestDetailsDelegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/11/24.
//

import Foundation

@objc
protocol TestDetailsDelegate: AnyObject {
    func didTapEditButton()
    func didTapBackButton()
}

extension TestDetailsViewController: TestDetailsDelegate {
    func didTapEditButton() {
        coordinator?.showTestPage(theme: viewModel.theme, test: viewModel.test)
    }
    
    func didTapBackButton() {
        coordinator?.dismiss(animated: true)
    }
}
