//
//  ThemeEditionViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeEditionViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    
    weak var coordinator: Dismissing?
    let viewModel: ThemeEditionViewModel

    // MARK: - UI Components
    
    private lazy var themeEditionView: ThemeEditionView = {
        let view = ThemeEditionView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var centerYConstraint: NSLayoutConstraint!

    // MARK: - Initializer
    
    init(viewModel: ThemeEditionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            if previousTraitCollection.userInterfaceStyle == .dark {
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }

        setupUI()
        setGestureRecognizer()

        themeEditionView.setTitleLabel(theme: viewModel.theme)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)

        guard !themeEditionView.frame.contains(tapLocation) else { return }

        coordinator?.dismiss(animated: true)
    }

    @objc 
    private func keyboardChangedFirstResponder(notification: Notification) {
        guard let info = notification.userInfo else { return }

        let offset = view.bounds.height * (40 / 844)

        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            centerYConstraint.constant = -offset
        case UIResponder.keyboardWillHideNotification:
            centerYConstraint.constant += offset
        default:
            break
        }
        
        guard let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }

        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UI Setup

extension ThemeEditionViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(themeEditionView)

        NSLayoutConstraint.activate([
            themeEditionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 366 / 390),
            themeEditionView.heightAnchor.constraint(equalTo: themeEditionView.widthAnchor, multiplier: 228 / 366),
            themeEditionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        centerYConstraint = themeEditionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.isActive = true
    }
}

// MARK: - Text Field Delegate

extension ThemeEditionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.currentThemeName = text.trimmed()
    }
}
