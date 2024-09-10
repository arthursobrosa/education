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
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = String(localized: "subjectName")
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let toolbar = self.createToolbar(withTag: 0)
        textField.inputAccessoryView = toolbar
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: - Methods
    
    @objc func doneKeyboardButtonTapped(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            self.textField.resignFirstResponder()
        default:
            break
        }
    }
    
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
    
    private func createToolbar(withTag tag: Int) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneKeyboardButtonTapped(_:)))
        doneButton.tag = tag
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        return toolbar
    }
}
