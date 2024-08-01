//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSettingsCoordinator: Coordinator, Dismissing {
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
        vc.title = String(localized: "focusSession")
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTimer(totalTimeInSeconds: Int, subjectID: String?) {
        let child = FocusSessionCoordinator(navigationController: self.navigationController, totalTimeInSeconds: totalTimeInSeconds, subjectID: subjectID)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
