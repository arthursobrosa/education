//
//  SubjectListView.swift
//  Education
//
//  Created by Leandro Silva on 19/08/24.
//

import UIKit

class SubjectListView: UIView {
    
    // MARK: - UI Components
    
    var emptyView: UILabel = {
        let emptyView = UILabel()
        emptyView.text = String(localized: "emptyCreateSubject")
        emptyView.textColor = .secondaryLabel
        return emptyView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let largeBoldPlus = UIImage(systemName: "plus", withConfiguration: largeConfig)
        button.setImage(largeBoldPlus, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }
}

// MARK: - UI Setup

extension SubjectListView: ViewCodeProtocol {
    func setupUI() {
        
        addSubview(tableView)
        addSubview(addButton)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
