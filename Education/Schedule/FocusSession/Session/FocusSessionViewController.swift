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
    
    // MARK: - Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Status bar hidden
    override var prefersStatusBarHidden: Bool {
        return self.viewModel.prefersStatusBarHidden
    }
    
    // MARK: - Properties
    let color: UIColor?
    
    lazy var focusSessionView: FocusSessionView = {
        let view = FocusSessionView(color: self.color)
        view.delegate = self
        view.isPaused = ActivityManager.shared.isPaused
        
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
        
        self.setCustomNavigationItems()
        self.bindActivity()
        self.setGestureRecognizer()
        self.blockApps()
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.focusSessionView.updateTimerTracker()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ActivityManager.shared.isShowingActivity = false
        
        switch ActivityManager.shared.timerCase {
            case .pomodoro:
                self.focusSessionView.showPomodoroLabel()
            default:
                break
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let strokeEnd = self.viewModel.getStrokeEnd()
            self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
            
            self.focusSessionView.setTitleLabel(for: ActivityManager.shared.subject)
        }
    }
    
    private func setCustomNavigationItems() {
        switch ActivityManager.shared.timerCase {
            case .timer, .pomodoro:
                self.focusSessionView.setVisibilityButton(isActive: ActivityManager.shared.isTimeCountOn)
            default:
                break
        }
        
        self.focusSessionView.setTitleLabel(for: ActivityManager.shared.subject)
    }
    
    private func bindActivity() {
        ActivityManager.shared.$isPaused
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPaused in
                guard let self else { return }
                
                switch ActivityManager.shared.timerCase {
                    case .stopwatch:
                        return
                    default:
                        break
                }
                
                if isPaused {
                    self.focusSessionView.resetAnimations()
                    
                    let timerSeconds = ActivityManager.shared.timerSeconds
                    
                    let timerDuration = Double(timerSeconds)
                    let strokeEnd = self.viewModel.getStrokeEnd()
                    
                    self.focusSessionView.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
                } else {
                    let timerSeconds = ActivityManager.shared.timerSeconds
                    self.focusSessionView.startAnimation(timerDuration: Double(timerSeconds))
                    
                    self.updateViewLabels()
                }
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$timerSeconds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerSeconds in
                guard let self,
                      !self.viewModel.didTapFinish else { return }
                
                self.updateViewLabels()
                
                self.focusSessionView.setTitleLabel(for: ActivityManager.shared.subject)
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$timerDidFinish
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerDidFinish in
                guard let self else { return }
                
                guard timerDidFinish else { return }
                
                self.focusSessionView.redefineAnimation(timerDuration: 0, strokeEnd: 0)
                self.focusSessionView.resetAnimations()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showEndTimeAlert()
                    self.removeTapGestureRecognizer()
                }
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$isAtWorkTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAtWorkTime in
                guard let self else { return }
                
                isAtWorkTime ? self.blockApps() : BlockAppsMonitor.shared.removeShields()
                
                let strokeEnd = self.viewModel.getStrokeEnd()
                self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
            }
            .store(in: &self.cancellables)
        
        ActivityManager.shared.$updateAfterBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateAfterBackground in
                guard let self else { return }
                
                guard updateAfterBackground else { return }
                
                switch ActivityManager.shared.timerCase {
                    case .stopwatch:
                        return
                    default:
                        break
                }
                
                let strokeEnd = self.viewModel.getStrokeEnd()
                self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
                
                let timerSeconds = ActivityManager.shared.timerSeconds
                self.focusSessionView.startAnimation(timerDuration: Double(timerSeconds))
                
                self.focusSessionView.setTitleLabel(for: ActivityManager.shared.subject)
            }
            .store(in: &self.cancellables)
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func removeTapGestureRecognizer() {
            if let gestureRecognizers = self.view.gestureRecognizers {
                for gesture in gestureRecognizers {
                    if gesture is UITapGestureRecognizer {
                        self.view.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    
    @objc func viewWasTapped() {
        self.viewModel.prefersStatusBarHidden.toggle()
        self.focusSessionView.changeButtonsIsHidden(self.viewModel.prefersStatusBarHidden)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func blockApps() {
        guard ActivityManager.shared.blocksApps,
              !ActivityManager.shared.isPaused,
              ActivityManager.shared.isAtWorkTime else { return }
        
        BlockAppsMonitor.shared.apllyShields()
    }
}

// MARK: - Auxiliar Methods
extension FocusSessionViewController {
    private func showEndTimeAlert() {
        self.focusSessionView.showEndNotification(true)
    }
    
    public func updateViewLabels() {
        let timerString = ActivityManager.shared.isTimeCountOn ? self.viewModel.getTimerString() : String()
        
        self.focusSessionView.updateLabels(timerString: timerString)
    }
    
    private func handleTimerEnd() {
        self.focusSessionView.disablePauseResumeButton()
        
        if ActivityManager.shared.isAlarmOn {
            let audioService = AudioService()
            if let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
                audioService.playAudio(from: url)
            }
        }
        
        self.focusSessionView.resetAnimations()
        
        self.showEndTimeAlert()
        self.removeTapGestureRecognizer()
    }
}
