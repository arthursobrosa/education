//
//  SubjectPlusView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class SubjectPlusView: UIView {
    // MARK: - UI Properties
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
        let color: UIColor = .bluePicker.darker(by: 0.8) ?? .bluePicker
        imageView.image = image
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.bluePicker.withAlphaComponent(0.4).cgColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    // MARK: - Methods
    
    func addTarget(_ target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGesture)
    }
}

// MARK: - UI Setup

extension SubjectPlusView: ViewCodeProtocol {
    func setupUI() {
        addSubview(plusImageView)
        
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 16 / 28),
            plusImageView.heightAnchor.constraint(equalTo: plusImageView.widthAnchor),
            plusImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
