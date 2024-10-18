//
//  WidgetConfigurationLiveActivity.swift
//  WidgetConfiguration
//
//  Created by Arthur Sobrosa on 18/10/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetConfigurationAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetConfigurationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetConfigurationAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetConfigurationAttributes {
    fileprivate static var preview: WidgetConfigurationAttributes {
        WidgetConfigurationAttributes(name: "World")
    }
}

extension WidgetConfigurationAttributes.ContentState {
    fileprivate static var smiley: WidgetConfigurationAttributes.ContentState {
        WidgetConfigurationAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetConfigurationAttributes.ContentState {
         WidgetConfigurationAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetConfigurationAttributes.preview) {
   WidgetConfigurationLiveActivity()
} contentStates: {
    WidgetConfigurationAttributes.ContentState.smiley
    WidgetConfigurationAttributes.ContentState.starEyes
}
