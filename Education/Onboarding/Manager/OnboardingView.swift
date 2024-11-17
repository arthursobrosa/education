//
//  OnboardingView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class OnboardingView: UIView {
    // MARK: - Delegate
    
    weak var delegate: OnboardingManagerDelegate?
    
    // MARK: - Properties
    
    private let showsBackButton: Bool
    
    // MARK: - UI Properties
    
    private lazy var onboardingBar: OnboardingBar = {
        let onboardingBar = OnboardingBar(showsBackButton: showsBackButton)
        onboardingBar.delegate = self
        onboardingBar.translatesAutoresizingMaskIntoConstraints = false
        return onboardingBar
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let titleName = String(localized: "next")
        let titleFont: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        let titleColor: UIColor = .systemText40
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor,
        ]
        let attributedTitle = NSAttributedString(string: titleName, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(delegate, action: #selector(OnboardingManagerDelegate.goToNextPage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(showsBackButton: Bool) {
        self.showsBackButton = showsBackButton
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension OnboardingView: ViewCodeProtocol {
    func setupUI() {
        addSubview(onboardingBar)
        onboardingBar.layoutToSuperview()
        
        addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

// MARK: - Onboarding Bar Managing

extension OnboardingView: OnboardingBarDelegate {
    func backButtonTapped() {
        delegate?.goToPreviousPage()
    }
    
    func skipButtonTapped() {
        delegate?.skipAllPages()
    }
}
