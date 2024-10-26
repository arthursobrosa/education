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

        register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)

        backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
