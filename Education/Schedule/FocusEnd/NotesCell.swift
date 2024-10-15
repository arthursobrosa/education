//
//  NotesCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class NotesCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "notesCell"
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotesCell: ViewCodeProtocol {
    func setupUI() {
        //
    }
}
