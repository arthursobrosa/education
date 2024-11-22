//
//  WeeklyScheduleCollectionView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class WeeklyScheduleCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout _: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        super.init(frame: frame, collectionViewLayout: layout)

        showsHorizontalScrollIndicator = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
