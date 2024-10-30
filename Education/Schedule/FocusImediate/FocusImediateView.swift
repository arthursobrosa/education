//
//  FocusImediateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateView: UIView {
    weak var delegate: FocusImediateDelegate?

    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = String(localized: "cancel")
        configuration.baseForegroundColor = .secondaryLabel
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
            return outgoing
        }

        let bttn = UIButton(configuration: configuration)
        bttn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "imediateActivity")

        return label
    }()

    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.text = String(localized: "subjectAttributionQuestion")

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var subjectsTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = self.backgroundColor

        table.translatesAutoresizingMaskIntoConstraints = false

        return table
    }()

    init(color: UIColor?) {
        super.init(frame: .zero)

        backgroundColor = color
        layer.cornerRadius = 12

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc 
    private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
}

extension FocusImediateView: ViewCodeProtocol {
    func setupUI() {
        addSubview(cancelButton)
        addSubview(topLabel)
        addSubview(titleLabel)
        addSubview(subjectsTableView)

        let padding = 20.0

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding / 2),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),

            topLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: padding / 2),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 296 / 359),

            subjectsTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding),
            subjectsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subjectsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subjectsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
}
