//
//  FocusSelectionViewController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

//import Foundation
//
//protocol FocusSelectionDelegate: AnyObject {
//    func timerButtonTapped()
//    func pomodoroButtonTapped()
//    func stopWatchButtonTapped()
//    
//}
//
//extension FocusSelectionViewController: FocusSelectionDelegate {
//    func timerButtonTapped() {
//        //vai para criacao de timer
//        self.coordinator?.showTimer(totalTimeInSeconds: Int(0), subjectID: self.viewModel.subjectID)
//        
//        self.model.apllyShields()
//    }
//    
//    func pomodoroButtonTapped() {
//        //vai para criacao de pomodoro
//        self.coordinator?.showTimer(totalTimeInSeconds: Int(0), subjectID: self.viewModel.subjectID)
//        
//        self.model.apllyShields()
//    }
//    
//    
//    func stopWatchButtonTapped() {
//        //vai para cronometro
//        self.coordinator?.showTimer(totalTimeInSeconds: Int(0), subjectID: self.viewModel.subjectID)
//        
//        self.model.apllyShields()
//    }
//    
//}

import UIKit

protocol FocusSelectionDelegate: AnyObject {
    func timerButtonTapped()
    func pomodoroButtonTapped()
    func stopWatchButtonTapped()
    func finishButtonTapped()
}

class FocusSelectionViewController: UIViewController {
    
    private let focusSelectionView = FocusSelectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupFocusSelectionView()
    }
    
    private func setupFocusSelectionView() {
        focusSelectionView.delegate = self
        focusSelectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(focusSelectionView)
        
        NSLayoutConstraint.activate([
            focusSelectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            focusSelectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            focusSelectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            focusSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension FocusSelectionViewController: FocusSelectionDelegate {
    func timerButtonTapped() {
        print("Timer button tapped")
        // Handle timer button action
    }
    
    func pomodoroButtonTapped() {
        print("Pomodoro button tapped")
        // Handle pomodoro button action
    }
    
    func stopWatchButtonTapped() {
        print("Stopwatch button tapped")
        // Handle stopwatch button action
    }
    
    func finishButtonTapped() {
        print("Finish button tapped")
        // Handle finish button action
    }
}

