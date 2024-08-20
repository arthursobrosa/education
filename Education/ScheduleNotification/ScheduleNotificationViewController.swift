//
//  ScheduleNotificationViewController.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationViewController: UIViewController {
    private let color: UIColor?
    weak var coordinator: (ShowingFocusSelection & Dismissing)?
    let viewModel: ScheduleNotificationViewModel
    
    private lazy var scheduleModalView: ScheduleNotificationView = {
        
        let colorName = self.viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        let startTime = self.viewModel.getTimeString(isStartTime: true)
        let endTime = self.viewModel.getTimeString(isStartTime: false)
        
        let view = ScheduleNotificationView(startTime: startTime, endTime: endTime, color: color, subjectName: self.viewModel.subject.unwrappedName)
        
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(color: UIColor?, viewModel: ScheduleNotificationViewModel) {
        self.color = color
        self.viewModel = viewModel
        
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

extension ScheduleNotificationViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(scheduleModalView)
        
        NSLayoutConstraint.activate([
            scheduleModalView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 588/844),
            scheduleModalView.widthAnchor.constraint(equalTo: scheduleModalView.heightAnchor, multiplier: 359/588),
            scheduleModalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scheduleModalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

#Preview{
    ScheduleNotificationViewController(color: UIColor(named: "ScheduleColor1"), viewModel: ScheduleNotificationViewModel(schedule: Schedule()))
}
