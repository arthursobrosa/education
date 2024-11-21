//
//  OnboardingSubjectCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import UIKit

class OnboardingSubjectCell: UITableViewCell {
    // MARK: - ID
    
    static let identifer = "onboardingSubjectCell"
    
    // MARK: - Properties
    
    var color: UIColor? {
        didSet {
            guard let color else { return }
            
            contentView.layer.borderColor = color.withAlphaComponent(0.6).cgColor
            titleLabel.textColor = color.darker(by: 0.8)
        }
    }
    
    var name: String? {
        didSet {
            guard let name else { return }
            
            titleLabel.text = name
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: Fonts.darkModeOnMedium, size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 18
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingSubjectCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
