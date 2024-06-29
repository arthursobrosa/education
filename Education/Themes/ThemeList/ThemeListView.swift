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
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    lazy var addThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Item", for: .normal)
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
    
    // MARK: - Reload table
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        addSubview(tableView)
        addSubview(addThemeButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addThemeButton.topAnchor, constant: -20),
            
            addThemeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addThemeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addThemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
