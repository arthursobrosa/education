//
//  ThemeListView.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeListView: UIView {
    // MARK: - Delegate to connect to VC
    
    weak var delegate: ThemeListDelegate? {
        didSet {
            emptyView.themeListDelegate = delegate
        }
    }
    
    // MARK: - UI Properties
    
    private let navigationBar: NavigationBarComponent = {
        let navigationBar = NavigationBarComponent()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    let emptyView: NoThemesView = {
        let view = NoThemesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
        view.alpha = 0
        view.layer.zPosition = 1
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let deleteAlertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.layer.zPosition = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        setupUI()

        updateTableViewColor(traitCollection)

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.updateTableViewColor(self.traitCollection)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    func setNavigationBar() {
        let titleText = String(localized: "themeTab")
        let buttonImage = UIImage(systemName: "plus.circle.fill")
        navigationBar.configure(titleText: titleText, rightButtonImage: buttonImage)
        navigationBar.addRightButtonTarget(delegate, action: #selector(ThemeListDelegate.addThemeButtonTapped))
    }

    private func updateTableViewColor(_: UITraitCollection) {
        tableView.layer.borderColor = UIColor.buttonNormal.cgColor
    }

    func changeAlertVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }

            self.deleteAlertView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
        }
        
        if isShowing {
            setGestureRecognizer()
        } else {
            gestureRecognizers = nil
        }
        
        for subview in subviews where !(subview is AlertView) {
            subview.isUserInteractionEnabled = !isShowing
        }
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        guard !deleteAlertView.frame.contains(tapLocation) else { return }
        
        changeAlertVisibility(isShowing: false)
    }
}

// MARK: - UI Setup

extension ThemeListView: ViewCodeProtocol {
    func setupUI() {
        addSubview(navigationBar)
        navigationBar.layoutToSuperview()
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
