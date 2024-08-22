//
//  EmptyListSubjectsView.swift
//  Education
//
//  Created by Leandro Silva on 22/08/24.
//

import UIKit

class EmptyListSubjectsView: UIView {
    // MARK: - Delegate
    weak var delegate: SubjectListDelegate?
    
    // MARK: - UI Components
    private lazy var createSubjectLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "emptyCreateSubject")
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let largeBoldPlus = UIImage(systemName: "plus", withConfiguration: largeConfig)
        button.setImage(largeBoldPlus, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    @objc private func addButtonTapped() {
        self.delegate?.addButtonTapped()
    }
}

// MARK: - UI Setup
extension EmptyListSubjectsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(createSubjectLabel)
        self.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            createSubjectLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            createSubjectLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.topAnchor.constraint(equalTo: createSubjectLabel.bottomAnchor, constant: 18),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

