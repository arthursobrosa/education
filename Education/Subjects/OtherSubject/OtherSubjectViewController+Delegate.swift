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
        self.showDeleteAlert()
    }
    
    func deleteTime() {
        self.viewModel.removeSubject(subject: nil)
        self.coordinator?.dismiss(animated: true)
    }
}
