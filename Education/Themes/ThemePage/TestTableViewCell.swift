//
//  TestTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class TestTableViewCell: UITableViewCell {
    static let identifier = "TestCell"
    
    
    // MARK: - UI Components
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var questionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(questionsLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            questionsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            questionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: questionsLabel.leadingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Helper Methods
    
    func configure(with test: Test) {
        dateLabel.text = formatDate(test.date ?? Date.now)
        questionsLabel.text = "\(test.rightQuestions) / \(test.totalQuestions)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
