//
//  TaskView.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation
import UIKit

class TaskView: UIView {
    
    private let subjectNameLabel = UILabel()
    private let timeLabel = UILabel()
    
    init(task: ScheduleTask, bgColor: UIColor) {
        super.init(frame: .zero)
        
        setupView()
        
        subjectNameLabel.text = task.subjectName
        subjectNameLabel.textColor = .white
        subjectNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = "\(formatter.string(from: task.startTime)) - \(formatter.string(from: task.endTime))"
        timeLabel.textColor = .white
        self.backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(subjectNameLabel)
        addSubview(timeLabel)
        
        subjectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subjectNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            subjectNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            subjectNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        layer.cornerRadius = 8
    }
}

