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
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Fundo semitransparente
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0 // Inicialmente invisível
        return view
    }()
    
    let btnCreateActivity: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar atividade", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.titleLabel?.textColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // Inicialmente invisível
        return button
    }()
    
    lazy var btnStartActivity: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Iniciar atividade imediata", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.titleLabel?.textColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // Inicialmente invisível
        
        button.addTarget(self, action: #selector(startActivityTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var currentActivityView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func startActivityTapped() {
        self.delegate?.startAcitivityTapped()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.currentActivityView.layer.cornerRadius = self.currentActivityView.bounds.height / 6
        self.currentActivityView.layer.borderColor = UIColor.label.cgColor
        self.currentActivityView.layer.borderWidth = 1
    }
}

// MARK: - UI Setup
extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(picker)
        self.addSubview(contentView)
        self.addSubview(overlayView)
        overlayView.addSubview(btnCreateActivity)
        overlayView.addSubview(btnStartActivity)
        
        let btnPadding = 10.0
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            btnCreateActivity.topAnchor.constraint(equalTo: overlayView.topAnchor),
            btnCreateActivity.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            btnCreateActivity.widthAnchor.constraint(equalToConstant: 160),
            btnCreateActivity.heightAnchor.constraint(equalToConstant: 40),
            
            btnStartActivity.topAnchor.constraint(equalTo: btnCreateActivity.bottomAnchor, constant: btnPadding),
            btnStartActivity.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            btnStartActivity.widthAnchor.constraint(equalToConstant: 250),
            btnStartActivity.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setCurrentActivity(withColor color: UIColor?) {
        self.currentActivityView.backgroundColor = color
        
        self.setCurrentActivityUI()
    }
    
    private func setCurrentActivityUI() {
        self.addSubview(currentActivityView)
        
        NSLayoutConstraint.activate([
            currentActivityView.widthAnchor.constraint(equalTo: self.widthAnchor),
            currentActivityView.heightAnchor.constraint(equalTo: currentActivityView.widthAnchor, multiplier: (155/390)),
            currentActivityView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentActivityView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func removeCurrentActivity() {
        self.currentActivityView.removeFromSuperview()
    }
}
