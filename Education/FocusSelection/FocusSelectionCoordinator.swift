//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: NSObject, Coordinator, ShowingFocusPicker, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel()
        let vc = FocusSelectionViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showFocusPicker(timerCase: TimerCase?) {
        let child = FocusPickerCoordinator(navigationController: self.navigationController, timerCase: timerCase)
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = self.navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if self.navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let focusPickerViewController = fromViewController as? FocusPickerViewController {
            self.childDidFinish(focusPickerViewController.coordinator as? Coordinator)
        }
    }
}
