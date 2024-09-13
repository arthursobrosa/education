//
//  TestPageView.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import UIKit

class TestPageView: UIView {
    // MARK: - Delegate
    weak var delegate: TestDelegate?
    
    // MARK: - UI Components
    let tableView: CustomTableView = {
        let table = CustomTableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteTest"), textColor: UIColor(named: "FocusSettingsColor"))
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        bttn.layer.borderWidth = 2

        bttn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"))
        
        bttn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Initialization
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
        self.delegate?.didTapDeleteButton()
    }
    
    @objc private func didTapSaveButton() {
        self.delegate?.didTapSaveButton()
    }
    
    func hideDeleteButton() {
        self.deleteButton.isHidden = true
    }
}

// MARK: - UI Setup
extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(deleteButton)
        self.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 55/770),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),
            
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
