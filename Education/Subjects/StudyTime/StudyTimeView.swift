//
//  StudyTimeView.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit
import SwiftUI

class StudyTimeView: UIView {
    // MARK: - Delegate
    weak var delegate: StudyTimeDelegate? {
        didSet {
            delegate?.setSegmentedControl(self.viewModeControl)
        }
    }
    
    // MARK: - UI Components
    private let viewModeControl: UISegmentedControl = {
        let picker = UISegmentedControl()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let chartView: StudyTimeChartView
    
    lazy var chartController: UIHostingController<StudyTimeChartView> = {
        let controller = UIHostingController(rootView: self.chartView)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    let emptyView = EmptyView(message: String(localized: "emptyStudyTime"))
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Initialization
    init(chartView: StudyTimeChartView) {
        self.chartView = chartView
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(viewModeControl)
        self.addSubview(tableView)
        
        let padding = 16.0
        
        NSLayoutConstraint.activate([
            viewModeControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding / 2),
            viewModeControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding ),
            viewModeControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding ),
            
            tableView.topAnchor.constraint(equalTo: viewModeControl.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
}
