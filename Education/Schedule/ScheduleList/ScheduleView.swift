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
        
        stack.backgroundColor = .systemBackground
        
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
        table.separatorStyle = .none

        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let emptyView = EmptyView(object: String(localized: "emptySchedule"))
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5) // Fundo semitransparente
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var createAcitivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "createActivity"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        button.addTarget(self, action: #selector(createActivityButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var startActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "imediateActivity"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        button.addTarget(self, action: #selector(startActivityTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func createActivityButtonTapped() {
        self.delegate?.createAcitivityTapped()
    }
    
    @objc private func startActivityTapped() {
        self.delegate?.startAcitivityTapped()
    }
}

// MARK: - UI Setup
extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(picker)
        self.addSubview(contentView)
        self.addSubview(overlayView)
        overlayView.addSubview(createAcitivityButton)
        overlayView.addSubview(startActivityButton)
        
        let btnPadding = 10.0
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            createAcitivityButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            createAcitivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            createAcitivityButton.widthAnchor.constraint(equalToConstant: 160),
            createAcitivityButton.heightAnchor.constraint(equalToConstant: 40),
            
            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: btnPadding),
            startActivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            startActivityButton.widthAnchor.constraint(equalToConstant: 250),
            startActivityButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
