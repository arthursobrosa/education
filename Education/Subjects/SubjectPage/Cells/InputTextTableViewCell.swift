//
//  InputTextTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {
    static let identifier = "inputTextCell"
    
    weak var delegate: SubjectCreationDelegate? {
        didSet {
            self.setupUI()
        }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = String(localized: "subject")
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    @objc private func textFieldDidChange() {
        guard let text = self.textField.text else { return }
        
        self.delegate?.textFieldDidChange(newText: text)
    }
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
}
