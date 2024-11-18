//
//  Onboarding1View.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class Onboarding1View: OnboardingView {
    // MARK: - UI Properties
    
    private let welcomingView: WelcomingView = {
        let view = WelcomingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializer
    
    init() {
        super.init(showsBackButton: false)
        layoutContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func animate() {
        welcomingView.startAnimation()
    }
    
    func reset() {
        welcomingView.restartAnimation()
    }
}

// MARK: - UI Setup

extension Onboarding1View {
    private func layoutContent() {
        addSubview(welcomingView)
        welcomingView.layoutToSuperview()
    }
}
