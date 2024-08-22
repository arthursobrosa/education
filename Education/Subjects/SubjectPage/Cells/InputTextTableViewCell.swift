//
//  InputTextTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class InputTextTableViewCell: UITableViewCell {

    static let identifier = "inputTextCell"
    
    // Cria o UITextField
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.placeholder = String(localized: "subject")
        return textField
    }()
    
    // Closure para notificar mudanças
    var onTextChanged: ((String) -> Void)?
    
    // Método de inicialização
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupTextField()
    }
    
    // Configura a célula e adiciona o UITextField
    private func setupViews() {
        contentView.addSubview(textField)
        
        // Configura as constraints do UITextField
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Configura o UITextField para notificar mudanças de texto
    private func setupTextField() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        if let text = textField.text {
            onTextChanged?(text)
        }
    }
}
