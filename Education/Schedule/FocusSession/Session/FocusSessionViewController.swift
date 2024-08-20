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
        
        self.blockApps()
        self.setTabItems()
        self.setNavigationTitle()
        
        self.bindActivity()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ActivityManager.shared.isShowingActivity = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let strokeEnd = self.viewModel.getStrokeEnd()
            self.focusSessionView.setupLayers(strokeEnd: strokeEnd)
            
            self.setNavigationTitle()
        }
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
                
                self.setNavigationTitle()
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
                }
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
                
                self.setNavigationTitle()
            }
            .store(in: &self.cancellables)
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
        
        let isPaused = ActivityManager.shared.isPaused
        
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

            self.didTapFinishButton()
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
        
        self.focusSessionView.resetAnimations()
        
        self.showEndTimeAlert()
    }
}
