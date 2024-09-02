//
//  ActivityButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityButton: UIButton {
    let circleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var playImageView: UIImageView = {
        let imageName = "play.fill"
        let actionImage = UIImage(systemName: imageName)
        
        let actionImageView = UIImageView(image: actionImage)
        actionImageView.contentMode = .scaleAspectFit
        
        actionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return actionImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.circleView.layer.cornerRadius = self.circleView.bounds.width / 2
    }
}

private extension ActivityButton {
    func setupUI() {
        self.addSubview(circleView)
        self.addSubview(playImageView)
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (40/52)),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            playImageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.4),
            playImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            playImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
    }
}
