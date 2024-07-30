//
//  ScheduleView.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleView: UIView {
    // MARK: - Delegate
    weak var delegate: ScheduleDelegate? {
        didSet {
            delegate?.setPicker(self.picker)
        }
    }
    
    // MARK: - UI Components
    let picker: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 4
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()

        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let emptyView = EmptyView(object: String(localized: "emptySchedule"))
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(picker)
        self.addSubview(contentView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
}
