//
//  LiveActivityService.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import ActivityKit
import Foundation

final class LiveActivityService: LiveActivityManaging {
    private var activity: Activity<TimerAttributes>? = nil

    // Function to start the Live Activity
    func startActivity() {
        let attributes = TimerAttributes(timerName: "Timer")
        let state = TimerAttributes.TimerStatus(endTime: Date().addingTimeInterval(60 * 5))

        do {
            activity = try Activity<TimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
            print("Live Activity started successfully!")
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }

    // Function to update the Live Activity
    func updateActivity() {
        let state = TimerAttributes.TimerStatus(endTime: Date().addingTimeInterval(60 * 10))

        Task {
            await activity?.update(using: state)
        }
    }

    // Function to end the Live Activity
    func endActivity() {
        let state = TimerAttributes.TimerStatus(endTime: .now)

        Task {
            await activity?.end(using: state, dismissalPolicy: .immediate)
        }
    }
}
