//
//  FocusSelectionViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

class FocusSelectionViewModel {
    let subject: Subject?
    var selectedTimerCase: TimerCase? = nil
    
    let blocksApps: Bool
    
    init(subject: Subject?, blocksApps: Bool) {
        self.subject = subject
        self.blocksApps = blocksApps
    }
}
