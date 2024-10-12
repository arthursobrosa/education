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
    func didTapFinishButton()
    func didRestart()
    func didFinish()
    func didStartNextPomodoro()
    func didCancel()
    func didTapExtendButton()
    func didExtendTimer()
    func didExtendPomodoro()
    func didCancelExtend()
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
        focusSessionView.statusAlertView.configure(with: .restartingCase, atSuperview: focusSessionView)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }
    
    func didTapFinishButton() {
        focusSessionView.statusAlertView.configure(with: .finishingEarlyCase, atSuperview: focusSessionView)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }
    
    func didRestart() {
        focusSessionView.changeAlertVisibility(isShowing: false)
        focusSessionView.updatePauseResumeButton(isPaused: false)
        viewModel.activityManager.restartActivity()
    }
    
    func didFinish() {
        viewModel.activityManager.saveFocusSesssion()
        viewModel.didTapFinish = true
        
        coordinator?.dismiss(animated: true)
        
        viewModel.unblockApps()
    }
    
    func didStartNextPomodoro() {
        focusSessionView.changeAlertVisibility(isShowing: false)
        focusSessionView.updatePauseResumeButton(isPaused: false)
        viewModel.activityManager.continuePomodoroTimer()
        focusSessionView.enablePauseResumeButton()
        setGestureRecognizer()
    }
    
    func didCancel() {
        focusSessionView.changeAlertVisibility(isShowing: false)
    }
    
    func didTapExtendButton() {
        var focusExtensionAlertCase: FocusExtensionAlertCase
        let timerCase = viewModel.activityManager.timerCase
        
        switch timerCase {
            case .timer:
                focusExtensionAlertCase = .timer
            case .pomodoro:
                let isAtWorkTime = viewModel.activityManager.isAtWorkTime
                focusExtensionAlertCase = .pomodoro(isAtWorkTime: isAtWorkTime)
            case .stopwatch:
                return
        }
        
        focusSessionView.extensionAlertView.isHidden = false
        focusSessionView.extensionAlertView.configure(with: focusExtensionAlertCase, atSuperview: focusSessionView)
    }
    
    func didExtendTimer() {
        
    }
    
    func didExtendPomodoro() {
        //
    }
    
    func didCancelExtend() {
        focusSessionView.extensionAlertView.isHidden = true
    }
}
