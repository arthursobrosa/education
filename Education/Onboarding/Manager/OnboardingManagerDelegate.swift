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
        if let _ = pageViewController.viewControllers?.first(where: { $0 is Onboarding4ViewController }) as? Onboarding4ViewController {
            skipAllPages()
            return
        }
        
        pageViewController.goToNextPage()
    }
    
    func goToPreviousPage() {
        pageViewController.goToPreviousPage()
    }
    
    func skipAllPages() {
        print(#function)
        coordinator?.showTabBar()
        UserDefaults.isFirstEntry = false
    }
}
