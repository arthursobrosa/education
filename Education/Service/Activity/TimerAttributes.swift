//
//  TimerAttributes.swift
//  Education
//
//  Created by Lucas Cunha on 01/11/24.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes{
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable{
        var endTime: Date
    }
    
    var timerName: String
}
