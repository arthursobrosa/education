//
//  SubjectCollectionCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class SubjectCollectionCell: UICollectionViewCell {
    // MARK: - ID
    
    static let identifier = "subjectCollectionCell"
    
    // MARK: - Properties
    
    var subjectName: String? {
        didSet {
            guard let subjectName else { return }
            
            titleLabel.text = subjectName
        }
    }
    
    var isSelectedSubject: Bool = false {
        didSet {
            let borderColor: UIColor = isSelectedSubject ? .bluePicker : .bluePicker.withAlphaComponent(0.4).opaqueColor()
            
            let textColor: UIColor? = isSelectedSubject ? .bluePicker.darker(by: 0.6) : .bluePicker
            let borderWidth: Double = isSelectedSubject ? 1.5 : 1.0
            
            contentView.layer.borderColor = borderColor.cgColor
            contentView.layer.borderWidth = borderWidth
            titleLabel.textColor = textColor
            
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
                let borderColor: UIColor = self.isSelectedSubject ? .bluePicker : .bluePicker.withAlphaComponent(0.4).opaqueColor()
                self.contentView.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.numberOfLines = 1
        label.textColor = .bluePicker
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.bluePicker.withAlphaComponent(0.4).cgColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectedSubject = false
    }
}

// MARK: - UI Setup

extension SubjectCollectionCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
