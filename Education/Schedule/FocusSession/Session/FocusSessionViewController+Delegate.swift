//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import UIKit

@objc 
protocol FocusSessionDelegate: AnyObject {
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
    func didExtend()
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
        guard let subjectName = viewModel.getFormatterSubjectName() else { return nil }

        let attributedString = NSMutableAttributedString()

        let mediumFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        let semiboldFont: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold)
        let activityString = NSAttributedString(string: "\(String(localized: "subjectActivity"))\n", attributes: [.font: mediumFont, .foregroundColor: UIColor.label.withAlphaComponent(0.7)])
        let subjectString = NSAttributedString(string: subjectName, attributes: [.font: semiboldFont, .foregroundColor: UIColor.label.withAlphaComponent(0.85)])

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
        let alertCase: AlertCase = .restartingCase
        let alertConfig = getAlertConfig(with: alertCase)
        focusSessionView.statusAlertView.config = alertConfig
        focusSessionView.statusAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        focusSessionView.statusAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }

    func didTapFinishButton() {
        let alertCase: AlertCase = .finishingEarlyCase
        let alertConfig = getAlertConfig(with: alertCase)
        focusSessionView.statusAlertView.config = alertConfig
        focusSessionView.statusAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        focusSessionView.statusAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }

    func didRestart() {
        viewModel.activityManager.restartActivity()
    }

    func didFinish() {
        viewModel.stopAlarm()
        viewModel.didTapFinish = true
        viewModel.activityManager.computeTotalTime()
        coordinator?.showFocusEnd(activityManager: viewModel.activityManager)
        viewModel.unblockApps()
    }

    func didStartNextPomodoro() {
        viewModel.stopAlarm()
        viewModel.activityManager.continuePomodoro()
    }

    func didCancel() {
        focusSessionView.changeAlertVisibility(isShowing: false)
    }

    func didTapExtendButton() {
        viewModel.stopAlarm()
        
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

    func didExtend() {
        let hours = focusSessionView.extensionAlertView.selectedHours
        let minutes = focusSessionView.extensionAlertView.selectedMinutes
        let extendedTime = viewModel.getExtendedTime(hours: hours, minutes: minutes)
        let timerCase = viewModel.activityManager.timerCase

        switch timerCase {
        case .timer:
            viewModel.activityManager.originalTime = viewModel.activityManager.totalSeconds
        case let .pomodoro(workTime, restTime, _):
            let isAtWorkTime = viewModel.activityManager.isAtWorkTime
            viewModel.activityManager.originalTime = isAtWorkTime ? workTime : restTime
            viewModel.activityManager.updatePomodoroAfterExtension(seconds: extendedTime)
        case .stopwatch:
            break
        }

        focusSessionView.extensionAlertView.isHidden = true
        viewModel.activityManager.extendTimer(in: extendedTime)
    }

    func didCancelExtend() {
        focusSessionView.extensionAlertView.isHidden = true
    }
}
