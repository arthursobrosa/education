//
//  ScheduleTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    // MARK: - ID
    static let identifier = "scheduleCell"
    
    // MARK: - Properties
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            
            self.subjectNameLabel.text = subject.unwrappedName
        }
    }
    
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else { return }
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            self.timeLabel.text = "\(formatter.string(from: schedule.unwrappedStartTime)) - \(formatter.string(from: schedule.unwrappedEndTime))"
            self.timeLabel.textColor = .white
        }
    }
    
    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            
            self.cardView.backgroundColor = color
        }
    }
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension ScheduleTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(cardView)
        cardView.addSubview(subjectNameLabel)
        cardView.addSubview(timeLabel)
        
        let padding = 8.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding),
            subjectNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding),
            
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: (padding / 2)),
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding)
        ])
        
        cardView.layer.cornerRadius = 8
    }
}
