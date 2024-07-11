//
//  ScheduleCreationView.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleCreationView: UIView {
    weak var delegate: ScheduleCreationDelegate?
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(frame: .zero, title: "Save")
        bttn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return bttn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSaveButton() {
        self.delegate?.dismissVC()
    }
}

extension ScheduleCreationView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(saveButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding),
            
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
