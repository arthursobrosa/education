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
                self.colorCircle.backgroundColor = UIColor(named: subject.unwrappedColor)
            } else {
                self.subjectName.text = String(localized: "other")
                self.colorCircle.backgroundColor = UIColor(named: "sealBackgroundColor")
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
    private let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
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
        
        self.setupUI()
        
        self.backgroundColor = .systemGray6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(colorCircle)
        self.contentView.addSubview(subjectName)
        self.contentView.addSubview(totalHours)
        
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            colorCircle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            colorCircle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: 25),
            colorCircle.heightAnchor.constraint(equalToConstant: 25),
            
            subjectName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: padding),
            
            totalHours.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            subjectName.trailingAnchor.constraint(lessThanOrEqualTo: totalHours.leadingAnchor, constant: -padding)
        ])
    }
}
