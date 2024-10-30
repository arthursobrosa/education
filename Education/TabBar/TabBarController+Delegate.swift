//
//  TabBarController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

// MARK: - Activity

@objc 
protocol TabBarDelegate: AnyObject {
    func addActivityView()
    func updateTimerSeconds()
    func removeActivityView()
    func didTapPlayButton()
    func activityViewTapped()
}

extension TabBarController: TabBarDelegate {
    func addActivityView() {
        updateTimerSeconds()
        activityView.subject = viewModel.activityManager.subject
        activityView.color = viewModel.activityManager.color

        view.addSubview(activityView)

        let isPaused = viewModel.activityManager.isPaused

        activityView.activityBarButton.setPauseResumeButton(isPaused: isPaused)

        let layersConfig = viewModel.activityManager.getLayersConfig()
        activityView.activityBarButton.setupLayers(with: layersConfig)

        if viewModel.activityManager.isProgressingActivityBar && !isPaused {
            activityView.activityBarButton.updatePauseResumeButton(isPaused: false)
            startAnimation()
        }
    }

    func updateTimerSeconds() {
        activityView.timerSeconds = viewModel.activityManager.timerSeconds
    }

    private func startAnimation() {
        let timerDuration = Double(viewModel.activityManager.timerSeconds)
        activityView.activityBarButton.startAnimation(timerDuration: timerDuration)
    }

    func stopAnimation() {
        activityView.activityBarButton.resetAnimations()
        let timerDuration = Double(viewModel.activityManager.timerSeconds)
        let strokeEnd = viewModel.activityManager.progress
        activityView.activityBarButton.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
    }

    func removeActivityView() {
        activityView.removeFromSuperview()
    }

    func didTapPlayButton() {
        guard viewModel.activityManager.isProgressingActivityBar else {
            activityViewTapped()
            viewModel.activityManager.isPaused.toggle()
            return
        }

        viewModel.activityManager.isPaused.toggle()

        let isPaused = viewModel.activityManager.isPaused

        if isPaused {
            stopAnimation()
        } else {
            startAnimation()
        }

        activityView.activityBarButton.updatePauseResumeButton(isPaused: isPaused)
    }

    func activityViewTapped() {
        selectedIndex = schedule.navigationController.tabBarItem.tag

        viewModel.activityManager.isProgressingActivityBar = false
        stopAnimation()
        schedule.showTimer(focusSessionModel: nil)

        if viewModel.activityManager.timerFinished {
            viewModel.activityManager.timerFinished = true
        }
    }
}
