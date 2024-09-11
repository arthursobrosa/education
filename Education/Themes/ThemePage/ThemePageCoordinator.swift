//
//  ThemePageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemePageCoordinator: Coordinator, ShowingTestPage, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var theme: Theme
    
    init(navigationController: UINavigationController, theme: Theme) {
        self.navigationController = navigationController
        self.theme = theme
    }
    
    func start() {
        let viewModel = ThemePageViewModel(theme: self.theme)
        let vc = ThemePageViewController(viewModel: viewModel)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTestPage(viewModel: ThemePageViewModel) {
        let vc = TestPageViewController(viewModel: viewModel)
        vc.title = String(localized: "newTest")
        vc.modalPresentationStyle = .pageSheet
        self.navigationController.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
}
