//
//  ThemeListCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeListCell: UITableViewCell {
    static let identifier = "themeListCell"
    
    private let customContentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContentView(with view: UIView) {
        self.customContentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor),
            view.centerYAnchor.constraint(equalTo: customContentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.customContentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

extension ThemeListCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(customContentView)
        
        NSLayoutConstraint.activate([
            customContentView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            customContentView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8),
            customContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18),
            customContentView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
