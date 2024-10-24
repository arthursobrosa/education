//
//  ThemePageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

@objc protocol ThemePageDelegate: AnyObject {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl)
    func addTestButtonTapped()
}

extension ThemePageViewController: ThemePageDelegate {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let limits = self.viewModel.limits.map { String($0) }
        let selectedLimit = String(self.viewModel.selectedLimit)
        
        for (index, limit) in limits.enumerated() {
            let titleString = "\(String(localized: "lastPlural")) \(limit)"
            
            segmentedControl.insertSegment(withTitle: titleString, at: index, animated: false)
            
            if limit == selectedLimit {
                segmentedControl.selectedSegmentIndex = index
            }
        }
        
        let fontRegular = UIFont(name: Fonts.darkModeOnRegular, size: 13)
        let fontBold = UIFont(name: Fonts.darkModeOnSemiBold, size: 13)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemText,
                .font: fontRegular ?? UIFont.systemFont(ofSize: 13)
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: fontBold ?? UIFont.systemFont(ofSize: 13)
        ]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    func addTestButtonTapped() {
        self.coordinator?.showTestPage(theme: self.viewModel.theme, test: nil)
    }
}
