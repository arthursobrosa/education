//
//  TimerAttributes.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    typealias TimerStatus = ContentState

    struct ContentState: Codable, Hashable {
        var endTime: Date
    }

    var timerName: String
    var timerStart: Date = .now
}
