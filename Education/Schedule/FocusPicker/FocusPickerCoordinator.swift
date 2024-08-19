//
//  FocusPickerCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerCoordinator: Coordinator, ShowingTimer, Dismissing, DismissingAll {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let focusSessionModel: FocusSessionModel
    
    init(navigationController: UINavigationController, focusSessionModel: FocusSessionModel) {
        self.navigationController = navigationController
        self.focusSessionModel = focusSessionModel
    }
    
    func start() {
        let viewModel = FocusPickerViewModel(focusSessionModel: self.focusSessionModel)
        let vc = FocusPickerViewController(viewModel: viewModel, color: self.focusSessionModel.color)
        vc.navigationItem.hidesBackButton = true
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showTimer(focusSessionModel: FocusSessionModel?) {
        guard let parentCoordinator = self.getParentCoordinator() as? ScheduleCoordinator else { return }
        
        parentCoordinator.showTimer(focusSessionModel: focusSessionModel)
    }
    
    func getParentCoordinator() -> Coordinator? {
        var parentCoordinator: Coordinator?
        
        if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            parentCoordinator = focusSelectionCoordinator.getParentCoordinator()
        }
        
        return parentCoordinator
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func dismissAll(animated: Bool) {
        self.dismiss(animated: animated)
        
        if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            focusSelectionCoordinator.dismissAll(animated: animated)
        }
    }
}
