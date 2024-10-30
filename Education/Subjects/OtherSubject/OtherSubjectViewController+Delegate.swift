//
//  OtherSubjectViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/09/24.
//

import Foundation

protocol OtherSubjectDelegate: AnyObject {
    func deleteOtherSubjectTime()
}

extension OtherSubjectViewController: OtherSubjectDelegate {
    func deleteOtherSubjectTime() {
        showDeleteAlert()
    }

    func deleteTime() {
        viewModel.removeSubject(subject: nil)
        coordinator?.dismiss(animated: true)
    }
}
