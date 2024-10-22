//
//  ActivityButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityButton: UIButton {
    // MARK: - Properties
    enum PlayButtonCase {
        case fill
        case stroke
        
        var imageName: String {
            switch self {
                case .fill:
                    "play.fill"
                case .stroke:
                    "play.circle"
            }
        }
        
        var hasCircleView: Bool {
            switch self {
                case .fill:
                    true
                case .stroke:
                    false
            }
        }
    }
    
    var styleCase: PlayButtonCase? {
        didSet {
            guard let styleCase else { return }
            
            let imageName = styleCase.imageName
            let image = UIImage(systemName: imageName)
            playImageView.image = image
            
            setupUI()
        }
    }
    
    // MARK: - UI Properties
    let circleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleView.layer.cornerRadius = circleView.bounds.width / 2
    }
}

// MARK: - UI Setup
extension ActivityButton: ViewCodeProtocol {
    func setupUI() {
        guard let styleCase else { return }
        
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if styleCase.hasCircleView {
            addSubview(circleView)
            addSubview(playImageView)
            
            NSLayoutConstraint.activate([
                circleView.widthAnchor.constraint(equalTo: widthAnchor),
                circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
                circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                playImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
                playImageView.heightAnchor.constraint(equalTo: playImageView.heightAnchor),
                playImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                playImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        } else {
            addSubview(playImageView)
            
            NSLayoutConstraint.activate([
                playImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2),
                playImageView.heightAnchor.constraint(equalTo: playImageView.heightAnchor),
                playImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                playImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
    }
}
