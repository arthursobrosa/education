//
//  OnboardingManagerDelegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import Foundation

@objc
protocol OnboardingManagerDelegate: AnyObject {
    func goToNextPage()
    func goToPreviousPage()
    func skipAllPages()
}

extension OnboardingManagerViewController: OnboardingManagerDelegate {
    func goToNextPage() {
        pageViewController.goToNextPage()
    }
    
    func goToPreviousPage() {
        pageViewController.goToPreviousPage()
    }
    
    func skipAllPages() {
        coordinator?.showTabBar()
        UserDefaults.isFirstEntry = false
    }
}
