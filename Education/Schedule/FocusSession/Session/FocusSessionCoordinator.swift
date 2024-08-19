//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class FocusSessionCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FocusSessionViewModel()
        let vc = FocusSessionViewController(viewModel: viewModel, color: ActivityManager.shared.color)
        vc.coordinator = self
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        
        if let delegateCoordinator = self.getTransitioningDelegate() as? UIViewControllerTransitioningDelegate {
            self.newNavigationController.transitioningDelegate = delegateCoordinator
        }

        self.newNavigationController.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    private func getTransitioningDelegate() -> Coordinator? {
        var delegateCoordinator: Coordinator?
        
        if let focusPickerCoordinator = self.parentCoordinator as? FocusPickerCoordinator {
            delegateCoordinator = focusPickerCoordinator
            
            focusPickerCoordinator.dismissAll()
        } else if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            if let focusImediateCoordinator = focusSelectionCoordinator.parentCoordinator as? FocusImediateCoordinator,
               let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator {
                delegateCoordinator = scheduleCoordinator
            } else if let scheduleCoordinator = focusSelectionCoordinator.parentCoordinator as? ScheduleCoordinator {
                delegateCoordinator = scheduleCoordinator
            }
            
            focusSelectionCoordinator.dismissAll()
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            delegateCoordinator = scheduleCoordinator
        }
        
        return delegateCoordinator
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}
