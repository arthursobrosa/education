//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

protocol ScheduleDelegate: AnyObject {
    func onSelectTask(_ schedule: Schedule?)
}

class ScheduleViewController: UIViewController {
    weak var coordinator: ScheduleCoordinator?
    private let viewModel: ScheduleViewModel
    
    private lazy var scheduleView: ScheduleView = {
        let view = ScheduleView(viewModel: self.viewModel)
        view.delegate = self
        return view
    }()
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addScheduleButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addScheduleButtonTapped))
        self.navigationItem.rightBarButtonItems = [addScheduleButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSchedules(withDay: self.viewModel.selectedDay)
        self.scheduleView.updateTasks()
    }
    
    @objc private func addScheduleButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: nil, title: nil)
    }
}

extension ScheduleViewController: ScheduleDelegate {
    func onSelectTask(_ schedule: Schedule?) {
        var subjectName: String? = nil
        
        if let schedule = schedule {
            subjectName = self.viewModel.getSubjectName(fromSchedule: schedule)
        }
        
        self.coordinator?.showScheduleDetails(schedule: schedule, title: subjectName)
    }
}

extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.viewModel.fetchSchedules(withDay: self.viewModel.selectedDay)
        self.scheduleView.updateTasks()
        return nil
    }
}

#Preview {
    let coordinator = ScheduleCoordinator(navigationController: UINavigationController())
    coordinator.start()
    
    return coordinator.navigationController
}
