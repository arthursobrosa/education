//
//  SplashView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/07/24.
//

import UIKit
import Combine
import Lottie

class SplashView: UIView {
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "AppIcon")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "splashBack")
        
        self.setupUI()
        
        self.animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SplashView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(animationView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            animationView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: padding * 3),
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
}
