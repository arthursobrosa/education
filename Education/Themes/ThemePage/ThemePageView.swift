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
    private lazy var chartView: UIHostingController<ChartView> = {
        let hostingController = UIHostingController(rootView: ChartView(viewModel: self.viewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    lazy var testsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        return tableView
    }()
    
    let addTestButton = ButtonComponent(frame: .zero, title: "Add Test")
    
    private var viewModel: ThemePageViewModel
    
    // MARK: - Initialization
        
    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reload Table
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.testsTableView.reloadData()
        }
    }
}

// MARK: - UI Setup
extension ThemePageView: ViewCodeProtocol {
    func setupUI() {

        addSubview(chartView.view)
        addSubview(testsTableView)
        addSubview(addTestButton)
        
        let padding = 20.0
            
        NSLayoutConstraint.activate([
            chartView.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            chartView.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            chartView.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            chartView.view.heightAnchor.constraint(equalToConstant: 200),
            
            testsTableView.topAnchor.constraint(equalTo: chartView.view.bottomAnchor, constant: padding),
            testsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            testsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            testsTableView.bottomAnchor.constraint(equalTo: addTestButton.topAnchor, constant: -padding),
            
            addTestButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addTestButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            addTestButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            addTestButton.heightAnchor.constraint(equalTo: addTestButton.widthAnchor, multiplier: 0.16)
        ])
    }
}

