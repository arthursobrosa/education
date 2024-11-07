//
//  InputTextTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {
    // MARK: - ID
    static let identifier = "inputTextCell"

    // MARK: - Delegate to connect to subject creation
    weak var delegate: SubjectCreationDelegate? {
        didSet {
            setupUI()
        }
    }

    // MARK: - UI Properties
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = UIColor(named: "system-text")

        let placeholderText = String(localized: "subjectName")
        let placeholderFont = UIFont(name: Fonts.darkModeOnItalic, size: 16)
        let placeholderColor = UIColor(named: "system-text-40")

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
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: - TextField Delegate
extension InputTextTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterLimit = 18
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= characterLimit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.textFieldDidChange(newText: text)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
