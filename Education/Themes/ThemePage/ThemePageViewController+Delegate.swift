//
//  ThemePageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol ThemePageDelegate: AnyObject {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl)
}

extension ThemePageViewController: ThemePageDelegate {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let limits = self.viewModel.limits.map { String($0) }
        let selectedLimit = String(self.viewModel.selectedLimit)
        
        for (index, limit) in limits.enumerated() {
            let action = UIAction(title: "\(String(localized: "lastPlural")) \(limit)") { _ in
                self.viewModel.selectedLimit = self.viewModel.limits[index]
                self.setChart()
            }
            
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            if limit == selectedLimit {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
}
