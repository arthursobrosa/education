//
//  NavigationBarComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

class NavigationBarComponent: UIView {
    // MARK: - Properties
    
    enum RightButtonSize {
        case big
        case small
        
        var pointSize: Double {
            switch self {
            case .big:
                40
            case .small:
                27
            }
        }
    }
    
    struct RightButtonConfig {
        private let rightButtonSize: RightButtonSize
        private let isDestructive: Bool
        
        var color: UIColor? {
            if isDestructive {
                .focusColorRed
            } else {
                .buttonSelected
            }
        }
        
        var size: Double {
            rightButtonSize.pointSize
        }
        
        init(rightButtonSize: RightButtonSize, isDestructive: Bool) {
            self.rightButtonSize = rightButtonSize
            self.isDestructive = isDestructive
        }
    }
    
    private var isConfiguringWithLabel: Bool = false
    private var hasBackButton: Bool = false
    private var rightButtonConfig: RightButtonConfig? {
        didSet {
            guard let rightButtonConfig else { return }
            
            rightButton.setPreferredSymbolConfiguration(.init(pointSize: rightButtonConfig.size), forImageIn: .normal)
            rightButton.tintColor = rightButtonConfig.color
        }
    }
    
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
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        button.tintColor = UIColor(named: "system-text-40")
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
    
    func configure(
        titleText: String,
        rightButtonImage: UIImage? = nil,
        rightButtonConfig: RightButtonConfig = .init(rightButtonSize: .big, isDestructive: false),
        hasBackButton: Bool = false) {
            
        isConfiguringWithLabel = true
        self.hasBackButton = hasBackButton
        titleLabel.text = titleText
        self.rightButtonConfig = rightButtonConfig
        rightButton.setImage(rightButtonImage, for: .normal)
        setupUI()
    }
    
    func configure(
        titleImage: UIImage?, 
        rightButtonImage: UIImage? = nil,
        rightButtonConfig: RightButtonConfig = .init(rightButtonSize: .big, isDestructive: false),
        hasBackButton: Bool = false) {
            
        isConfiguringWithLabel = false
        self.hasBackButton = hasBackButton
        titleImageView.image = titleImage
        self.rightButtonConfig = rightButtonConfig
        rightButton.setImage(rightButtonImage, for: .normal)
        setupUI()
    }
    
    func addRightButtonTarget(_ target: Any?, action: Selector) {
        rightButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addBackButtonTarget(_ target: Any?, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - UI Setup

extension NavigationBarComponent: ViewCodeProtocol {
    func setupUI() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        var rightButtonWidth: Double = 0
        
        if let rightButtonConfig {
            rightButtonWidth = rightButtonConfig.size
        }
        
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            rightButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: rightButtonWidth / 390),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
        ])
        
        if isConfiguringWithLabel {
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            ])
        } else {
            addSubview(titleImageView)
            
            NSLayoutConstraint.activate([
                titleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 102 / 390),
                titleImageView.heightAnchor.constraint(equalTo: titleImageView.widthAnchor, multiplier: 37 / 102),
                titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            ])
        }
        
        if hasBackButton {
            addSubview(backButton)
            
            NSLayoutConstraint.activate([
                backButton.topAnchor.constraint(equalTo: topAnchor),
                backButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 27 / 390),
                backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
                backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
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
    }
}
