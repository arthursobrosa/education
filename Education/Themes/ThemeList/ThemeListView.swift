//
//  ThemeListView.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeListView: UIView {
    weak var delegate: ThemeListDelegate? {
        didSet {
            self.newThemeAlert.delegate = delegate
        }
    }
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .systemBackground
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let emptyView = EmptyView(message: String(localized: "emptyTheme"))
    
    let newThemeAlert: NewThemeAlert = {
        let view = NewThemeAlert()
        view.isHidden = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ThemeListView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(contentView)
        self.addSubview(newThemeAlert)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            newThemeAlert.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 366/390),
            newThemeAlert.heightAnchor.constraint(equalTo: newThemeAlert.widthAnchor, multiplier: 228/366),
            newThemeAlert.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newThemeAlert.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
