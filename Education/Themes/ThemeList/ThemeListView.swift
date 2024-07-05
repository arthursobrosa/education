//
//  ThemeListView.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import Foundation
import UIKit

class ThemeListView: UIView {
    
    // MARK: - UI Components
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    let addThemeButton = ButtonComponent(frame: .zero, title: "Add New Theme")
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reload table
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UI Setup

extension ThemeListView: ViewCodeProtocol {
    func setupUI() {
        
        addSubview(tableView)
        addSubview(addThemeButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addThemeButton.topAnchor, constant: -padding),
            
            addThemeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addThemeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            addThemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            addThemeButton.heightAnchor.constraint(equalTo: addThemeButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
