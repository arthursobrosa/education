//
//  OtherSubjectView.swift
//  Education
//
//  Created by Eduardo Dalencon on 03/09/24.
//

import UIKit

class OtherSubjectView: UIView {
    weak var delegate: OtherSubjectDelegate?

    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "deleteOtherBodyText")
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteOther"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 27)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        bttn.layer.borderWidth = 1

        bttn.addTarget(self, action: #selector(deleteTime), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc 
    private func deleteTime() {
        delegate?.deleteOtherSubjectTime()
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(deleteButton)

        let padding: CGFloat = 20.0

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55 / 334),
            deleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }
}
