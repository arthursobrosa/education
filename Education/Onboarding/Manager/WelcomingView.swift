//
//  WelcomingView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class WelcomingView: UIView {
    // MARK: - Properties
    
    private var labels: [UILabel] = []
    
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

    private lazy var simpleLabel: UILabel = {
        let label = getLabel(withName: String(localized: "simple"))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clearLabel: UILabel = {
        let label = getLabel(withName: String(localized: "clear"))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var straightLabel: UILabel = {
        let label = getLabel(withName: String(localized: "straightforward"))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var believeLabel: UILabel = {
        let label = getLabel(withName: String(localized: "believeToBe"))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        setupUI()
        setLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
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
        label.alpha = 0
        return label
    }
    
    func resetView() {
        simpleLabel.layer.transform = CATransform3DIdentity
        clearLabel.layer.transform = CATransform3DIdentity
        straightLabel.layer.transform = CATransform3DIdentity
        believeLabel.layer.transform = CATransform3DIdentity
        
        welcomeLabelTopConstraint?.constant = 357
        layoutIfNeeded()
        
        welcomeLabel.textColor = .label
        descriptionLabel.textColor = .label
    }
    
    private func setLabels() {
        labels = [
            simpleLabel,
            clearLabel,
            straightLabel,
            believeLabel,
        ]
    }
    
    private func getLabelWidth(label: UILabel) -> Double {
        let maxSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = label.sizeThatFits(maxSize)
        return expectedSize.width
    }
    
    func animateTopView(isStarting: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            
            self.welcomeLabelTopConstraint?.constant = isStarting ? 136 : 357
            self.layoutIfNeeded()
            
            self.welcomeLabel.textColor = isStarting ? .systemText40 : .label
            self.descriptionLabel.textColor = isStarting ? .systemText40 : .label
        } completion: { _ in
            completion?()
        }
    }
    
    private func applyTranslation(to label: UILabel, duration: CFTimeInterval, isPositive: Bool) {
        let labelOffset = getLabelWidth(label: label) / 2
        var xOffset = bounds.width * 0.5 + labelOffset
        xOffset *= isPositive ? 1 : -1

        let translationTransform = CATransform3DMakeTranslation(xOffset, 0, 0)

        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        animation.fromValue = label.layer.transform
        animation.toValue = translationTransform
        label.layer.add(animation, forKey: "transform")

        label.layer.transform = CATransform3DConcat(label.layer.transform, translationTransform)
        
        label.alpha = isPositive ? 1 : 0
    }
    
    func animateLabel(withIndex index: Int, isStarting: Bool) {
        let duration: Double = isStarting ? 1 : 0.5
        let delay: Double = isStarting ? (index == 0 ? 0 : 0.5) : 0
        var nextIndex = index
        
        if isStarting {
            if index > 3 {
                return
            }
            
            nextIndex += 1
        } else {
            nextIndex -= 1
        }
        
        if index < 0 {
            animateTopView(isStarting: false)
            return
        }
        
        let label = labels[index]
        
        UIView.animate(withDuration: duration, delay: delay) { [weak self] in
            guard let self else { return }
            
            self.applyTranslation(to: label, duration: duration, isPositive: isStarting)
            label.alpha = isStarting ? 1 : 0
        } completion: { [weak self] _ in
            guard let self else { return }
            
            self.animateLabel(withIndex: nextIndex, isStarting: isStarting)
        }
    }
    
    func startAnimation() {
        animateTopView(isStarting: true) { [weak self] in
            guard let self else { return }
            
            self.animateLabel(withIndex: 0, isStarting: true)
        }
    }
    
    func restartAnimation() {
        animateLabel(withIndex: 3, isStarting: false)
    }
}

// MARK: UI Setup

extension WelcomingView: ViewCodeProtocol {
    func setupUI() {
        addSubview(welcomeLabel)
        addSubview(descriptionLabel)
        addSubview(simpleLabel)
        addSubview(clearLabel)
        addSubview(straightLabel)
        addSubview(believeLabel)
        
        welcomeLabelTopConstraint = welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 357)
        welcomeLabelTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 29),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
            
            simpleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 333),
            simpleLabel.trailingAnchor.constraint(equalTo: leadingAnchor),
            
            clearLabel.topAnchor.constraint(equalTo: simpleLabel.bottomAnchor, constant: 16),
            clearLabel.trailingAnchor.constraint(equalTo: simpleLabel.trailingAnchor),
           
            straightLabel.topAnchor.constraint(equalTo: clearLabel.bottomAnchor, constant: 16),
            straightLabel.trailingAnchor.constraint(equalTo: clearLabel.trailingAnchor),
           
            believeLabel.topAnchor.constraint(equalTo: straightLabel.bottomAnchor, constant: 16),
            believeLabel.trailingAnchor.constraint(equalTo: straightLabel.trailingAnchor),
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
