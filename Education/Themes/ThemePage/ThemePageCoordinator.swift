//
//  ThemePageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemePageCoordinator: Coordinator {
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
        vc.title = theme.unwrappedName
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}
