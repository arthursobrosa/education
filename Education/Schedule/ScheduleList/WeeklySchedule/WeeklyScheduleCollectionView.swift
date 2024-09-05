//
//  WeeklyScheduleCollectionView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class WeeklyScheduleCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.showsHorizontalScrollIndicator = false
        
        self.tag = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
