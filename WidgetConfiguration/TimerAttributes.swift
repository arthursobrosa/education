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
    
    public struct ContentState: Codable, Hashable {
      var duration: Int
      var progress: Double
    }

    var name: String
    var color: String
    var restTime: Bool
    
}
