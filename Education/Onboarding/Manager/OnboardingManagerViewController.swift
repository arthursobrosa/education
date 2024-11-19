//
//  OnboardingManagerViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class OnboardingManagerViewController: UIViewController {
    // MARK: - Coordinator
    
    weak var coordinator: ShowingTabBar?
    
    // MARK: - Properties
    
    var currentIndex = 0
    let pages: [UIViewController]
    
    // MARK: - UI Properties
    
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        return pageVC
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers?.forEach { $0.cornerRadius = 10 }
        progressView.subviews.forEach { $0.clipsToBounds = true }
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // MARK: - Initializer
    
    init(pages: [UIViewController]) {
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardOberservers()
    }
    
    // MARK: - Methods
    
    private func updateProgress() {
        let progress = Float(currentIndex + 1) / Float(pages.count)
        progressView.setProgress(progress, animated: true)
    }
    
    private func addKeyboardOberservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardChangedFirstResponder(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            progressView.isHidden = true
        case UIResponder.keyboardWillHideNotification:
            progressView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - UI Setup

extension OnboardingManagerViewController: ViewCodeProtocol {
    func setupUI() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        setupProgressView()
        updateProgress()
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = .bluePicker
        progressView.trackTintColor = .TOGGLE_BG
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -41),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: 21 / 300),
        ])
    }
}

// MARK: - Page View Data Source and Delegate

extension OnboardingManagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            currentIndex = index
            updateProgress()
        }
    }
}

// MARK: - Preview

#Preview {
    let coordinator = OnboardingManagerCoordinator(
        navigationController: UINavigationController(),
        activityManager: nil,
        blockingManager: nil,
        notificationService: nil
    )
    coordinator.start()
    return coordinator.navigationController
}
