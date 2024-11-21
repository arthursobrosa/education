//
//  Onboarding3ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class Onboarding3ViewController: UIViewController {
    // MARK: - View model
    let viewModel: OnboardingManagerViewModel
    
    // MARK: - Delegate to connect with Manager
    
    weak var delegate: OnboardingManagerDelegate? {
        didSet {
            onboarding3View.delegate = delegate
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var onboarding3View: Onboarding3View = {
        let view = Onboarding3View()
        view.onboarding3Delegate = self
        return view
    }()
    
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
        view = onboarding3View
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.subjectNames.bind { [weak self] subjectNames in
            guard let self else { return }
            
            self.onboarding3View.subjectNames = subjectNames
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetSelectedNames()
        viewModel.fetchSubjectNames()
        viewModel.removeSubjects()
    }
}
