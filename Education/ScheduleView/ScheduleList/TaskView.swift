//
//  TaskView.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation
import UIKit

class TaskView: UIView {
    
    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 18.0)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else { return }
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            timeLabel.text = "\(formatter.string(from: schedule.unwrappedStartTime)) - \(formatter.string(from: schedule.unwrappedEndTime))"
            timeLabel.textColor = .white
        }
    }
    
    init(subjectName: String, bgColor: UIColor) {
        super.init(frame: .zero)
        
        self.subjectNameLabel.text = subjectName
        setupView()

        self.backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(subjectNameLabel)
        addSubview(timeLabel)
        
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

