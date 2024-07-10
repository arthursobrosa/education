//
//  FocusSessionSettingsView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionSettingsView: UIView {
    // MARK: - Properties
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    let startButton = ButtonComponent(frame: .zero, title: "Start")
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension FocusSessionSettingsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -padding),
            
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            startButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
