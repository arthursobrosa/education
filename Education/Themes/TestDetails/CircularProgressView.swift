//
//  CircularProgressView.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/11/24.
//

import UIKit

class CircularProgressView: UIView {
    // MARK: - Properties
    
    var progressColor = UIColor.systemBlue {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    
    // MARK: - UI Properties
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircularPath()
    }

    // MARK: - Methods
    
    private func setupCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: frame.size.height / 2.0), radius: (frame.size.width) / 2, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)

        // Track layer (background circle)
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.trackLayer.strokeColor = self.trackColor.cgColor
        }
        
        trackLayer.lineWidth = 20.0
        trackLayer.lineCap = .round
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        // Progress layer (progress circle)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 20.0
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress
        layer.addSublayer(progressLayer)
    }
}
