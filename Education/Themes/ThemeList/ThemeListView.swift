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
        
        return table
    }()
    
    let emptyView: UILabel = {
        let label = UILabel()
        label.text = String(localized: "emptyTheme")
        label.font = UIFont(name: Fonts.darkModeOnBold, size: 16)!
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
