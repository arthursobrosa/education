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
    func getSelectedTestDateString(for row: Int) -> String
}

extension ThemePageViewController: ThemePageDelegate {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let limits = self.viewModel.limits.map { String($0) }
        let selectedLimit = String(self.viewModel.selectedLimit)
        
        for (index, limit) in limits.enumerated() {
            let action = UIAction(title: "\(String(localized: "lastPlural")) \(limit)") { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.selectedLimit = self.viewModel.limits[index]
                self.setChart()
            }
            
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            if limit == selectedLimit {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    func addTestButtonTapped() {
        self.coordinator?.showTestPage(theme: self.viewModel.theme, test: nil)
    }
    
    func getSelectedTestDateString(for row: Int) -> String {
        let count = viewModel.tests.value.count - 1
        let test = viewModel.tests.value[count - row]
        return viewModel.getDateString(from: test)
    }
}
