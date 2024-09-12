//
//  ScheduleDetailsModalViewController.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class ScheduleDetailsModalViewController: UIViewController {
    weak var coordinator: (ShowingFocusSelection & Dismissing & ShowingScheduleDetails)?
    let viewModel: ScheduleDetailsModalViewModel
    
    var color: UIColor?
    
    private lazy var scheduleModalView: ScheduleDetailsModalView = {
        let startTime = self.viewModel.getTimeString(isStartTime: true)
        let endTime = self.viewModel.getTimeString(isStartTime: false)
        
        let view = ScheduleDetailsModalView(startTime: startTime, endTime: endTime, color: self.color, subjectName: self.viewModel.subject.unwrappedName, dayOfTheWeek: self.viewModel.getDayOfWeek())
        view.delegate = self
        
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: ScheduleDetailsModalViewModel) {
        self.viewModel = viewModel
        
        let colorName = self.viewModel.subject.unwrappedColor
        self.color = UIColor(named: colorName)
        
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
            
            self.scheduleModalView.layer.borderColor = UIColor.label.cgColor
            
            if(self.traitCollection.userInterfaceStyle == .light){
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }
    }
}

extension ScheduleDetailsModalViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(scheduleModalView)
        
        NSLayoutConstraint.activate([
            scheduleModalView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 336/844),
            scheduleModalView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 360/390),
            scheduleModalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scheduleModalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
