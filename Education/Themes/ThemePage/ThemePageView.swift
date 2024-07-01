//
//  ThemePageView.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation
import UIKit
import SwiftUI

class ThemePageView: UIView {
    
    // MARK: - UI Components
     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Theme"
        return label
    }()
    
    lazy var chartView: UIHostingController<ChartView> = {
        let hostingController = UIHostingController(rootView: ChartView(vm: self.chartViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
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
    
    private let chartViewModel: ChartViewModel
    
    // MARK: - Initialization
    init( themeId: String) {
        self.chartViewModel = ChartViewModel(themeId: themeId)
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
            
            addSubview(titleLabel)
            addSubview(chartView.view)
            addSubview(tableView)
            addSubview(addThemeButton)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                chartView.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                chartView.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                chartView.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                chartView.view.heightAnchor.constraint(equalToConstant: 200),
                
                tableView.topAnchor.constraint(equalTo: chartView.view.bottomAnchor, constant: 20),
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

