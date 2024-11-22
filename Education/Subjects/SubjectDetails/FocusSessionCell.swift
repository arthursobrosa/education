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
    
    var colorName: String? {
        didSet {
            guard let colorName else { return }
            
            let borderColor = UIColor(named: colorName)?.withAlphaComponent(0.6)
            containerView.layer.borderColor = borderColor?.cgColor
            dateLabel.textColor = UIColor(named: colorName)
            commentImageView.tintColor = borderColor
            totalTimeLabel.textColor = .systemText80
        }
    }
    
    // MARK: - UI Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        return view
    }()

    private let dateLabel: UILabel = {
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

    private let totalTimeLabel: UILabel = {
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
    
    func configure(with session: FocusSession) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateLabel.text = dateFormatter.string(from: session.date ?? Date())
        totalTimeLabel.text = formatTime(from: Int(session.totalTime))
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
        containerView.addSubview(dateLabel)
        containerView.addSubview(commentImageView)
        containerView.addSubview(totalTimeLabel)

        let padding = 18.0

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            dateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            
            commentImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 26 / 344),
            commentImageView.heightAnchor.constraint(equalTo: commentImageView.widthAnchor),
            commentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            commentImageView.trailingAnchor.constraint(equalTo: totalTimeLabel.leadingAnchor, constant: -14),

            totalTimeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            totalTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
}
