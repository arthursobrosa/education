//
//  EmptyView.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/07/24.
//

import UIKit

class EmptyView: UIView {
    private let sealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "sealSplash")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(object: String) {
        super.init(frame: .zero)
        
        self.messageLabel.text = String(format: NSLocalizedString("emptyMessage", comment: ""), object)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(sealImageView)
        self.addSubview(messageLabel)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            sealImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sealImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: padding / 2),
            sealImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            sealImageView.heightAnchor.constraint(equalTo: sealImageView.widthAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: sealImageView.bottomAnchor, constant: padding),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding * 2),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(padding * 2))
        ])
    }
}
