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
    private let viewModel: SplashViewModel
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        if(UITraitCollection.current.userInterfaceStyle == .light){
            imageView.image = UIImage(named: "books")
        } else {
            imageView.image = UIImage(named: "books-dark")
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let plaImageView: UIImageView = {
        let imageView = UIImageView()
        if(UITraitCollection.current.userInterfaceStyle == .light){
            imageView.image = UIImage(named: "pla")
        } else {
            imageView.image = UIImage(named: "pla-dark")
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nnoImageView: UIImageView = {
        let imageView = UIImageView()
        if(UITraitCollection.current.userInterfaceStyle == .light){
            imageView.image = UIImage(named: "nno")
        } else {
            imageView.image = UIImage(named: "nno-dark")
        }
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
    
    // MARK: - Initializer
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        viewModel.isAvailable.bind { [weak self] isAvailable in
            guard let self,
                  isAvailable else { return }
            
            self.showTab(after: self.viewModel.extraAnimationTime)
            print("Synced with iCloud")
        }
        
        viewModel.unavailableStatus.bind { [weak self] status in
            guard let self,
                  let status else { return }
            
            if case .noNetwork = status {
                self.showAlert(title: status.title, message: status.message)
                return
            }
            
            if case .accountNotAvailable = status {
                self.showAlert(title: status.title, message: status.message)
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimations()
    }
    
    // MARK: - Methods
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: String(localized: "tryAgain"), style: .cancel) { [weak self] _ in
            guard let self else { return }
            
            self.dismiss(animated: true)
            self.viewModel.setSyncMonitor()
        }
        
        let continueAction = UIAlertAction(title: String(localized: "continue"), style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            self.dismiss(animated: true)
            self.showTab(after: 0)
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(continueAction)
        
        present(alertController, animated: true)
    }
    
    private func showTab(after interval: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            guard let self else { return }
            
            self.coordinator?.showTabBar()
        }
    }
    
    private func startAnimations() {
        let duration: TimeInterval = 2
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat, .autoreverse]) { [weak self] in
            guard let self else { return }
            
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
            CATransform3DMakeScale(0.45, 0.45, 1)
        )
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        animation.fromValue = view.layer.transform
        animation.toValue = rotationAndScaleTransform
        view.layer.add(animation, forKey: "transform")
        view.layer.transform = rotationAndScaleTransform
    }
    
    private func applyTranslation(to view: UIView, duration: CFTimeInterval) {
        let xOffset = self.view.frame.width * 0.16
        
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
        view.addSubview(logoImageView)
        view.addSubview(plaImageView)
        view.addSubview(nnoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 295 / 123),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plaImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.288),
            plaImageView.heightAnchor.constraint(equalTo: plaImageView.widthAnchor, multiplier: 155/196),
            plaImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(self.view.frame.width * 0.16)),
            plaImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            nnoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.45),
            nnoImageView.widthAnchor.constraint(equalTo: nnoImageView.heightAnchor, multiplier: 218/91),
            nnoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 0.16),
            nnoImageView.centerYAnchor.constraint(equalTo: plaImageView.centerYAnchor)
        ])
    }
}
