//
//  CustomPopTransition.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class CustomPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromVC.view.alpha = 0.0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
