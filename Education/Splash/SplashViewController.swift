//
//  SplashViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/07/24.
//

import UIKit

class SplashViewController: UIViewController {
    // MARK: - Coordinator
    weak var coordinator: ShowingTabBar?
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "books")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let plaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pla")
        imageView.contentMode = .scaleAspectFit
        
        imageView.alpha = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nnoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nno")
        imageView.contentMode = .scaleAspectFit
        
        imageView.alpha = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let basicAnimation: CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.keyPath = "transform"
        
        return animation
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.setupUI()
        
        let waitingTime: CGFloat = UserDefaults.isFirstEntry ? 6 : 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitingTime) { [weak self] in
            guard let self else { return }
            
            if UserDefaults.isFirstEntry {
                UserDefaults.isFirstEntry = false
            }
            
            self.coordinator?.showTabBar()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startAnimations()
    }
    
    // MARK: - Methods
    private func startAnimations() {
        let duration: TimeInterval = 2
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat, .autoreverse]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.applyRotation(to: self.logoImageView, duration: duration * 0.5)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                self.applyTranslation(to: self.logoImageView, duration: duration * 0.3)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                self.plaImageView.alpha = 1
                self.logoImageView.alpha = 0
                self.nnoImageView.alpha = 1
            }
        }
    }
    
    private func applyRotation(to view: UIView, duration: CFTimeInterval) {
        let rotationAndScaleTransform = CATransform3DConcat(
            CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1),
            CATransform3DMakeScale(0.5, 0.5, 1)
        )
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        animation.fromValue = view.layer.transform
        animation.toValue = rotationAndScaleTransform
        view.layer.add(animation, forKey: "transform")
        view.layer.transform = rotationAndScaleTransform
    }
    
    private func applyTranslation(to view: UIView, duration: CFTimeInterval) {
        let xOffset = self.view.frame.width * 0.15
        
        let translationTransform = CATransform3DMakeTranslation(xOffset, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        animation.fromValue = view.layer.transform
        animation.toValue = translationTransform
        view.layer.add(animation, forKey: "transform")
        
        view.layer.transform = CATransform3DConcat(view.layer.transform, translationTransform)
    }
}

// MARK: - UI Setup
extension SplashViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(plaImageView)
        self.view.addSubview(nnoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: (295/123)),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            plaImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.32),
            plaImageView.heightAnchor.constraint(equalTo: plaImageView.widthAnchor, multiplier: 155/196),
            plaImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(self.view.frame.width * 0.2)),
            plaImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            nnoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.5),
            nnoImageView.widthAnchor.constraint(equalTo: nnoImageView.heightAnchor, multiplier: 218/91),
            nnoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 0.15),
            nnoImageView.centerYAnchor.constraint(equalTo: plaImageView.centerYAnchor)
        ])
    }
}
