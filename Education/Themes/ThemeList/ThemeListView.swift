//
//  ThemeListView.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeListView: UIView {
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
        table.layer.borderColor = UIColor.buttonNormal.cgColor
        return table
    }()
    
    let emptyView: NoThemesView = {
        let view = NoThemesView()
        view.noThemesCase = .theme
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
        
        self.updateTableViewColor(self.traitCollection)
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.updateTableViewColor(self.traitCollection)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTableViewColor(_ traitCollection: UITraitCollection) {
        tableView.layer.borderColor = UIColor.buttonNormal.cgColor
    }
}

extension ThemeListView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
