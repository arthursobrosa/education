//
//  FocusSessionSettingsView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionSettingsView: UIView {
    // MARK: - Delegate
    weak var delegate: FocusSessionSettingsDelegate?
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemBackground
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var startButton: ButtonComponent = {
        let bttn = ButtonComponent(title: "Start")
        bttn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return bttn
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func startButtonTapped() {
        self.delegate?.startButtonTapped()
    }
}

// MARK: - UI Setup
extension FocusSessionSettingsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -padding),
            
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            startButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
