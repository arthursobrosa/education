//
//  FocusEndCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class FocusEndCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let activityManager: ActivityManager
    
    init(navigationController: UINavigationController, activityManager: ActivityManager) {
        self.navigationController = navigationController
        self.activityManager = activityManager
    }
    
    func start() {
        let viewModel = FocusEndViewModel(activityManager: activityManager)
        let vc = FocusEndViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
