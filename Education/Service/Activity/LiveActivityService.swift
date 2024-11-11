//
//  LiveActivityService.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import ActivityKit
import Foundation

final class LiveActivityService: LiveActivityManaging {
    private var activity: Activity<TimerAttributes>?
    static let shared = LiveActivityService()
    
    private init() {}

    // Function to start the Live Activity
    func startActivity(endTime: Int, title: String?, timerCase: TimerCase) {
        let attributes = TimerAttributes(timerName: title ?? "Free Focus")
        let state: TimerAttributes.TimerStatus
        
        if timerCase == .stopwatch {
            state = TimerAttributes.TimerStatus(endTime: Date())
        } else {
            state = TimerAttributes.TimerStatus(endTime: Date().addingTimeInterval(TimeInterval(endTime)))
        }
        
        do {
            activity = try Activity<TimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
            print("Live Activity started successfully!")
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }

    // Function to update the Live Activity
    func updateActivity(addedTime: Date) {
        let state = TimerAttributes.TimerStatus(endTime: addedTime)

        Task {
            await activity?.update(using: state)
        }
    }

    // Function to end the Live Activity
    func endActivity(timerCase: TimerCase) {
        let state = TimerAttributes.TimerStatus(endTime: .now)

        if timerCase != .stopwatch {
            Task {
                await activity?.end(using: state, dismissalPolicy: .immediate)
            }
        }
    }
}
