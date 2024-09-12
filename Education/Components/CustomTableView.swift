//
//  CustomTableView.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import UIKit

class CustomTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        
        self.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
