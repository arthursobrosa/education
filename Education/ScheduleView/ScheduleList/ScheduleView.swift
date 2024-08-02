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
    
    let btnStartActivity: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Iniciar atividade imediata", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.titleLabel?.textColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0 // Inicialmente invisível
        return button
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
        self.addSubview(overlayView)
        overlayView.addSubview(btnCreateActivity)
        overlayView.addSubview(btnStartActivity)
        
        let padding = 20.0
        let btnPadind = 10.0
        
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
            btnCreateActivity.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadind),
            btnCreateActivity.widthAnchor.constraint(equalToConstant: 160),
            btnCreateActivity.heightAnchor.constraint(equalToConstant: 40),
            
            btnStartActivity.topAnchor.constraint(equalTo: btnCreateActivity.bottomAnchor, constant: btnPadind),
            btnStartActivity.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadind),
            btnStartActivity.widthAnchor.constraint(equalToConstant: 250),
            btnStartActivity.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
