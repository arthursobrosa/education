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
    
    // MARK: - Properties
    
    private var isFirstTimeShowing: Bool = true
    
    // MARK: - UI Properties
    
    private let onboarding1View = Onboarding1View()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = onboarding1View
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onboarding1View.reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isFirstTimeShowing {
            isFirstTimeShowing = false
            onboarding1View.animate()
        }
    }
    
    // MARK: - Methods
    
    func animate() {
        onboarding1View.animate()
    }
}
