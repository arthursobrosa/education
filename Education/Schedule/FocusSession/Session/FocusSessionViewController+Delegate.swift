//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import UIKit

@objc protocol FocusSessionDelegate: AnyObject {
    func dismissButtonTapped()
    func eyeButtonTapped()
    func getTitleString() -> NSAttributedString?
    func pauseResumeButtonTapped()
    func didTapRestartButton()
    func didRestart()
    func didTapFinishButton()
    func didFinish()
    func cancelButtonPressed()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func dismissButtonTapped() {
        viewModel.changePauseStatus()
        
        coordinator?.dismiss(animated: true)
    }
    
    func eyeButtonTapped() {
        viewModel.activityManager.isTimeCountOn.toggle()
        
        updateViewLabels()
        let isTimerVisible = viewModel.activityManager.isTimeCountOn
        focusSessionView.setEyeButton(isActive: isTimerVisible)
    }
    
    func getTitleString() -> NSAttributedString? {
        guard let subject = viewModel.activityManager.subject else { return nil }
        
        let attributedString = NSMutableAttributedString()
        
        let activityString = NSAttributedString(string: "\(String(localized: "subjectActivity"))\n", attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor : UIColor.label.withAlphaComponent(0.7)])
        let subjectString = NSAttributedString(string: subject.unwrappedName, attributes: [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold), .foregroundColor : UIColor.label.withAlphaComponent(0.85)])
        
        attributedString.append(activityString)
        attributedString.append(subjectString)
        
        return attributedString
    }
    
    func pauseResumeButtonTapped() {
        if viewModel.shouldChangeVisibility() {
            focusSessionView.changeButtonsVisibility(isHidden: viewModel.prefersStatusBarHidden)
        }
        
        viewModel.pauseResumeButtonTapped()
        
        focusSessionView.updatePauseResumeButton(isPaused: viewModel.activityManager.isPaused)
    }
    
    func didTapRestartButton() {
        focusSessionView.alertView.configure(with: .restart, atSuperview: focusSessionView)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }
    
    func didRestart() {
        focusSessionView.changeAlertVisibility(isShowing: false)
        focusSessionView.updatePauseResumeButton(isPaused: false)
        viewModel.activityManager.restartActivity()
    }
    
    func didTapFinishButton() {
        focusSessionView.alertView.configure(with: .finishTimer, atSuperview: focusSessionView)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }
    
    func didFinish() {
        viewModel.activityManager.saveFocusSesssion()
        viewModel.didTapFinish = true
        
        coordinator?.dismiss(animated: true)
        
        viewModel.unblockApps()
    }
    
    func cancelButtonPressed() {
        focusSessionView.changeAlertVisibility(isShowing: false)
    }
}
