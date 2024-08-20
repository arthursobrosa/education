//
//  FocusImediateViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import Foundation

protocol FocusImediateDelegate: AnyObject {
    func cancelButtonTapped()
    func subjectButtonTapped(indexPath: IndexPath?)
}

extension FocusImediateViewController: FocusImediateDelegate {
    func cancelButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func subjectButtonTapped(indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        let row = indexPath.row
        let subject: Subject? = row >= self.subjects.count ? nil : self.subjects[row]
        
        let newFocusSessionModel = FocusSessionModel(isPaused: false, subject: subject, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}
