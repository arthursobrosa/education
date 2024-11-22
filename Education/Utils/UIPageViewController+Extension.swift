//
//  UIPageViewController+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

extension UIPageViewController {
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        
        setViewControllers([nextViewController], direction: .forward, animated: animated) { [weak self] completed in
            guard let self else { return }
            
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: completed)
        }
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        
        setViewControllers([previousViewController], direction: .reverse, animated: animated) { [weak self] completed in
            guard let self else { return }
            
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [previousViewController], transitionCompleted: completed)
        }
    }
}
