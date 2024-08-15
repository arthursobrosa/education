//
//  ScheduleDetailsModalViewController.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class ScheduleDetailsModalViewController: UIViewController {
    private let color: UIColor?
    weak var coordinator: (ShowingFocusSelection & Dismissing & DismissingAll & DismissingAfterModal & ShowingScheduleDetails)?
    let viewModel: ScheduleDetailsModalViewModel
    
    private lazy var scheduleModalView: ScheduleDetailsModalView = {
        let view = ScheduleDetailsModalView(color: self.color)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: ScheduleDetailsModalViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.view.backgroundColor = .clear
    }
}

extension ScheduleDetailsModalViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(scheduleModalView)
        
        NSLayoutConstraint.activate([
            scheduleModalView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 385/844),
            scheduleModalView.widthAnchor.constraint(equalTo: scheduleModalView.heightAnchor, multiplier: 359/385),
            scheduleModalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scheduleModalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension ScheduleDetailsModalViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.coordinator?.dismissAfterModal()
        
        return ActivityManager.shared.handleActivityDismissed(dismissed)
    }
}

#Preview {
    ScheduleDetailsModalViewController(viewModel: ScheduleDetailsModalViewModel(schedule: Schedule()), color: UIColor(named: "ScheduleColor1"))
}
