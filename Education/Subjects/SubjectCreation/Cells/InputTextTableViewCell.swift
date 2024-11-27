//
//  InputTextTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {
    // MARK: - Identifier
    
    static let identifier = "inputTextCell"

    // MARK: - Delegate to connect to subject creation
    
    weak var delegate: SubjectCreationDelegate? {
        didSet {
            setupUI()
        }
    }

    // MARK: - UI Properties
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "name")
        label.textColor = .systemText80
        label.font = .init(name: Fonts.darkModeOnMedium, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.backgroundColor = .clear
        textField.textColor = .systemText50
        textField.font = .init(name: Fonts.darkModeOnMedium, size: 16)

        let placeholderText = String(localized: "subjectName")
        let placeholderFont = UIFont(name: Fonts.darkModeOnItalic, size: 16)
        let placeholderColor: UIColor = .systemText40

        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: placeholderColor as Any,
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()
}

// MARK: - UI Setup

extension InputTextTableViewCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            
            textField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 60),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - TextField Delegate

extension InputTextTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let cleanName = spaceRemover(string: text)
        
        if cleanName.isEmpty {
            textField.text = String()
        }
        
        delegate?.textFieldDidChange(newText: cleanName)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    private func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
}
