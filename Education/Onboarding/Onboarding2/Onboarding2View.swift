//
//  Onboarding2View.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class Onboarding2View: OnboardingView {
    // MARK: - UI Properties
    
    private let welcomingView: WelcomingView = {
        let view = WelcomingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializer
    
    init() {
        super.init(showsBackButton: true)
        layoutContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func animate() {
        welcomingView.startAnimation()
    }
}

// MARK: - UI Setup

extension Onboarding2View {
    private func layoutContent() {
        addSubview(welcomingView)
        welcomingView.layoutToSuperview()
    }
}
