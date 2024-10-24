//
//  SubjectCreationView.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationView: UIView {
    weak var delegate: SubjectCreationDelegate?
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemBackground
        
        table.translatesAutoresizingMaskIntoConstraints = false
       
        return table
    }()
    
    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteSubjectTitle"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 27)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor(named: "focus-color-red")?.cgColor
        bttn.layer.borderWidth = 1

        bttn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 27)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "button-off")
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func didTapDeleteButton() {
        self.delegate?.didTapDeleteButton()
    }
    
    @objc private func didTapSaveButton() {
        self.delegate?.didTapSaveButton()
    }
    
    func hideDeleteButton() {
        self.deleteButton.isHidden = true
    }
}

// MARK: - UI Setup
extension SubjectCreationView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(deleteButton)
        self.addSubview(saveButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),
            
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55/334),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -11),
            
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
        ])
    }
}
