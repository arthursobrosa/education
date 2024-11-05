//
//  ScheduleDetailsView.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleDetailsView: UIView {
    // MARK: - Delegate

    weak var delegate: ScheduleDetailsDelegate?

    // MARK: - UI Components

    let tableView: BorderedTableView = {
        let tableView = BorderedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteActivity"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor.focusColorRed.cgColor
        bttn.layer.borderWidth = 2

        bttn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)

        bttn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    @objc 
    private func didTapDeleteButton() {
        delegate?.deleteSchedule()
    }

    @objc 
    private func didTapSaveButton() {
        delegate?.saveSchedule()
    }

    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
}

// MARK: - UI Setup

extension ScheduleDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(tableView)
        addSubview(deleteButton)
        addSubview(saveButton)

        let padding = 28.0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55 / 334),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),

            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
}
