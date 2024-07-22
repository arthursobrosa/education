//
//  ThemePageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit
import SwiftUI

protocol ThemePageDelegate: AnyObject {
    func setLimitsPicker(_ picker: UISegmentedControl)
}

extension ThemePageViewController: ThemePageDelegate {
    func setLimitsPicker(_ picker: UISegmentedControl) {
        let limits = self.viewModel.limits.map { String($0) }
        let selectedLimit = String(self.viewModel.selectedLimit)
        
        for (index, limit) in limits.enumerated() {
            let action = UIAction(title: limit) { _ in
                self.viewModel.selectedLimit = self.viewModel.limits[index]
            }
            
            picker.insertSegment(action: action, at: index, animated: false)
            
            if limit == selectedLimit {
                picker.selectedSegmentIndex = index
            }
        }
    }
}
