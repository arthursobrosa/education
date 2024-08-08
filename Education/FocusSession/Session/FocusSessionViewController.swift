//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit
import AVFoundation

class FocusSessionViewController: UIViewController {
    // MARK: - BlockApps Model
    var model = BlockAppsMonitor.shared
    
    // MARK: - ViewModel
    let viewModel: FocusSessionViewModel
    
    // MARK: - Properties
    let color: UIColor?
    
    private lazy var focusSessionView: FocusSessionView = {
        let view = FocusSessionView(color: self.color)
        view.delegate = self
        return view
    }()
    
    // MARK: - Initializer
    init(viewModel: FocusSessionViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.focusSessionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabItems()
        self.updateViewLabels()
        self.setNavigationTitle(isPaused: false)
        
        self.viewModel.timerSeconds.bind { [weak self] timerSeconds in
            guard let self = self else { return }
            
            self.updateViewLabels()
            
            if timerSeconds <= 0 {
                switch self.viewModel.timerCase {
                    case .stopwatch:
                        return
                    case .timer:
                        self.handleTimerEnd()
                    case .pomodoro:
                        if self.viewModel.isAtWorkTime {
                            if self.viewModel.currentLoop >= self.viewModel.numberOfLoops - 1 {
                                self.handleTimerEnd()
                                return
                            }
                            
                            self.viewModel.isAtWorkTime.toggle()
                            
                            self.viewModel.totalSeconds = self.viewModel.restTime
                            self.viewModel.timerSeconds.value = self.viewModel.totalSeconds
                        } else {
                            self.viewModel.currentLoop += 1
                            self.viewModel.isAtWorkTime.toggle()
                            
                            self.viewModel.totalSeconds = self.viewModel.workTime
                            self.viewModel.timerSeconds.value = self.viewModel.totalSeconds
                        }
                        
                        self.viewModel.timerState.value = .reseting
                        self.viewModel.timerState.value = .starting
                        
                        let isPaused = !(self.viewModel.timerState.value == .starting)
                        self.setNavigationTitle(isPaused: isPaused)
                }
            }
        }
        
        self.viewModel.timerState.bind { [weak self] timerState in
            guard let self = self else { return }
            
            guard let timerState = timerState else { return }
            
            switch timerState {
                case .starting:
                    self.start()
                case .reseting:
                    self.restart()
            }
            
            self.updateButton(imageName: timerState.imageName)
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.timeInBackground.bind { [weak self] timeInBackground in
                guard let self = self else { return }
                
                switch self.viewModel.timerCase {
                    case .stopwatch:
                        if timeInBackground > 0 && self.viewModel.timerState.value == .starting {
                            self.viewModel.timerSeconds.value += timeInBackground
                            
                            self.restart()
                            self.start()
                        }
                    case .timer, .pomodoro:
                        if timeInBackground > 0 && self.viewModel.timerState.value == .starting {
                            self.viewModel.timerSeconds.value -= timeInBackground
                            
                            self.restart()
                            self.start()
                        }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.didTapFinishButton = false
        
        DispatchQueue.main.async {
            switch self.viewModel.timerCase {
                case .timer, .pomodoro:
                    let strokeEnd = self.viewModel.getStrokeEnd()
                    self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
                default:
                    break
            }
            
            let timerState = self.viewModel.timerState.value
            
            switch timerState {
                case .reseting:
                    self.focusSessionView.finishButton.isEnabled = true
                    self.focusSessionView.changeButtonAlpha()
                    self.setNavigationTitle(isPaused: true)
                case nil:
                    self.viewModel.timerState.value = .starting
                    self.setNavigationTitle(isPaused: false)
                default:
                    break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.timerState.value = .reseting
    }
    
    private func setTabItems() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .label
        self.navigationItem.leftBarButtonItems = [dismissButton]
        
        switch self.viewModel.timerCase {
            case .timer, .pomodoro:
                self.setVisibilityButton()
            default:
                break
        }
    }
    
    private func setVisibilityButton() {
        self.navigationItem.rightBarButtonItems?.removeAll()
        
        let imageName = self.viewModel.isVisible ? "eye" : "eye.slash"
        
        let visibilityButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(visibilityButtonTapped))
        visibilityButton.tintColor = .label
        self.navigationItem.rightBarButtonItems = [visibilityButton]
    }
    
    @objc private func dismissButtonTapped() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc private func visibilityButtonTapped() {
        self.viewModel.isVisible.toggle()
        
        self.updateViewLabels()
        self.setVisibilityButton()
    }
    
    func finishAndDismiss() {
        self.viewModel.saveFocusSession()
        self.viewModel.didTapFinishButton = true
        
        ActivityManager.shared.isShowingActivity = false
        
        self.navigationController?.dismiss(animated: true)
    }
}

// MARK: - Auxiliar Methods
extension FocusSessionViewController {
    public func setNavigationTitle(isPaused: Bool) {
        var title: String
        
        if isPaused {
            title = "Paused"
        } else if let subject = self.viewModel.subject {
            title = "\(subject.unwrappedName) activity"
        } else {
            title = "New activity"
            
            switch self.viewModel.timerCase {
                case .pomodoro:
                    if !self.viewModel.isAtWorkTime {
                        title = "Interval"
                    }
                default:
                    break
            }
        }
        
        self.title = title
    }
    
    private func showEndTimeAlert() {
        let alertController = UIAlertController(title: String(localized: "timerAlertTitle"), message: String(localized: "timerAlertMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.finishAndDismiss()
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func updateViewLabels() {
        let timerString = self.viewModel.isVisible ? self.viewModel.getTimerString() : String()
        
        self.focusSessionView.updateLabels(timerString: timerString)
    }
    
    private func handleTimerEnd() {
        self.focusSessionView.hidePauseResumeButton()
        
        let audioService = AudioService()
        if let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            audioService.playAudio(from: url)
        }
        
        self.resetTimer()
        
        self.focusSessionView.resetAnimations()
        
        self.showEndTimeAlert()
    }
    
    private func startAnimation() {
        let timerDuration = Double(self.viewModel.timerSeconds.value)
        let timerString = self.viewModel.getTimerString()
        self.focusSessionView.startAnimation(timerDuration: timerDuration, timerString: timerString)
    }
    
    private func restartAnimation() {
        let timerDuration = Double(self.viewModel.timerSeconds.value) + 1
        let strokeEnd = self.viewModel.getStrokeEnd()
        
        self.focusSessionView.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
    }
    
    private func updateButton(imageName: String) {
        self.focusSessionView.changePauseResumeImage(to: imageName)
    }
    
    private func resetTimer() {
        self.viewModel.timer.invalidate()
        self.focusSessionView.resetAnimations()
    }
    
    private func start() {
        self.startAnimation()
        self.viewModel.startTimer()
    }
    
    private func restart() {
        self.resetTimer()
        self.restartAnimation()
    }
}
