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
            delegate?.setPicker(self.picker)
        }
    }
    
    // MARK: - UI Components
    private let picker: UISegmentedControl = {
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
    
    var emptyView = EmptyView(object: String(localized: "emptyStudyTime"))
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
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
    
    func changeEmptyView(emptySubject: Bool) {
        let object = emptySubject ? String(localized: "emptySubject") : String(localized: "emptyStudyTime")
        
        self.emptyView = EmptyView(object: object)
    }
}

// MARK: - UI Setup
extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(picker)
        self.addSubview(contentView)
        self.addSubview(tableView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding / 2),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding / 2),
            
            contentView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            contentView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -padding),
            
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.27),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
    
    
}
