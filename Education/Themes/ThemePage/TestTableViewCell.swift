//
//  TestTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class TestTableViewCell: UITableViewCell {
    // MARK: - ID
    static let identifier = "testCell"
    
    // MARK: - Object to populate subviews
    var test: Test? {
        didSet {
            guard let test else { return }
            
            self.dateLabel.text = formatDate(test.date ?? Date.now)
            self.questionsLabel.text = "\(test.rightQuestions) / \(test.totalQuestions)"
        }
    }
    
    // MARK: - UI Components
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let questionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.backgroundColor = .systemGray5
        }
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

// MARK: - UI Setup
extension TestTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(questionsLabel)
        
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            
            questionsLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            questionsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: questionsLabel.leadingAnchor, constant: -padding)
        ])
    }
}
