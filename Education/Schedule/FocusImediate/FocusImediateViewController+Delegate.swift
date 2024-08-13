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
        ActivityManager.shared.changeActivityVisibility(isShowing: true)
        
        self.coordinator?.dismiss()
    }
    
    func subjectButtonTapped(indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        let row = indexPath.row
        let subject: Subject? = row >= self.subjects.count ? nil : self.subjects[row]
        
        let focusSessionModel = FocusSessionModel(isPaused: false, totalSeconds: 0, timerSeconds: 0, timerCase: .timer, subject: subject, isAtWorkTime: true, blocksApps: false, isTimeCountOn: true, isAlarmOn: false, color: self.color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: focusSessionModel)
    }
}
