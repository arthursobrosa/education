//
//  FocusSubjectDetailsCell.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import UIKit

class FocusSubjectDetailsCell: UITableViewCell {
    // MARK: - Identifier
    
    static let identifier = "focusSubjectDetailCell"
    
    // MARK: - Properties
    
    var title: String? {
        didSet {
            guard let title else { return }
            
            titleLabel.text = title
        }
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

extension FocusSubjectDetailsCell: ViewCodeProtocol {
    func setupUI() {
        
    }
}
