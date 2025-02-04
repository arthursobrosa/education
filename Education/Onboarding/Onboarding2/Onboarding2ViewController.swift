//
//  Onboarding2ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class Onboarding2ViewController: UIViewController {
    // MARK: - Delegate to connect with Manager
    
    weak var delegate: OnboardingManagerDelegate? {
        didSet {
            onboarding2View.delegate = delegate
        }
    }
    
    // MARK: - Properties
    
    private var isFirstTimeShowing: Bool = true
    
    // MARK: - UI Properties
    
    private let onboarding2View = Onboarding2View()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = onboarding2View
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTimeShowing {
            isFirstTimeShowing = false
            onboarding2View.animate()
            return
        }
    }
}
