//
//  FocusImediateCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateCoordinator: NSObject, Coordinator, ShowingFocusSelection, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()
    
    private let blockingManager: BlockingManager
    
    init(navigationController: UINavigationController, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
    }
    
    func start() {
        let viewModel = FocusImediateViewModel()
        let vc = FocusImediateViewController(viewModel: viewModel, color: .systemBackground)
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

extension FocusImediateCoordinator: UINavigationControllerDelegate {
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
