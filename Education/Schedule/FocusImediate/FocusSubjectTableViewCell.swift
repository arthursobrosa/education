//
//  FocusSubjectTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusSubjectTableViewCell: UITableViewCell {
    // MARK: - Cell identifier

    static let identifier = "focusSubjectCell"

    // MARK: - Delegate to connect to FocusImediateView

    weak var delegate: FocusImediateDelegate?

    // MARK: - Properties

    var indexPath: IndexPath?

    var subject: Subject? {
        didSet {
            if let subject {
                let formattedSubjectName = formattedText(subject.unwrappedName)
                subjectButton.setTitle(formattedSubjectName, for: .normal)
                
                let titleColor = UIColor(named: subject.unwrappedColor)?.darker(by: 0.8)
                subjectButton.setTitleColor(titleColor, for: .normal)
                
                let borderColor = UIColor(named: subject.unwrappedColor)?.withAlphaComponent(0.6)
                subjectButton.layer.borderColor = borderColor?.cgColor
                
                return
            }

            subjectButton.setTitle(String(localized: "none"), for: .normal)
            subjectButton.setTitleColor(.systemText80, for: .normal)
            subjectButton.layer.borderColor = UIColor.buttonNormal.cgColor
        }
    }

    // MARK: - UI Properties

    private lazy var subjectButton: UIButton = {
        let bttn = UIButton()
        bttn.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        bttn.titleLabel?.textAlignment = .center
        bttn.layer.cornerRadius = 30
        bttn.backgroundColor = .clear
        bttn.layer.borderWidth = 1
        bttn.addTarget(self, action: #selector(subjectButtonTapped), for: .touchUpInside)
        bttn.translatesAutoresizingMaskIntoConstraints = false
        return bttn
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    @objc 
    private func subjectButtonTapped() {
        delegate?.subjectButtonTapped(indexPath: indexPath)
    }

    private func formattedText(_ text: String) -> String {
        var formattedText = text
        let maxLength = 25

        if text.count > maxLength {
            formattedText = String(text.prefix(maxLength)) + "..."
        }

        return formattedText
    }
}

// MARK: - UI Setup

extension FocusSubjectTableViewCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(subjectButton)

        NSLayoutConstraint.activate([
            subjectButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subjectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
