//
//  StudyTimeView.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit
import SwiftUI

class StudyTimeView: UIView {
    
    // MARK: - UI Components
    private lazy var chartView: UIHostingController<StudyTimeChartView> = {
        let hostingController = UIHostingController(rootView: StudyTimeChartView(viewModel: self.viewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    lazy var studyTimeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubjectTimeCell")
        return tableView
    }()
    
    private var viewModel: StudyTimeViewModel
    
    // MARK: - Initialization
    
    init(viewModel: StudyTimeViewModel) {
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
            
            self.studyTimeTableView.reloadData()
        }
    }
}

// MARK: - UI Setup
extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        addSubview(chartView.view)
        addSubview(studyTimeTableView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            chartView.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            chartView.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            chartView.view.widthAnchor.constraint(equalToConstant: 300),
            chartView.view.heightAnchor.constraint(equalToConstant: 300),
            
            studyTimeTableView.topAnchor.constraint(equalTo: chartView.view.bottomAnchor, constant: padding),
            studyTimeTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            studyTimeTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            studyTimeTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
        
    }
}
