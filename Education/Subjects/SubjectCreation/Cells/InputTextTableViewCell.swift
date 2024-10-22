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
            self.setupUI()
        }
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        
        let placeholderText = String(localized: "subjectName")
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: Fonts.darkModeOnItalic, size: 15) ?? UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.gray
        ]

        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
}

extension InputTextTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterLimit = 18
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= characterLimit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
        }
    }
    
    func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            delegate?.textFieldDidChange(newText: text)
            if spaceRemover(string: text) != ""{
                textField.resignFirstResponder()
            }
        }

        return true
    }
}
