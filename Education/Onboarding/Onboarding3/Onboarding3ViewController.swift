//
//  Onboarding3ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class Onboarding3ViewController: UIViewController {
    // MARK: - Delegate to connect with Manager
    
    weak var delegate: OnboardingManagerDelegate? {
        didSet {
            onboarding3View.delegate = delegate
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var onboarding3View = Onboarding3View()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = onboarding3View
    }
}
