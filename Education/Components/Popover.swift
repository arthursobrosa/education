//
//  Popover.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/07/24.
//

import UIKit

class Popover: UIViewController {
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, contentSize: CGSize) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        modalPresentationStyle = .popover
        preferredContentSize = contentSize
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPresentationVC(sourceView: UIView?, permittedArrowDirections: UIPopoverArrowDirection, sourceRect: CGRect, delegate: (any UIPopoverPresentationControllerDelegate)?) {
        guard let presentationVC = popoverPresentationController else { return }

        presentationVC.sourceView = sourceView
        presentationVC.permittedArrowDirections = permittedArrowDirections
        presentationVC.sourceRect = sourceRect
        presentationVC.delegate = delegate
    }
}
