//
//  CenterAlignedViewFlowLayout.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import UIKit

class CenterAlignedViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var rows: [[UICollectionViewLayoutAttributes]] = []
        var currentRowY: CGFloat = -1
        
        for attribute in attributes {
            if attribute.frame.origin.y != currentRowY {
                rows.append([attribute])
                currentRowY = attribute.frame.origin.y
            } else {
                if var lastRow = rows.last {
                    lastRow.append(attribute)
                    rows[rows.count - 1] = lastRow
                }
            }
        }
        
        for rowAttributes in rows {
            centerRow(rowAttributes)
        }
        
        return attributes
    }
    
    private func centerRow(_ attributes: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView else { return }
        
        let totalWidth = attributes.reduce(0) { $0 + $1.frame.width }
        let totalSpacing = CGFloat(attributes.count - 1) * 7
        let totalContentWidth = totalWidth + totalSpacing
        
        let containerWidth = collectionView.bounds.width
        let padding = (containerWidth - totalContentWidth) / 2
        
        var currentX = max(0, padding)
        for attribute in attributes {
            attribute.frame.origin.x = currentX
            currentX += attribute.frame.width + 7
        }
    }
}
