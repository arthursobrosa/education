//
//  SubjectCreationView.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationView: UIView {
    // MARK: - UI Components
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemBackground
        
        table.translatesAutoresizingMaskIntoConstraints = false
       
        return table
    }()
    
     let button: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"))
        button.translatesAutoresizingMaskIntoConstraints = false
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
}

extension SubjectCreationView: ViewCodeProtocol {
    // MARK: - UI Setup
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(button)
//        tableView.backgroundColor = .red

        NSLayoutConstraint.activate([
            
//            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 5/28),
//            button.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
        ])
    }
}
