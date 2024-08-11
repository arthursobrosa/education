//
//  ThemePageView.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import UIKit
import SwiftUI

class ThemePageView: UIView {
    // MARK: - Delegate
    weak var delegate: ThemePageDelegate? {
        didSet {
            delegate?.setLimitsPicker(self.picker)
        }
    }
    
    // MARK: - UI Components
    private let picker: UISegmentedControl = {
        let picker = UISegmentedControl()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    var chartHostingController: UIHostingController<ChartView>? {
        didSet {
            chartHostingController?.view.translatesAutoresizingMaskIntoConstraints = false
            self.setupUI()
        }
    }
    
    let testsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension ThemePageView: ViewCodeProtocol {
    func setupUI() {
        guard let chartHostingController else { return }
        
        self.addSubview(picker)
        self.addSubview(chartHostingController.view)
        self.addSubview(testsTableView)
        
        let padding = 20.0
            
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            chartHostingController.view.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            chartHostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chartHostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chartHostingController.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            testsTableView.topAnchor.constraint(equalTo: chartHostingController.view.bottomAnchor, constant: padding / 2),
            testsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            testsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            testsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
