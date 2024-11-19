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
    let title: String
    let color: String
    var restTime: Bool
    
    var body: some View {
        let hourString: String = state.duration / 3600 > 0 ? zeroAdder(time: state.duration / 3600) + ":" : ""
        let timeString: String = hourString + zeroAdder(time: state.duration / 60 - (state.duration / 3600 * 60)) + ":" + zeroAdder(time: state.duration % 60)
        
        let bigFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .medium)
        let mediumFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        let smallFont = UIFont(name: Fonts.darkModeOnMedium, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        
        HStack {
            VStack(alignment: .leading) {
                Text(restTime ? String(localized: "restTime") : String(localized: "studyTime"))
                    .font(Font(smallFont))
                    .foregroundColor(Color(UIColor(named: "system-text-40") ?? .gray))
                
                Text(title)
                    .font(Font(mediumFont))
                    .foregroundColor(Color(UIColor(named: "system-text-80") ?? .gray))
                    .padding(.bottom, 16)
                
                Text(timeString)
                    .font(Font(bigFont))
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
                    .foregroundColor(Color(UIColor(named: "system-text-80") ?? .gray))
            }
            
            Spacer()
            
            WidgetCircleTimerView(
                progress: state.progress,
                duration: String(state.duration),
                color: color,
                restTime: restTime
            )
        }
        .id(state)
        .padding()
        .background(.background)
    }
}

func zeroAdder(time: Int) -> String {
    if time < 10 {
        "0\(time)"
    } else {
        String(time)
    }
}

struct WidgetCircleTimerView: View {
    
    var progress: Double
    var duration: String
    let color: String
    let restTime: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.25)
                .foregroundColor(Color(UIColor(named: "system-activity-10") ?? .gray))
                .frame(width: 60, height: 60)
            
            if restTime {
                Circle()
                    .trim(from: 1.0 - progress, to: 1.0)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(270.0))
                    .foregroundColor(Color(UIColor(named: color) ?? .blue))
                    .frame(width: 60, height: 60)
            } else {
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(270.0))
                    .foregroundColor(Color(UIColor(named: color) ?? .blue))
                    .frame(width: 60, height: 60)
            }
        }
    }
}

struct TutorialLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            LiveActivityView(state: context.state, title: context.attributes.name, color: context.attributes.color, restTime: context.attributes.restTime).activitySystemActionForegroundColor(.blue)
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(context: context)
            } compactLeading: {
                Text(context.attributes.name)
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
                    .monospacedDigit()
                    .foregroundColor((Color(UIColor(named: context.attributes.color) ?? .blue)))
                    .padding(8)
            } compactTrailing: {
                let hourString: String = context.state.duration / 3600 > 0 ? zeroAdder(time: context.state.duration / 3600) + ":" : ""
                let timeString: String = hourString + zeroAdder(time: context.state.duration / 60 - (context.state.duration / 3600 * 60)) + ":" + zeroAdder(time: context.state.duration % 60)
                
                Text(timeString)
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
                    .monospacedDigit()
                    .foregroundColor((Color(UIColor(named: context.attributes.color) ?? .blue)))
                    .padding(8)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor((Color(UIColor(named: context.attributes.color) ?? .blue)))
            }
        }
    }
}

@DynamicIslandExpandedContentBuilder
private func expandedContent(context: ActivityViewContext<TimerAttributes>) -> DynamicIslandExpandedContent<some View> {
    let mediumFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    let bigFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .medium)
    
    let hourString: String = context.state.duration / 3600 > 0 ? zeroAdder(time: context.state.duration / 3600) + ":" : ""
    let timeString: String = hourString + zeroAdder(time: context.state.duration / 60 - (context.state.duration / 3600 * 60)) + ":" + zeroAdder(time: context.state.duration % 60)
    
    DynamicIslandExpandedRegion(.leading) {
        Image(uiImage: (UITraitCollection.current.userInterfaceStyle == .light ? UIImage(named: "books-dark") : UIImage(named: "books")) ?? UIImage())
            .resizable()
            .padding(.top, 10.0)
            .padding(.leading, 5.0)
            .frame(width: 22.0, height: 50.0)
            .foregroundColor(.blue)
    }
    
    DynamicIslandExpandedRegion(.center) {
        VStack {
            Text(context.attributes.name)
                .font(Font(bigFont))
                .minimumScaleFactor(0.8)
                .foregroundColor((Color(UIColor(named: context.attributes.color) ?? .blue)))
            
            Text(timeString + " remaining")
                .font(Font(mediumFont))
                .minimumScaleFactor(0.8)
                .opacity(0.6)
                .contentTransition(.numericText())
                .foregroundColor((Color(UIColor(named: context.attributes.color) ?? .blue)))
        }
        .id(context.state)
        .transition(.identity)
    }
}
