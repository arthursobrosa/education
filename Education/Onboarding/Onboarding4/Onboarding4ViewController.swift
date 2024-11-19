//
//  Onboarding4ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import UIKit

class Onboarding4ViewController: UIViewController {
    // MARK: - View Model
    
    let viewModel: OnboardingManagerViewModel
    
    // MARK: - Delegate to connect with Manager
    
    weak var delegate: OnboardingManagerDelegate? {
        didSet {
            onboarding4View.delegate = delegate
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var onboarding4View = Onboarding4View()
    
    // MARK: - Initializer
    
    init(viewModel: OnboardingManagerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = onboarding4View
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.createSubjects()
        onboarding4View.subjects = viewModel.formattedSubjects()
    }
}
