//
//  ElipseStackView.swift
//  Education
//
//  Created by Leandro Silva on 17/09/24.
//

import UIKit

class ElipseStackView: UIView {
    
    private let circle1 = UIView()
    private let circle2 = UIView()
    private let circle3 = UIView()
    private let circle4 = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var alpha: CGFloat {
        didSet {
            updateCirclesAlpha()
        }
    }

    private func updateCirclesAlpha() {
        let newAlpha = self.alpha
        circle1.alpha = newAlpha
        circle2.alpha = newAlpha
        circle3.alpha = newAlpha
        circle4.alpha = newAlpha
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear

        let circleSize: CGFloat = 6

        func createSmallCircle() -> UIView {
            let circle = UIView()
            circle.backgroundColor = .label
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = circleSize / 2
            circle.alpha = self.alpha
            return circle
        }

        setupCircle(circle1, circleSize: circleSize)
        setupCircle(circle2, circleSize: circleSize)
        setupCircle(circle3, circleSize: circleSize)
        setupCircle(circle4, circleSize: circleSize)

        self.addSubview(circle1)
        self.addSubview(circle2)
        self.addSubview(circle3)
        self.addSubview(circle4)
        
        let padding = 8.0

        NSLayoutConstraint.activate([
            // Círculo 1
            circle1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle1.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            circle1.widthAnchor.constraint(equalToConstant: circleSize),
            circle1.heightAnchor.constraint(equalTo: circle1.widthAnchor),

            // Círculo 2
            circle2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle2.topAnchor.constraint(equalTo: circle1.bottomAnchor, constant: padding),
            circle2.widthAnchor.constraint(equalToConstant: circleSize),
            circle2.heightAnchor.constraint(equalTo: circle2.widthAnchor),

            // Círculo 3
            circle3.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle3.topAnchor.constraint(equalTo: circle2.bottomAnchor, constant: padding),
            circle3.widthAnchor.constraint(equalToConstant: circleSize),
            circle3.heightAnchor.constraint(equalTo: circle3.widthAnchor),

            // Círculo 4
            circle4.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle4.topAnchor.constraint(equalTo: circle3.bottomAnchor, constant: padding),
            circle4.widthAnchor.constraint(equalToConstant: circleSize),
            circle4.heightAnchor.constraint(equalTo: circle4.widthAnchor),
        ])
    }

    private func setupCircle(_ circle: UIView, circleSize: CGFloat) {
        circle.backgroundColor = .label
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = circleSize / 2
        circle.alpha = self.alpha
    }
}
