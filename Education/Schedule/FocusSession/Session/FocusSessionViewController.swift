//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit
import AVFoundation
import Combine

class FocusSessionViewController: UIViewController {
    // MARK: - Coordinator & ViewModel
    weak var coordinator: Dismissing?
    let viewModel: FocusSessionViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
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
        
        self.blockApps()
        self.setTabItems()
        self.updateViewLabels()
        self.setNavigationTitle()
        
        self.bindActivity()
    }
    
    private func bindActivity() {
        ActivityManager.shared.$timerState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerState in
                guard let self,
                      let timerState else { return }
                
                switch timerState {
                    case .starting:
                        self.start()
                    case .reseting:
                        self.restart()
                }
    
                self.updateButton(imageName: timerState.imageName)
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$timerSeconds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerSeconds in
                guard let self else { return }
                
                self.updateViewLabels()
                self.setNavigationTitle()
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$updateAfterBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateAfterBackground in
                guard let self,
                      updateAfterBackground else { return }
                
                self.restart()
                self.start()
                
                self.setNavigationTitle()
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$showEndAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showEndAlert in
                guard let self,
                      showEndAlert else { return }
                
                self.showEndTimeAlert()
                self.focusSessionView.redefineAnimation(timerDuration: 0, strokeEnd: 0)
            }
            .store(in: &self.cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.didTapFinishButton = false
        
        DispatchQueue.main.async {
            switch ActivityManager.shared.timerCase {
                case .timer, .pomodoro:
                    let strokeEnd = self.viewModel.getStrokeEnd()
                    self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
                default:
                    break
            }
            
            let timerState = ActivityManager.shared.timerState
            
            switch timerState {
                case .reseting:
                    self.focusSessionView.finishButton.isEnabled = true
                    self.focusSessionView.changeButtonAlpha()
                    self.setNavigationTitle()
                case nil:
                    ActivityManager.shared.timerState = .starting
                    self.setNavigationTitle()
                default:
                    break
            }
        }
    }
    
    private func blockApps() {
        guard ActivityManager.shared.blocksApps else { return }
        
        BlockAppsMonitor.shared.apllyShields()
    }
    
    private func setTabItems() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .label
        self.navigationItem.leftBarButtonItems = [dismissButton]
        
        switch ActivityManager.shared.timerCase {
            case .timer, .pomodoro:
                self.setVisibilityButton()
            default:
                break
        }
    }
    
    private func setVisibilityButton() {
        self.navigationItem.rightBarButtonItems?.removeAll()
        
        let imageName = ActivityManager.shared.isTimeCountOn ? "eye" : "eye.slash"
        
        let visibilityButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(visibilityButtonTapped))
        visibilityButton.tintColor = .label
        self.navigationItem.rightBarButtonItems = [visibilityButton]
    }
    
    @objc private func dismissButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
    
    @objc private func visibilityButtonTapped() {
        ActivityManager.shared.isTimeCountOn.toggle()
        
        self.updateViewLabels()
        self.setVisibilityButton()
    }
}

// MARK: - Auxiliar Methods
extension FocusSessionViewController {
    public func setNavigationTitle() {
        var title: String
        
        let isPaused = ActivityManager.shared.timerState == .reseting
        
        if let subject = ActivityManager.shared.subject {
            if ActivityManager.shared.isAtWorkTime {
                title = String(format: NSLocalizedString("subjectActivity", comment: ""), subject.unwrappedName)
            } else {
                title = String(localized: "interval")
            }
        } else {
            title = String(localized: "newActivity")
        }
        
        if isPaused {
            title = String(localized: "paused")
        }
        
        
        self.title = title
    }
    
    private func showEndTimeAlert() {
        let alertController = UIAlertController(title: String(localized: "timerAlertTitle"), message: String(localized: "timerAlertMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self else { return }

            self.finishAndDismiss()
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func updateViewLabels() {
        let timerString = ActivityManager.shared.isTimeCountOn ? self.viewModel.getTimerString() : String()
        
        self.focusSessionView.updateLabels(timerString: timerString)
    }
    
    private func handleTimerEnd() {
        self.focusSessionView.hidePauseResumeButton()
        
        if ActivityManager.shared.isAlarmOn {
            let audioService = AudioService()
            if let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
                audioService.playAudio(from: url)
            }
        }
        
        self.resetTimer()
        
        self.focusSessionView.resetAnimations()
        
        self.showEndTimeAlert()
    }
    
    private func startAnimation() {
        let timerSeconds = ActivityManager.shared.timerSeconds
        let isTimeCountOn = ActivityManager.shared.isTimeCountOn
        
        let timerDuration = Double(timerSeconds)
        let timerString = isTimeCountOn ? self.viewModel.getTimerString() : String()
        self.focusSessionView.startAnimation(timerDuration: timerDuration, timerString: timerString)
    }
    
    private func restartAnimation() {
        let timerSeconds = ActivityManager.shared.timerSeconds
        
        let timerDuration = Double(timerSeconds) + 1
        let strokeEnd = self.viewModel.getStrokeEnd()
        
        self.focusSessionView.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
    }
    
    private func updateButton(imageName: String) {
        self.focusSessionView.changePauseResumeImage(to: imageName)
    }
    
    private func resetTimer() {
        self.focusSessionView.resetAnimations()
    }
    
    private func start() {
        self.startAnimation()
    }
    
    private func restart() {
        self.resetTimer()
        self.restartAnimation()
    }
}
