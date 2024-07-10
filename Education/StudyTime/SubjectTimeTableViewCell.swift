//
//  SubjectTimeTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class SubjectTimeTableViewCell: UITableViewCell{
    static let identifier = "SubjectTimeCell"
    
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            
            self.subjectName.text = subject.unwrappedName
            self.totalHours.text = String(50)
        }
    }
    
    // MARK: - UI Components
    
    lazy var subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(subjectName)
        contentView.addSubview(totalHours)
        
        NSLayoutConstraint.activate([
            subjectName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            totalHours.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            subjectName.trailingAnchor.constraint(lessThanOrEqualTo: totalHours.leadingAnchor, constant: -10)
        ])
    }
}
