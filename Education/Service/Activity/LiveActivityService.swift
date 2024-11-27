//
//  LiveActivityService.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import ActivityKit
import Foundation

final class LiveActivityManager {
    private var activityID: String?
    
    private func areActivitiesEnabled() -> Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    func startActivity(duration: Int, progress: Double, title: String, color: String, restTime: Bool) {
        guard areActivitiesEnabled() else { return }
        
        endActivities()
        
        var activity: Activity<TimerAttributes>?
        
        let attributes = TimerAttributes(
            name: title,
            color: color,
            restTime: restTime
        )
        
        let contentState = TimerAttributes.ContentState(
            duration: duration,
            progress: progress
        )
        
        let activityContent = ActivityContent(
            state: contentState,
            staleDate: nil
        )
        
        do {
            activity = try Activity.request(
                attributes: attributes,
                content: activityContent
            )
        } catch {
            print(error.localizedDescription)
        }
        
        if let id = activity?.id {
            activityID = id
        }
    }
    
    func updateActivity(duration: Int, progress: Double) {
        let contentState = TimerAttributes.ContentState(
            duration: duration,
            progress: progress
        )
        
        let activityContent = ActivityContent(
            state: contentState,
            staleDate: nil
        )
        
        Task {
            let activity = Activity<TimerAttributes>.activities.first(where: { $0.id == activityID })
            await activity?.update(activityContent)
        }
    }
    
    func endActivities() {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
}
