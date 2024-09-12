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
    
    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"))
        
        bttn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
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
    @objc private func saveButtonTapped() {
        self.delegate?.saveButtonTapped()
    }
}

// MARK: - UI Setup
extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            saveButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 55/770),
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
