//
//  ScheduleNotificationCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import UIKit

class ScheduleNotificationCoordinator: NSObject, Coordinator, ShowingFocusSelection, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()
    
    private let subjectName: String
    private let startTime: Date
    private let endTime: Date
    
    private let blockingManager: BlockingManager
    
    init(navigationController: UINavigationController, subjectName: String, startTime: Date, endTime: Date, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.subjectName = subjectName
        self.startTime = startTime
        self.endTime = endTime
        self.blockingManager = blockingManager
    }
    
    func start() {
        let viewModel = ScheduleNotificationViewModel(subjectName: self.subjectName, startTime: self.startTime, endTime: self.endTime)
        let vc = ScheduleNotificationViewController(color: .red, viewModel: viewModel)
        vc.coordinator = self
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        
        self.newNavigationController.delegate = self
        if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            self.newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        self.newNavigationController.setNavigationBarHidden(true, animated: false)
        
        self.newNavigationController.modalPresentationStyle = .overFullScreen
        self.newNavigationController.modalTransitionStyle = .crossDissolve
        
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    func showFocusSelection(focusSessionModel: FocusSessionModel) {
        let child = FocusSelectionCoordinator(navigationController: self.newNavigationController, isFirstModal: false, focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
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

extension ScheduleNotificationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let focusSelectionVC = fromVC as? FocusSelectionViewController {
            self.childDidFinish(focusSelectionVC.coordinator as? Coordinator)
        }
    }
}
