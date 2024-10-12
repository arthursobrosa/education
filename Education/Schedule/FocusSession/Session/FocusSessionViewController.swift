//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit
import AVFoundation

class FocusSessionViewController: UIViewController {
    // MARK: - Coordinator & ViewModel
    weak var coordinator: Dismissing?
    let viewModel: FocusSessionViewModel
    
    // MARK: - Status bar hidden
    override var prefersStatusBarHidden: Bool {
        return viewModel.prefersStatusBarHidden
    }
    
    // MARK: - Properties
    let color: UIColor?
    
    lazy var focusSessionView: FocusSessionView = {
        let view = FocusSessionView(color: self.color)
        view.delegate = self
        view.updatePauseResumeButton(isPaused: viewModel.activityManager.isPaused)
        
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
        
        view = focusSessionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomNavigationItems()
        bindActivity()
        setGestureRecognizer()
        viewModel.blockApps()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.activityManager.isShowingActivityBar = false
        
        let timerCase = viewModel.activityManager.timerCase
        
        switch timerCase {
            case .pomodoro:
                focusSessionView.showPomodoroLabel()
            default:
                break
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.setTitle()
            self.setupViewLayers()
            self.updateViewLabels()
            
            if case .stopwatch = timerCase { return }
            
            let isPaused = viewModel.activityManager.isPaused
            guard !isPaused else { return }
            
            let timerSeconds = viewModel.activityManager.timerSeconds
            self.focusSessionView.startAnimation(timerDuration: Double(timerSeconds))
        }
    }
}

// MARK: - Navigation Items
extension FocusSessionViewController {
    private func setCustomNavigationItems() {
        let timerCase = viewModel.activityManager.timerCase
        
        switch timerCase {
            case .timer, .pomodoro:
                let isTimerVisible = viewModel.activityManager.isTimeCountOn
                focusSessionView.setEyeButton(isActive: isTimerVisible)
            default:
                break
        }
    }
    
    private func setTitle() {
        focusSessionView.setTitleLabel()
    }
}

// MARK: - View Model Binding
extension FocusSessionViewController {
    private func bindActivity() {
        viewModel.pauseStatusDidChange = { [weak self] isPaused in
            guard let self else { return }
            
            let timerSeconds = viewModel.activityManager.timerSeconds
            
            if isPaused {
                self.focusSessionView.resetAnimations()
                
                let timerDuration = Double(timerSeconds)
                let strokeEnd = self.viewModel.getStrokeEnd()
                
                self.focusSessionView.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
            } else {
                self.focusSessionView.startAnimation(timerDuration: Double(timerSeconds))
            }
        }
        
        viewModel.timerSecondsDidChange = { [weak self] in
            guard let self else { return }
            
            self.updateViewLabels()
            
            self.setTitle()
        }
        
        viewModel.timerFinishedPropertyChanged = { [weak self] in
            guard let self else { return }
            
            self.focusSessionView.redefineAnimation(timerDuration: 0, strokeEnd: 0)
            self.focusSessionView.resetAnimations()
            self.focusSessionView.disablePauseResumeButton()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showEndTimeAlert()
                self.removeTapGestureRecognizer()
            }
        }
        
        viewModel.isAtWorkTimeDidChange = { [weak self] isAtWorkTime in
            guard let self else { return }
            
            isAtWorkTime ? self.viewModel.blockApps() : self.viewModel.unblockApps()
            
            self.setupViewLayers()
        }
        
        viewModel.updateAfterBackgroundPropertyDidChange = { [weak self] in
            guard let self else { return }
            
            self.setupViewLayers()
            
            let timerSeconds = self.viewModel.activityManager.timerSeconds
            self.focusSessionView.startAnimation(timerDuration: Double(timerSeconds))
            
            self.setTitle()
        }
    }
}

// MARK: - View Tapping
extension FocusSessionViewController {
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func removeTapGestureRecognizer() {
        let gestureRecognizers = view.gestureRecognizers?.compactMap({ $0 as? UITapGestureRecognizer })
        
        gestureRecognizers?.forEach({ view.removeGestureRecognizer($0) })
    }
    
    @objc func viewWasTapped() {
        viewModel.prefersStatusBarHidden.toggle()
        focusSessionView.changeButtonsVisibility(isHidden: viewModel.prefersStatusBarHidden)
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Auxiliar Methods
extension FocusSessionViewController {
    private func setupViewLayers() {
        let layersConfig = viewModel.getLayersConfig()
        
        focusSessionView.setupLayers(with: layersConfig)
    }
    
    private func showEndTimeAlert() {
        let timerCase = viewModel.activityManager.timerCase
        var alertCase: FocusStatusAlertCase
        
        switch timerCase {
            case .timer:
                let subject = viewModel.activityManager.subject
                alertCase = .finishingTimerCase(subject: subject)
            case .pomodoro:
                let isLastPomodoro = viewModel.activityManager.isLastPomodoro()
                
                if isLastPomodoro {
                    let subject = viewModel.activityManager.subject
                    alertCase = .finishingTimerCase(subject: subject)
                } else {
                    let pomodoroString = viewModel.getPomodoroString()
                    let isAtWorkTime = viewModel.activityManager.isAtWorkTime
                    alertCase = .finishingPomodoroCase(pomodoroString: pomodoroString, isAtWorkTime: isAtWorkTime)
                }
            case .stopwatch:
                return
        }
        
        focusSessionView.statusAlertView.configure(with: alertCase, atSuperview: focusSessionView)
        focusSessionView.changeAlertVisibility(isShowing: true)
    }
    
    func updateViewLabels() {
        let isTimerVisible = viewModel.activityManager.isTimeCountOn
        let timerString = isTimerVisible ? viewModel.getTimerString() : String()
        let pomodoroString = viewModel.getPomodoroString()
        focusSessionView.updateTimerLabels(timerString: timerString, pomodoroString: pomodoroString)
    }
    
    #warning("handle timer finished audio")
//    private func handleTimerEnd() {
//        focusSessionView.disablePauseResumeButton()
//        
//        let isAlarmOn = viewModel.activityManager.isAlarmOn
//        if isAlarmOn {
//            let audioService = AudioService()
//            if let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
//                audioService.playAudio(from: url)
//            }
//        }
//        
//        focusSessionView.resetAnimations()
//        
//        showEndTimeAlert()
//        removeTapGestureRecognizer()
//    }
}
