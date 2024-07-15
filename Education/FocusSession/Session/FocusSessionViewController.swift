//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class FocusSessionViewController: UIViewController {
    // MARK: - BlockApps Model
    var model = BlockAppsMonitor.shared
    
    // MARK: - Coordinator and ViewModel
    weak var coordinator: Dismissing?
    let viewModel: FocusSessionViewModel
    
    // MARK: - Properties
    private lazy var focusSessionView: FocusSessionView = {
        let view = FocusSessionView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Initializer
    init(viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
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
        
        self.updateViewLabels()
        
        self.viewModel.timerSeconds.bind { [weak self] timerSeconds in
            guard let self = self else { return }
            
            self.updateViewLabels()
            
            if timerSeconds <= 0 {
                self.handleTimerEnd()
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
                
                if timeInBackground > 0 && self.viewModel.timerState.value == .starting {
                    self.viewModel.timerSeconds.value -= timeInBackground
                    
                    self.restart()
                    self.start()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if self.viewModel.timerState.value == nil {
                self.focusSessionView.setupLayers()
                self.viewModel.timerState.value = .starting
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.timerState.value = .reseting
    }
}

// MARK: - Private Methods
private extension FocusSessionViewController {
    func showEndTimeAlert() {
        let alertController = UIAlertController(title: "Time's up!", message: "Your timer is finished", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.viewModel.saveFocusSession()
            self.coordinator?.dismiss()
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func updateViewLabels() {
        let timerString = self.viewModel.getTimerString()
        
        self.focusSessionView.updateLabels(timerString: timerString)
    }
    
    func handleTimerEnd() {
        self.focusSessionView.hidePauseResumeButton()
        
        self.resetTimer()
        
        self.focusSessionView.resetAnimations()
        
        self.showEndTimeAlert()
    }
    
    func startAnimation() {
        let timerDuration = Double(self.viewModel.timerSeconds.value)
        let timerString = self.viewModel.getTimerString()
        self.focusSessionView.startAnimation(timerDuration: timerDuration, timerString: timerString)
    }
    
    func restartAnimation() {
        let timerDuration = Double(self.viewModel.timerSeconds.value) + 1
        let strokeEnd = self.viewModel.getStrokeEnd()
        
        self.focusSessionView.redefineAnimation(timerDuration: timerDuration, strokeEnd: strokeEnd)
    }
    
    func updateButton(imageName: String) {
        self.focusSessionView.changePauseResumeImage(to: imageName)
    }
    
    func startTimer() {
        self.viewModel.startCountownTimer()
    }
    
    func resetTimer() {
        self.viewModel.countdownTimer.invalidate()
        self.focusSessionView.resetAnimations()
    }
    
    func start() {
        self.startAnimation()
        self.startTimer()
    }
    
    func restart() {
        self.resetTimer()
        self.restartAnimation()
    }
}
