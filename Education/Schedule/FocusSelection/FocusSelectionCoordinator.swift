//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: NSObject, Coordinator, ShowingFocusPicker, ShowingTimer, Dismissing, DismissingAll {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let isFirstModal: Bool
    private var newNavigationController = UINavigationController()
    
    private let focusSessionModel: FocusSessionModel
    private let blockingManager: BlockingManager
    
    init(navigationController: UINavigationController, isFirstModal: Bool, focusSessionModel: FocusSessionModel, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.isFirstModal = isFirstModal
        self.focusSessionModel = focusSessionModel
        self.blockingManager = blockingManager
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel(focusSessionModel: self.focusSessionModel)
        let vc = FocusSelectionViewController(viewModel: viewModel, color: self.focusSessionModel.color)
        vc.coordinator = self
        
        if isFirstModal {
            self.newNavigationController = UINavigationController(rootViewController: vc)
            
            self.newNavigationController.delegate = self
            if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
                self.newNavigationController.transitioningDelegate = scheduleCoordinator
            }
            
            self.newNavigationController.setNavigationBarHidden(true, animated: false)
            
            self.newNavigationController.modalPresentationStyle = .overFullScreen
            self.newNavigationController.modalTransitionStyle = .crossDissolve
            
            self.navigationController.present(self.newNavigationController, animated: true)
            
            return
        }
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showFocusPicker(focusSessionModel: FocusSessionModel) {
        let child = FocusPickerCoordinator(navigationController: self.isFirstModal ? self.newNavigationController : self.navigationController, focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showTimer(focusSessionModel: FocusSessionModel?) {
        guard let scheduleCoordinator = self.getParentCoordinator() as? ScheduleCoordinator else { return }
        
        scheduleCoordinator.showTimer(focusSessionModel: focusSessionModel)
    }
    
    func getParentCoordinator() -> Coordinator? {
        var parentCoordinator: Coordinator?
        
        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator,
           let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        } else if let scheduleDetailsModalCoordinator = self.parentCoordinator as? ScheduleDetailsModalCoordinator,
                  let scheduleCoordinator = scheduleDetailsModalCoordinator.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        }
        
        self.dismissAll()
        
        return parentCoordinator
    }
    
    func dismiss(animated: Bool) {
        if isFirstModal {
            self.navigationController.dismiss(animated: animated)
            
            return
        }
        
        self.navigationController.popViewController(animated: !animated)
    }
    
    func dismissAll() {
        self.dismiss(animated: isFirstModal)
        
        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator {
            focusImediateCoordinator.dismiss(animated: false)
        }
        
        if let scheduleDetailsModalCoordinator = self.parentCoordinator as? ScheduleDetailsModalCoordinator {
            scheduleDetailsModalCoordinator.dismiss(animated: false)
        }
        
        if let scheduleNotificationCoordinator = self.parentCoordinator as? ScheduleNotificationCoordinator {
            scheduleNotificationCoordinator.dismiss(animated: false)
        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension FocusSelectionCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let focusPickerVC = fromVC as? FocusPickerViewController {
            self.childDidFinish(focusPickerVC.coordinator as? Coordinator)
        }
    }
}
