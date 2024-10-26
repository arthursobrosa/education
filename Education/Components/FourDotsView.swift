//
//  FourDotsView.swift
//  Education
//
//  Created by Leandro Silva on 17/09/24.
//

import UIKit

class FourDotsView: UIView {
    // MARK: - UI Properties

    private lazy var dotsStack: UIStackView = {
        let stack = getDotsStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func getDotsStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing
        stack.alignment = .center

        for _ in 0 ..< 4 {
            let dot = createDot(diameter: 6)
            stack.addArrangedSubview(dot)
        }

        return stack
    }

    private func createDot(diameter: Double) -> UIView {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: diameter),
            dot.heightAnchor.constraint(equalTo: dot.widthAnchor),
        ])

        dot.backgroundColor = .label
        dot.layer.cornerRadius = diameter / 2
        return dot
    }
}

// MARK: - UI Setup

extension FourDotsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(dotsStack)

        NSLayoutConstraint.activate([
            dotsStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
            dotsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            dotsStack.widthAnchor.constraint(equalTo: widthAnchor),
            dotsStack.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
