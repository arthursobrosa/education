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
    let segmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 13)!
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnRegular, size: 13)!
        ]
        control.setTitleTextAttributes(titleAttributesUnselected, for: .normal)
        control.setTitleTextAttributes(titleAttributes, for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    var customChart: CustomChart? {
        didSet {
            self.setupUI()
        }
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dayLabel = UILabel()
        dayLabel.text = String(localized: "dayLabel")
        dayLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        dayLabel.textColor = .systemText50
        
        let questionsLabel = UILabel()
        questionsLabel.text = String(localized: "questionLabel")
        questionsLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        questionsLabel.textColor = .systemText50
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(questionsLabel)
        
        return stackView
    }()
    
    var tableView: CustomTableView?
    
    let emptyView: NoThemesView = {
        let view = NoThemesView()
        view.noThemesCase = .test
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        guard let customChart,
              let tableView else { return }
        
        customChart.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(segmentedControl)
        self.addSubview(customChart)
        self.addSubview(tableView)
        self.addSubview(stackView)
            
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            customChart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            customChart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            customChart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            customChart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 200/844),
            
            stackView.topAnchor.constraint(equalTo: customChart.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
