//
//  DailyScheduleView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class DailyScheduleView: UIView {
    // MARK: - UI Properties

    let daysStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 19
        stack.backgroundColor = .systemBackground
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension DailyScheduleView: ViewCodeProtocol {
    func setupUI() {
        addSubview(daysStack)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            daysStack.topAnchor.constraint(equalTo: topAnchor),
            daysStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daysStack.heightAnchor.constraint(equalTo: daysStack.widthAnchor, multiplier: 35 / 355),

            contentView.topAnchor.constraint(equalTo: daysStack.bottomAnchor, constant: 18),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
