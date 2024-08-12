//
//  ActivityButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

enum ActivityState {
    case current(color: UIColor?)
    case normal
}

class ActivityButton: UIButton {
    var activityState: ActivityState? {
        didSet {
            guard let activityState else { return }
            
            self.setButtonForState(activityState)
        }
    }
    
    var isPaused: Bool = true {
        didSet {
            let imageName = isPaused ? "play.fill" : "pause.fill"
            actionImageView.image = UIImage(systemName: imageName)
        }
    }
    
    private let firstLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.2
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let secondLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let thirdLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var actionImageView: UIImageView = {
        let imageName = self.isPaused ? "play.fill" : "pause.fill"
        let actionImage = UIImage(systemName: imageName)
        
        let actionImageView = UIImageView(image: actionImage)
        actionImageView.contentMode = .scaleAspectFit
        actionImageView.tintColor = .white
        
        actionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return actionImageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.firstLayerView.layer.cornerRadius = self.firstLayerView.bounds.width / 2
        self.secondLayerView.layer.cornerRadius = self.secondLayerView.bounds.width / 2
        self.thirdLayerView.layer.cornerRadius = self.thirdLayerView.bounds.width / 2
    }
    
    private func setButtonForState(_ activityState: ActivityState) {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        switch activityState {
            case .current(let color):
                self.actionImageView.tintColor = color
                self.thirdLayerView.backgroundColor = .white
                self.setupCurrentActivityUI()
            case .normal:
                self.actionImageView.tintColor = .white
                self.thirdLayerView.backgroundColor = .black.withAlphaComponent(0.3)
                self.setupNormalActivityUI()
        }
    }
}

private extension ActivityButton {
    func setupCurrentActivityUI() {
        self.addSubview(firstLayerView)
        self.addSubview(secondLayerView)
        self.addSubview(thirdLayerView)
        self.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            firstLayerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            firstLayerView.heightAnchor.constraint(equalTo: firstLayerView.widthAnchor),
            firstLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            firstLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            secondLayerView.widthAnchor.constraint(equalTo: firstLayerView.widthAnchor, multiplier: (46/52)),
            secondLayerView.heightAnchor.constraint(equalTo: secondLayerView.widthAnchor),
            secondLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            secondLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            thirdLayerView.widthAnchor.constraint(equalTo: secondLayerView.widthAnchor, multiplier: (40/46)),
            thirdLayerView.heightAnchor.constraint(equalTo: thirdLayerView.widthAnchor),
            thirdLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            thirdLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            actionImageView.widthAnchor.constraint(equalTo: thirdLayerView.widthAnchor, multiplier: 0.4),
            actionImageView.centerXAnchor.constraint(equalTo: thirdLayerView.centerXAnchor),
            actionImageView.centerYAnchor.constraint(equalTo: thirdLayerView.centerYAnchor)
        ])
    }
    
    func setupNormalActivityUI() {
        self.addSubview(thirdLayerView)
        self.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            thirdLayerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (40/52)),
            thirdLayerView.heightAnchor.constraint(equalTo: thirdLayerView.widthAnchor),
            thirdLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            thirdLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            actionImageView.widthAnchor.constraint(equalTo: thirdLayerView.widthAnchor, multiplier: 0.4),
            actionImageView.centerXAnchor.constraint(equalTo: thirdLayerView.centerXAnchor),
            actionImageView.centerYAnchor.constraint(equalTo: thirdLayerView.centerYAnchor)
        ])
    }
}
