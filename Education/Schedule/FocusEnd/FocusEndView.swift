//
//  FocusEndView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class FocusEndView: UIView {
    // MARK: - Delegate to bind with VC

    weak var delegate: FocusEndDelegate?

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "finishTimerAlertTitle")
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let activityTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = .init(top: -22, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        button.addTarget(delegate, action: #selector(FocusEndDelegate.didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var discardButton: ButtonComponent = {
        let color: UIColor = UIColor(named: "FocusSettingsColor") ?? UIColor.red
        let attachmentImage = UIImage(systemName: "trash")?.applyingSymbolConfiguration(.init(pointSize: 17))?.withTintColor(color)
        let attachment = NSTextAttachment(image: attachmentImage ?? UIImage())
        let attachmentString = NSAttributedString(attachment: attachment)
        let title = String(localized: "discard") + String(repeating: " ", count: 4)
        let titleFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        let attributedString = NSAttributedString(string: title, attributes: [.font: titleFont, .foregroundColor: color])
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(attachmentString)
        mutableAttrString.append(NSAttributedString(string: "  "))
        mutableAttrString.append(attributedString)
        let button = ButtonComponent(title: "", cornerRadius: 28)
        button.setAttributedTitle(mutableAttrString, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(FocusEndDelegate.didTapDiscardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
}

// MARK: - UI Setup

extension FocusEndView: ViewCodeProtocol {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(activityTableView)
        addSubview(saveButton)
        addSubview(discardButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            activityTableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 550 / 844),
            activityTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            activityTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            activityTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),

            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 390),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 55 / 334),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: discardButton.topAnchor, constant: -11),

            discardButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            discardButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            discardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            discardButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
        ])
    }
}
