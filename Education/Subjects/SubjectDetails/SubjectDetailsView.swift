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
    }
}
