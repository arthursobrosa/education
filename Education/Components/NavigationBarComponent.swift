//
//  NavigationBarComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

class NavigationBarComponent: UIView {
    // MARK: - Properties
    
    private var isConfiguringWithLabel: Bool = false
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.coconRegular, size: 26)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        button.tintColor = UIColor(named: "system-text")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(titleText: String, buttonImage: UIImage?) {
        isConfiguringWithLabel = true
        titleLabel.text = titleText
        button.setImage(buttonImage, for: .normal)
    }
    
    func configure(titleImage: UIImage?, buttonImage: UIImage?) {
        isConfiguringWithLabel = false
        titleImageView.image = titleImage
        button.setImage(buttonImage, for: .normal)
    }
    
    func addButtonTarget(_ target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - UI Setup

extension NavigationBarComponent: ViewCodeProtocol {
    func setupUI() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 40 / 390),
            button.heightAnchor.constraint(equalTo: button.widthAnchor),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
        ])
        
        if isConfiguringWithLabel {
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 42),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            ])
        } else {
            addSubview(titleImageView)
            
            NSLayoutConstraint.activate([
                titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 102 / 390),
                titleImageView.heightAnchor.constraint(equalTo: titleImageView.widthAnchor, multiplier: 37 / 102),
                titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
                titleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 29),
            ])
        }
    }
    
    func layoutToSuperview() {
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 66 / 390),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: 58),
        ])
        
        setupUI()
    }
}
