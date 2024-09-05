//
//  DailyScheduleView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class DailyScheduleView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DailyScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(daysStack)
        self.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            daysStack.topAnchor.constraint(equalTo: self.topAnchor),
            daysStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            daysStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            daysStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            daysStack.heightAnchor.constraint(equalTo: daysStack.widthAnchor, multiplier: (58/359)),
            
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            contentView.topAnchor.constraint(equalTo: daysStack.bottomAnchor, constant: 18),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
