//
//  OnboardingBar.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

@objc
protocol OnboardingBarDelegate: AnyObject {
    func backButtonTapped()
    func skipButtonTapped()
}

class OnboardingBar: UIView {
    // MARK: - Delegate
    
    weak var delegate: OnboardingBarDelegate?
    
    // MARK: - UI Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let image = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15))
        button.setImage(image, for: .normal)
        button.tintColor = .systemText40
        button.addTarget(delegate, action: #selector(OnboardingBarDelegate.backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let titleName = String(localized: "skip")
        let titleFont: UIFont = .init(name: Fonts.darkModeOnRegular, size: 15) ?? .systemFont(ofSize: 15, weight: .regular)
        let titleColor: UIColor = .systemText80
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: titleColor,
        ]
        let attributedTitle = NSAttributedString(string: titleName, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(delegate, action: #selector(OnboardingBarDelegate.skipButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(showsBackButton: Bool) {
        super.init(frame: .zero)
        backButton.isHidden = !showsBackButton
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func hideSkipButton() {
        skipButton.isHidden = true
        skipButton.isUserInteractionEnabled = false
    }
}

// MARK: - UI Setup

extension OnboardingBar: ViewCodeProtocol {
    func setupUI() {
        addSubview(backButton)
        addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 15 / 390),
            backButton.heightAnchor.constraint(equalTo: backButton.heightAnchor),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 57),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            
            skipButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
        ])
    }
    
    func layoutToSuperview() {
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 74 / 390),
            topAnchor.constraint(equalTo: superview.topAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])
    }
}

// MARK: - Preview

class OnboardingBarPreviewVC: UIViewController {
    private lazy var onboardingBar: OnboardingBar = {
        let onboardingBar = OnboardingBar(showsBackButton: true)
        onboardingBar.delegate = self
        onboardingBar.translatesAutoresizingMaskIntoConstraints = false
        return onboardingBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(onboardingBar)
        onboardingBar.layoutToSuperview()
    }
}

extension OnboardingBarPreviewVC: OnboardingBarDelegate {
    func backButtonTapped() {
        print(#function)
    }
    
    func skipButtonTapped() {
        print(#function)
    }
}

#Preview {
    OnboardingBarPreviewVC()
}
