//
//  TaskCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 20/08/24.
//

import UIKit

class TaskCell: UICollectionViewCell {
    static let identifier = "taskCell"
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(subjectLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeLabel2)
        
        NSLayoutConstraint.activate([
            subjectLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 3),
            
            timeLabel2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel2.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0),
            timeLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with subject: String, startTime: String, endTime: String, bgColor: String) {
        subjectLabel.text = subject
        timeLabel.text = startTime
        timeLabel2.text = endTime
        contentView.backgroundColor = UIColor(named: bgColor)
    }
}

class EmptyCell: UICollectionViewCell {
    static let identifier = "emptyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
