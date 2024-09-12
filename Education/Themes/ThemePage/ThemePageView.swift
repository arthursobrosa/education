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
            delegate?.setSegmentedControl(self.segmentedControl)
        }
    }
    
    // MARK: - UI Components
    private let segmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl()
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    var customChart: CustomChart? {
        didSet {
            self.setupUI()
        }
    }
    
    var tableView: CustomTableView?
    
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
        guard let customChart,
              let tableView else { return }
        
        customChart.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(segmentedControl)
        self.addSubview(customChart)
        self.addSubview(tableView)
            
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            customChart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            customChart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            customChart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            customChart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 167/844),
            
            tableView.topAnchor.constraint(equalTo: customChart.bottomAnchor, constant: 26),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
