//
//  CustomPushTransition.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class CustomPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toVC.view.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
