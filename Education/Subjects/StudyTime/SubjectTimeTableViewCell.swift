//
//  SubjectTimeTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class SubjectTimeTableViewCell: UITableViewCell {
    static let identifier = "subjectTimeCell"

    var subject: Subject? {
        didSet {
            if let subject {
                subjectName.text = subject.unwrappedName
                colorCircle.backgroundColor = UIColor(named: subject.unwrappedColor)
                containerView.layer.borderColor = UIColor(named: subject.unwrappedColor)!.cgColor
            } else {
                subjectName.text = String(localized: "other")
                colorCircle.backgroundColor = UIColor(named: "button-normal")
                containerView.layer.borderColor = UIColor(named: "button-normal")!.cgColor
            }
        }
    }

    var totalTime: String? {
        didSet {
            guard let totalTime else { return }

            totalHours.text = totalTime
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

    let subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        return label
    }()

    let totalHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 15)
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemGray6

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SubjectTimeTableViewCell: ViewCodeProtocol {
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
