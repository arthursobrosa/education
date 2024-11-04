//
//  LiveActivityViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 01/11/24.
//

import Foundation

class LiveActivityViewModel: ObservableObject {
    @Published var liveActivityManaging: LiveActivityManaging
    
    init(liveActivityManaging: LiveActivityManaging) {
        self.liveActivityManaging = liveActivityManaging
    }
}
