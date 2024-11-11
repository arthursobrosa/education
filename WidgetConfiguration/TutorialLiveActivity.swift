//
//  TutorialLiveActivity.swift
//  TutorialLiveActivity
//
//  Created by Lucas Cunha on 16/10/24.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TutorialLiveActivityEntryView: View {
    let context: ActivityViewContext<TimerAttributes>

    var body: some View {
        VStack {
            Text(context.attributes.timerName)
                .font(.footnote)
            Text(context.state.endTime, style: .timer)
        }
        .padding(.horizontal)
    }
}

struct TutorialLiveActivity: Widget {
//    let kind: String = "TutorialLiveActivity"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            TutorialLiveActivityEntryView(context: context)
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Algo")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Algo")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Algo")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Algo")
                }
            } compactLeading: {
                Image(systemName: "arrow.2.circlepath.circle")
            } compactTrailing: {
                Image(systemName: "arrow.2.circlepath.circle")
            } minimal: {
                Image(systemName: "arrow.2.circlepath.circle")
            }
        }
    }
}
