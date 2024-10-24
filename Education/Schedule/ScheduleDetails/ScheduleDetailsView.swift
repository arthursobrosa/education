//
//  ScheduleDetailsView.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleDetailsView: UIView {
    // MARK: - Delegate
    weak var delegate: ScheduleDetailsDelegate?
    
    // MARK: - UI Components
    let tableView: CustomTableView = {
        let table = CustomTableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteActivity"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor.focusColorRed.cgColor
        bttn.layer.borderWidth = 2

        bttn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        
        bttn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func didTapDeleteButton() {
        self.delegate?.deleteSchedule()
    }
    
    @objc private func didTapSaveButton() {
        self.delegate?.saveSchedule()
    }
    
    func hideDeleteButton() {
        self.deleteButton.isHidden = true
    }
}

// MARK: - UI Setup
extension ScheduleDetailsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(deleteButton)
        self.addSubview(saveButton)
        
        let padding = 28.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55/334),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),
            
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
}
