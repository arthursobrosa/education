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
    
    private lazy var scheduleNotificationView: ScheduleNotificationView = {
        let startTime = self.viewModel.getTimeString(isStartTime: true)
        let endTime = self.viewModel.getTimeString(isStartTime: false)
        let subjectName = self.viewModel.subject.unwrappedName
        let colorName = self.viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        let dayOfWeek = self.viewModel.getDayOfWeek()
        
        let view = ScheduleNotificationView(startTime: startTime, endTime: endTime, color: color, subjectName: subjectName, dayOfWeek: dayOfWeek)
        
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
        
        if(self.traitCollection.userInterfaceStyle == .light){
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.scheduleNotificationView.layer.borderColor = UIColor.label.cgColor
            
            if(self.traitCollection.userInterfaceStyle == .light){
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }
        
        self.setGestureRecognizer()
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        guard !self.scheduleNotificationView.frame.contains(tapLocation) else { return }
        
        self.coordinator?.dismiss(animated: true)
    }
}

extension ScheduleNotificationViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(scheduleNotificationView)
        
        NSLayoutConstraint.activate([
            scheduleNotificationView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 471/844),
            scheduleNotificationView.widthAnchor.constraint(equalTo: scheduleNotificationView.heightAnchor, multiplier: 366/471),
            scheduleNotificationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scheduleNotificationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
