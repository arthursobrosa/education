//
//  FocusImediateViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import Foundation
import UIKit

@objc
protocol FocusImediateDelegate: AnyObject {
    func closeButtonTapped()
    func subjectButtonTapped(indexPath: IndexPath?)
}

extension FocusImediateViewController: FocusImediateDelegate {
    func closeButtonTapped() {
        coordinator?.dismiss(animated: true)
    }

    func subjectButtonTapped(indexPath: IndexPath?) {
        guard let indexPath else { return }

        let row = indexPath.row
        let subject: Subject? = row == 0 ? nil : subjects[row - 1]

        var color: UIColor?
        if let subject {
            color = UIColor(named: subject.unwrappedColor)
        } else {
            color = UIColor(named: "defaultColor")
        }

        let newFocusSessionModel = FocusSessionModel(subject: subject, color: color)

        coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}
