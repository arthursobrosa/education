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
                self.containerView.layer.borderColor  = UIColor(named: subject.unwrappedColor)!.cgColor
            } else {
                self.subjectName.text = String(localized: "other")
                self.colorCircle.backgroundColor = UIColor(named: "button-normal")
                self.containerView.layer.borderColor  = UIColor(named: "button-normal")!.cgColor
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
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        return label
    }()
    
    lazy var totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 15)
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
        
        self.contentView.addSubview(containerView)

        containerView.addSubview(subjectName)
        containerView.addSubview(totalHours)
        
        containerView.layer.borderWidth = 1
        
        let padding = 18.0
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            subjectName.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            
            totalHours.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            subjectName.trailingAnchor.constraint(lessThanOrEqualTo: totalHours.leadingAnchor, constant: -padding)
        ])
    }
}
