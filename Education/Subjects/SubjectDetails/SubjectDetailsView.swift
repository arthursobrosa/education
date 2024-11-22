//
//  SubjectDetailsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class SubjectDetailsView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: SubjectDetailsDelegate?
    
    // MARK: - Properties
    
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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let emptyView: EmptySubjectDetailsView = {
        let emptyView = EmptySubjectDetailsView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    let statusAlertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.layer.zPosition = 2
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

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setNavigationBar(subject: Subject?) {
        var titleText: String
        var imageName: String
        var selector: Selector
        var isDestructive: Bool
        
        if let subject {
            titleText = subject.unwrappedName
            imageName = "square.and.pencil"
            selector = #selector(SubjectDetailsDelegate.editButtonTapped)
            isDestructive = false
        } else {
            titleText = String(localized: "other")
            imageName = "trash"
            selector = #selector(SubjectDetailsDelegate.deleteButtonTapped)
            isDestructive = true
        }
        
        let image = UIImage(systemName: imageName)
        let rightButtonConfig: NavigationBarComponent.RightButtonConfig = .init(
            rightButtonSize: .small,
            isDestructive: isDestructive
        )
        
        navigationBar.configure(
            titleText: titleText,
            rightButtonImage: image,
            rightButtonConfig: rightButtonConfig,
            hasBackButton: true
        )
        
        navigationBar.addRightButtonTarget(delegate, action: selector)
        navigationBar.addBackButtonTarget(delegate, action: #selector(SubjectDetailsDelegate.dismiss))
    }
    
    func changeAlertVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }

            self.statusAlertView.isHidden = !isShowing
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
        
        guard !statusAlertView.frame.contains(tapLocation) else { return }
        
        changeAlertVisibility(isShowing: false)
    }
}

// MARK: - UI Setup

extension SubjectDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(navigationBar)
        navigationBar.layoutToSuperview()
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
