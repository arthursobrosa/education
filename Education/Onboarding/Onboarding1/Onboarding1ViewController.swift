//
//  Onboarding1ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class Onboarding1ViewController: UIViewController {
    // MARK: - Delegate to connect with Manager
    
    weak var delegate: OnboardingManagerDelegate? {
        didSet {
            onboarding1View.delegate = delegate
        }
    }
    
    // MARK: - UI Properties
    
    private let onboarding1View = Onboarding1View()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = onboarding1View
    }
}
