//
//  WelcomingView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class WelcomingView: UIView {
    // MARK: - UI Properties
    
    private var welcomeLabelTopConstraint: NSLayoutConstraint?
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        let font: UIFont = .init(name: Fonts.darkModeOnMedium, size: 22) ?? .systemFont(ofSize: 22, weight: .medium)
        let color: UIColor = .label
        label.text = String(localized: "welcomeText")
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        let name = String(localized: "appDescription")
        let font: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        let color: UIColor = .label
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let attributedText = NSAttributedString(string: name, attributes: attributes)
        label.attributedText = attributedText
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let adjectivesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.alpha = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        setupUI()
        setAjectivesStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setAjectivesStack() {
        let adjectives: [String] = [
            String(localized: "simple"),
            String(localized: "clear"),
            String(localized: "straightforward"),
            String(localized: "believeToBe"),
        ]
        
        for adjective in adjectives {
            let label = getLabel(withName: adjective)
            adjectivesStackView.addArrangedSubview(label)
        }
    }
    
    private func getLabel(withName name: String) -> UILabel {
        let label = UILabel()
        let font: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        let color: UIColor = .label
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let attributedText = NSAttributedString(string: name, attributes: attributes)
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }
    
    func startAnimation() {
        welcomeLabelTopConstraint?.constant = 136
        
        let duration: TimeInterval = 1

        UIView.animateKeyframes(withDuration: duration, delay: 0) { [weak self] in
            guard let self else { return }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.layoutIfNeeded()
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.adjectivesStackView.alpha = 1
                self.welcomeLabel.textColor = .systemText40
                self.descriptionLabel.textColor = .systemText40
            }
        }
    }
    
    func restartAnimation() {
        welcomeLabelTopConstraint?.constant = 357
        
        let duration: TimeInterval = 1

        UIView.animateKeyframes(withDuration: duration, delay: 0) { [weak self] in
            guard let self else { return }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.adjectivesStackView.alpha = 0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.layoutIfNeeded()
                self.welcomeLabel.textColor = .label
                self.descriptionLabel.textColor = .label
            }
        }
    }
}

// MARK: UI Setup

extension WelcomingView: ViewCodeProtocol {
    func setupUI() {
        addSubview(welcomeLabel)
        addSubview(descriptionLabel)
        
        welcomeLabelTopConstraint = welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 357)
        welcomeLabelTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 29),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
        ])
        
        addSubview(adjectivesStackView)
        
        NSLayoutConstraint.activate([
            adjectivesStackView.topAnchor.constraint(equalTo: topAnchor, constant: 333),
            adjectivesStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adjectivesStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func layoutToSuperview() {
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}

// MARK: - Preview

class WelcomingPreviewVC: UIViewController {
    private let welcomingView = WelcomingView()
    
    override func loadView() {
        view = welcomingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            self.welcomingView.startAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self else { return }
            
            self.welcomingView.restartAnimation()
        }
    }
}

#Preview {
    WelcomingPreviewVC()
}
