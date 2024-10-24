//
//  DailyScheduleView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class DailyScheduleView: UIView {
    // MARK: - UI Properties
    let daysStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 19
        
        stack.backgroundColor = .systemBackground
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        
        collection.tag = 0
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension DailyScheduleView: ViewCodeProtocol {
    func setupUI() {
        addSubview(daysStack)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            daysStack.topAnchor.constraint(equalTo: topAnchor),
            daysStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daysStack.heightAnchor.constraint(equalTo: daysStack.widthAnchor, multiplier: 58 / 359),
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentView.topAnchor.constraint(equalTo: daysStack.bottomAnchor, constant: 18),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
