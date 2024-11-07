//
//  FocusSessionCell.swift
//  Education
//
//  Created by Eduardo Dalencon on 06/11/24.
//

import Foundation
import UIKit

class FocusSessionCell: UITableViewCell {
    static let identifier = "focusSessionCell"
    let dateLabel = UILabel()
    let totalTimeLabel = UILabel()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor(named: "defaultColor")?.cgColor
        return view
    }()

    let subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        return label
    }()

    let totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with session: FocusSession, color: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        subjectName.text = dateFormatter.string(from: session.date ?? Date())
        subjectName.textColor = UIColor(named: color)
        
        totalHours.text = formatTime(from: Int(session.totalTime ?? 0))
        totalHours.textColor = UIColor(named: color)?.darker(by: 0.8)
        
        containerView.layer.borderColor = UIColor(named: color)?.cgColor
    }
    
     func formatTime(from time: Int) -> String {
        let hours = time / 3600
        let minutes = (time / 60) % 60

        if time >= 3600 {
            return "\(hours)h\(minutes)min"
        } else if time >= 60 {
            return "\(minutes)min"
        } else if time > 0 {
            return "\(time)s"
        } else {
            return "\(time)min"
        }
    }
}

extension FocusSessionCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(subjectName)
        containerView.addSubview(totalHours)
        containerView.layer.borderWidth = 1

        let padding = 18.0

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            subjectName.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            subjectName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding * 3),

            totalHours.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
}

