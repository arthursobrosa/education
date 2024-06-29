//
//  ThemePageView.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation
import UIKit

class ThemePageView: UIView {
    
    // MARK: - UI Components
     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Theme"
        return label
    }()
    
    lazy var placeholderView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .lightGray // Adjust color as needed
            return view
        }()
    
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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
            
            addSubview(titleLabel)
            addSubview(placeholderView)
            addSubview(tableView)
            addSubview(addThemeButton)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                placeholderView.heightAnchor.constraint(equalToConstant: 200), // Adjust height as needed
                
                tableView.topAnchor.constraint(equalTo: placeholderView.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: addThemeButton.topAnchor, constant: -20),
                
                addThemeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                addThemeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                addThemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
    
    
    // MARK: - Button Action
    func addAction(for target: Any?, action: Selector, event: UIControl.Event) {
        addThemeButton.addTarget(target, action: action, for: event)
    }
    
    // MARK: - Table View Setup
    func setTableViewDataSourceDelegate<D: UITableViewDataSource & UITableViewDelegate>(_ dataSourceDelegate: D, forRowHeight height: CGFloat) {
        tableView.rowHeight = height
        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
        tableView.reloadData()
    }
}

