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
    
    init(subject: Subject?) {
        self.subject = subject
    }
}
