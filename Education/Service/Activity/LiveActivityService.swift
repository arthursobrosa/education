//
//  LiveActivityService.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import ActivityKit
import Foundation

final class LiveActivityManager {
    @discardableResult
    func startActivity(duration: Int, progress: Double, title: String, color: String, restTime: Bool) -> Activity<TimerAttributes>? {
        var activity: Activity<TimerAttributes>?
        var attributes = TimerAttributes(name: title, color: color, restTime: restTime)
        
        do {
            let state = TimerAttributes.ContentState(
                duration: duration,
                progress: progress
            )
            activity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                contentState: state,
                pushType: nil
            )
        } catch {
            print(error.localizedDescription)
        }
        return activity
    }
    
    func updateActivity(activity: String, duration: Int, progress: Double) {
        Task {
            let contentState = TimerAttributes.ContentState(
                duration: duration,
                progress: progress
            )
            let activity = Activity<TimerAttributes>.activities.first(where: { $0.id == activity })
            await activity?.update(using: contentState)
        }
    }
    
    func endActivity(timerCase: TimerCase) {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}
