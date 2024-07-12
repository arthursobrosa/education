//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class FocusSessionCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var totalTimeInSeconds: Int
    var subjectID: String?
    
    init(navigationController: UINavigationController, totalTimeInSeconds: Int, subjectID: String?) {
        self.navigationController = navigationController
        self.totalTimeInSeconds = totalTimeInSeconds
        self.subjectID = subjectID
    }
    
    func start() {
        let viewModel = FocusSessionViewModel(totalSeconds: self.totalTimeInSeconds, subjectID: self.subjectID)
        let vc = FocusSessionViewController(viewModel: viewModel)
        vc.title = "Focus Session"
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
