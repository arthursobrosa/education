//
//  SettingsTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 03/09/24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "settingsCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 18
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .label
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let cardTextLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let customAccessoryView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withText text: String, withImage image: UIImage) {
        self.cardImageView.image = image.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        self.cardTextLabel.text = text
    }
    
    func setAccessoryView(_ accessoryView: UIView?) {
        guard let accessoryView else { return }
        
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        self.customAccessoryView.addSubview(accessoryView)
        
        NSLayoutConstraint.activate([
            accessoryView.trailingAnchor.constraint(equalTo: self.customAccessoryView.trailingAnchor),
            accessoryView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.customAccessoryView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

extension SettingsTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(cardView)
        cardView.addSubview(cardImageView)
        cardView.addSubview(cardTextLabel)
        cardView.addSubview(customAccessoryView)
        
        let padding = 5.5
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            cardImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 17),
            
            cardTextLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardTextLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 10),
            
            customAccessoryView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -17),
            customAccessoryView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3),
            customAccessoryView.heightAnchor.constraint(equalTo: cardView.heightAnchor),
            customAccessoryView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
}
