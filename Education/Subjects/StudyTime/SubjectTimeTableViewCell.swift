//
//  SubjectTimeTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class SubjectTimeTableViewCell: UITableViewCell{
    static let identifier = "subjectTimeCell"
    
    var subject: Subject? {
        didSet {
            if let subject {
                self.subjectName.text = subject.unwrappedName
                self.subjectName.textColor = UIColor(named: subject.unwrappedColor)
            } else {
                self.subjectName.text = String(localized: "other")
                self.subjectName.textColor = UIColor(named: "sealBackgroundColor")
            }
        }
    }
    
    var totalTime: String? {
        didSet {
            guard let totalTime else { return }
            
            self.totalHours.text = totalTime
        }
    }
    
    // MARK: - UI Components
    private lazy var subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.backgroundColor = .systemGray3
        }
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(subjectName)
        self.contentView.addSubview(totalHours)
        
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            subjectName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            totalHours.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            subjectName.trailingAnchor.constraint(lessThanOrEqualTo: totalHours.leadingAnchor, constant: -padding)
        ])
    }
}
