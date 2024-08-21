//
//  SubjectCreationView.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationView: UIView {
    

    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
       
//        table.backgroundColor = .red
        return table
    }()
    
    // MARK: - UI Components
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Insira o nome do subject"
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
        button.setTitle("Salvar Subject", for: .normal)
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
        
        if self.traitCollection.userInterfaceStyle == .light {
            tableView.backgroundColor = .white
        }
        
        // Adicionando os elementos de UI na view
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        

    }
}





