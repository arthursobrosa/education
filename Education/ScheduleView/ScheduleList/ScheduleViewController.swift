//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleViewController: UIViewController {
    weak var coordinator: ShowingScheduleCreation?
    private let viewModel: ScheduleViewModel
    
    private lazy var scheduleView = ScheduleView(viewModel: self.viewModel)
    
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
    
    @objc private func addScheduleButtonTapped() {
        self.coordinator?.showScheduleCreation()
    }
}

#Preview {
    let coordinator = ScheduleCoordinator(navigationController: UINavigationController())
    coordinator.start()
    
    return coordinator.navigationController
}
