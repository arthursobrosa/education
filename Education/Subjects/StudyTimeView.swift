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
    
    var chartHostingController: UIHostingController<StudyTimeChartView>? {
        didSet {
            chartHostingController?.view.translatesAutoresizingMaskIntoConstraints = false
            self.setupUI()
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        guard let chartHostingController = self.chartHostingController else { return }
        
        self.addSubview(picker)
        self.addSubview(chartHostingController.view)
        self.addSubview(tableView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding / 2),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding / 2),
            
            chartHostingController.view.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            chartHostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chartHostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            tableView.topAnchor.constraint(equalTo: chartHostingController.view.bottomAnchor, constant: padding / 2),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
}
