//
//  InputTextTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class InputTextTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "inputTextCell"

    weak var delegate: SubjectCreationDelegate? {
        didSet {
            setupUI()
        }
    }

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

extension InputTextTableViewCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterLimit = 18
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= characterLimit
    }

    func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            delegate?.textFieldDidChange(newText: text)
            if spaceRemover(string: text).isEmpty {
                textField.resignFirstResponder()
            }
        }

        return true
    }
}
