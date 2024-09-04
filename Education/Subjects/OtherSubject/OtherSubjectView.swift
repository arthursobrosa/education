//
//  OtherSubjectView.swift
//  Education
//
//  Created by Eduardo Dalencon on 03/09/24.
//

import UIKit

class OtherSubjectView: UIView {
    
    weak var delegate: OtherSubjectDelegate?
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Este item reúne todos os tempos de estudo que você registrou sem associar a nenhuma matéria específica. Embora ele não possa ser deletado, você tem a opção de zerar os tempos de estudo vinculados a ele."
//        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var deleteButton: ButtonComponent = {
        let button = ButtonComponent(title: "Apagar tempo", textColor: UIColor(named: "redPicker")! )
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteTime), for: .touchUpInside)
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
    
    @objc private func deleteTime() {
        self.delegate?.deleteOtherSubjectTime()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(deleteButton)
        
        let padding: CGFloat = 20.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            deleteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 0.17)
        ])
    }
}
