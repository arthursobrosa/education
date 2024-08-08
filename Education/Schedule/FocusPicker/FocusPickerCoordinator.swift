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
    var timerCase: TimerCase?
    private let color: UIColor?
    private let subject: Subject?
    
    init(navigationController: UINavigationController, timerCase: TimerCase?, color: UIColor?, subject: Subject?) {
        self.navigationController = navigationController
        self.timerCase = timerCase
        self.color = color
        self.subject = subject
    }
    
    func start() {
        let viewModel = FocusPickerViewModel(timerCase: self.timerCase, subject: self.subject)
        let vc = FocusPickerViewController(viewModel: viewModel, color: self.color)
        vc.navigationItem.hidesBackButton = true
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showTimer<T: UIViewControllerTransitioningDelegate>(transitioningDelegate: T, timerState: FocusSessionViewModel.TimerState?, totalSeconds: Int, timerSeconds: Int, subject: Subject?, timerCase: TimerCase, isAtWorkTime: Bool) {
        let viewModel = FocusSessionViewModel(totalSeconds: totalSeconds, timerSeconds: timerSeconds, subject: subject, timerCase: timerCase, isAtWorkTime: isAtWorkTime)
        viewModel.timerState.value = timerState
        let vc = FocusSessionViewController(viewModel: viewModel, color: self.color)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.transitioningDelegate = transitioningDelegate
        
        self.navigationController.present(nav, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: false)
    }
    
    func dismissAll() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
