//
//  ThemePageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemePageCoordinator: Coordinator, ShowingTestPage {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var theme: Theme
    
    init(navigationController: UINavigationController, theme: Theme) {
        self.navigationController = navigationController
        self.theme = theme
    }
    
    func start() {
        let viewModel = ThemePageViewModel(themeID: self.theme.unwrappedID)
        let vc = ThemePageViewController(viewModel: viewModel)
        vc.title = self.theme.unwrappedName
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTestPage(viewModel: ThemePageViewModel) {
        let vc = TestPageViewController(viewModel: viewModel)
        vc.title = String(localized: "newTest")
        vc.modalPresentationStyle = .pageSheet
        self.navigationController.present(UINavigationController(rootViewController: vc), animated: true)
    }
}
