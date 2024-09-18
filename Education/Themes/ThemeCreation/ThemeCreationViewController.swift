//
//  ThemeCreationViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeCreationViewController: UIViewController {
    weak var coordinator: Dismissing?
    let viewModel: ThemeCreationViewModel
    
    private lazy var themeCreationView: ThemeCreationView = {
        let view = ThemeCreationView()
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var centerYConstraint: NSLayoutConstraint!
    
    init(viewModel: ThemeCreationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            if previousTraitCollection.userInterfaceStyle == .dark {
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }
        
        self.setupUI()
        self.setGestureRecognizer()
        
        self.themeCreationView.setTitleLabel(theme: self.viewModel.theme)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        guard !self.themeCreationView.frame.contains(tapLocation) else { return }
        
        self.coordinator?.dismiss(animated: true)
    }
    
    @objc private func keyboardChangedFirstResponder(notification: Notification) {
        guard let info = notification.userInfo else { return }
        
        let offset = self.view.bounds.height * (40/844)
        
        switch notification.name {
            case UIResponder.keyboardWillShowNotification:
                self.centerYConstraint.constant = -offset
            case UIResponder.keyboardWillHideNotification:
                self.centerYConstraint.constant += offset
            default:
                break
        }
        
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
}

extension ThemeCreationViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(themeCreationView)
        
        NSLayoutConstraint.activate([
            themeCreationView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 366/390),
            themeCreationView.heightAnchor.constraint(equalTo: themeCreationView.widthAnchor, multiplier: 228/366),
            themeCreationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.centerYConstraint = themeCreationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.centerYConstraint.isActive = true
    }
}

extension ThemeCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.viewModel.currentThemeName = text
    }
}
