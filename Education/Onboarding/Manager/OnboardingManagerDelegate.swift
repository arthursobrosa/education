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
        if let onboarding3ViewController = pageViewController.viewControllers?.first(where: { $0 is Onboarding3ViewController }) as? Onboarding3ViewController {
            
            if onboarding3ViewController.viewModel.selectedSubjectNames.isEmpty {
                showOnboarding3Alert()
                return
            }
            
            onboarding3ViewController.viewModel.createSubjects()
        }
        
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
        coordinator?.showTabBar()
        UserDefaults.isFirstEntry = false
    }
}
