//
//  SubjectCreationView.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationView: UIView {
    
    // MARK: - UI Components
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(localized: "addSubjectName")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemBackground
        return collectionView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "saveSubject"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SubjectCreationView: ViewCodeProtocol {
    
    // MARK: - UI Setup
    func setupUI() {
        // Configuração básica da view
        backgroundColor = UIColor.systemBackground
        
        // Adicionando os elementos de UI na view
        addSubview(nameTextField)
        addSubview(collectionView)
        addSubview(saveButton)
        
        // Constraints para o nome do subject (UITextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // Constraints para a CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Constraints para o botão de salvar
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
