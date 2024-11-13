//
//  TutorialLiveActivity.swift
//  TutorialLiveActivity
//
//  Created by Lucas Cunha on 16/10/24.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct LiveActivityView: View {
    let state: TimerAttributes.ContentState

    var body: some View {
        HStack {
            Button {
                //TODO: End the activity
            } label: {
                Label("Stop", systemImage: "stop.circle")
                    .font(.body.bold())
            }
            .foregroundColor(Color.white)
            .background(.blue)
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.vertical, 8)
            .transition(.identity)

            Spacer()

            HStack(alignment: .center, spacing: 16) {
                WidgetCircleTimerView(
                    progress: state.progress,
                    duration: state.duration
                )

                Text(state.duration)
                    .font(.largeTitle.monospacedDigit())
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
            }
        }
        .id(state)
        .padding()
        .foregroundColor(Color.accentColor)
    }
}

struct WidgetCircleTimerView: View {

  var progress: Double
  var duration: String

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 5)
        .opacity(0.25)
        .foregroundColor(.white)
        .frame(width: 36, height: 36)

      Circle()
        .trim(from: 0.0, to: progress)
        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        .rotationEffect(.degrees(270.0))
        .foregroundColor(Color.accentColor)
        .frame(width: 36, height: 36)
    }
  }
}

struct TutorialLiveActivity: Widget {
//    let kind: String = "TutorialLiveActivity"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            LiveActivityView(state: context.state).activitySystemActionForegroundColor(.blue)
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(" ")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(" ")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Planno")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(" ")
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

//@DynamicIslandExpandedContentBuilder
//private func expandedContent(state: TimerAttributes.ContentState) -> DynamicIslandExpandedContent<some View> {
//    DynamicIslandExpandedRegion(.leading) {
//        Image(systemName: "timer.circle.fill")
//            .resizable()
//            .frame(width: 44.0, height: 44.0)
//            .foregroundColor(.blue)
//    }
//    DynamicIslandExpandedRegion(.center) {
//        VStack {
//            Text(state.duration + " remaining")
//                .font(.title)
//                .minimumScaleFactor(0.8)
//                .contentTransition(.numericText())
//            Spacer()
//            Button {
//                //TODO: End the activity
//            } label: {
//                Label("Stop", systemImage: "stop.circle")
//                    .font(.body.bold())
//            }
//            .foregroundColor(.green)
//            .background(.blue)
//            .clipShape(Capsule())
//            .padding(.horizontal)
//            .padding(.vertical, 8)
//            .lineLimit(1)
//        }
//        .id(state)
//        .transition(.identity)
//    }
//}
