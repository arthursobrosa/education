//
//  ThemeListView.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import UIKit

class ThemeListView: UIView {
    // MARK: - Delegate
    weak var delegate: ThemeDelegate?
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addThemeButton: ButtonComponent = {
        let bttn = ButtonComponent(title: "Add New Theme")
        bttn.addTarget(self, action: #selector(addThemeButtonTapped), for: .touchUpInside)
        return bttn
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
    @objc private func addThemeButtonTapped() {
        self.delegate?.addTheme()
    }
}

// MARK: - UI Setup
extension ThemeListView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(addThemeButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addThemeButton.topAnchor, constant: -padding),
            
            addThemeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            addThemeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            addThemeButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            addThemeButton.heightAnchor.constraint(equalTo: addThemeButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
