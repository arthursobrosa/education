//
//  FocusSessionCell.swift
//  Education
//
//  Created by Eduardo Dalencon on 06/11/24.
//

import Foundation
import UIKit

class FocusSessionCell: UITableViewCell {
    // MARK: - ID
    
    static let identifier = "focusSessionCell"
    
    // MARK: - Properties
    
    var hasNotes: Bool = false {
        didSet {
            commentImageView.isHidden = !hasNotes
        }
    }
    
    // MARK: - UI Properties
    
    let dateLabel = UILabel()
    let totalTimeLabel = UILabel()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        return view
    }()

    private let subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "text.bubble")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26))
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 15)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with session: FocusSession, color: String) {
        containerView.layer.borderColor = UIColor(named: color)?.cgColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        subjectName.text = dateFormatter.string(from: session.date ?? Date())
        subjectName.textColor = UIColor(named: color)
        
        commentImageView.tintColor = UIColor(named: color)
        
        totalHours.text = formatTime(from: Int(session.totalTime))
        totalHours.textColor = UIColor(named: color)?.darker(by: 0.8)
    }
    
     private func formatTime(from time: Int) -> String {
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

// MARK: - UI Setup

extension FocusSessionCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(subjectName)
        containerView.addSubview(commentImageView)
        containerView.addSubview(totalHours)

        let padding = 18.0

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            subjectName.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            subjectName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            
            commentImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 26 / 344),
            commentImageView.heightAnchor.constraint(equalTo: commentImageView.widthAnchor),
            commentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            commentImageView.trailingAnchor.constraint(equalTo: totalHours.leadingAnchor, constant: -14),

            totalHours.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalHours.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
}
