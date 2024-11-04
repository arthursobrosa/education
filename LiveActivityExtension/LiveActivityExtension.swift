//
//  LiveActivityExtension.swift
//  LiveActivityExtension
//
//  Created by Lucas Cunha on 01/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack {
            Text(context.attributes.timerName)
                .font(.headline)
            
            Text(context.state.endTime, style: .timer)
        }
    }
}

struct LiveActivityExtension: Widget {
    let kind: String = "LiveActivityExtension"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self){ context in
            TimerActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}


