//
//  BorderedTableView.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import UIKit

class BorderedTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)

        register(BorderedTableCell.self, forCellReuseIdentifier: BorderedTableCell.identifier)

        separatorStyle = .none
        backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
