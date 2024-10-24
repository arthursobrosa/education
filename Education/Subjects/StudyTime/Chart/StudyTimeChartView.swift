
//
//  Created by Eduardo Dalencon on 11/07/24.
//

import SwiftUI
import Charts

struct StudyTimeChartView: View {
    @StateObject var viewModel: StudyTimeViewModel = StudyTimeViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.getTotalAggregatedTime())
                    .font(Font.custom(viewModel.focusSessions.value.isEmpty ? Fonts.darkModeOnRegular : Fonts.darkModeOnMedium, size: 16))
                    .foregroundStyle(Color(uiColor: UIColor.label))
                    .opacity(viewModel.focusSessions.value.isEmpty ? 0.5 : 0.8)
            }
            
            if viewModel.aggregatedTimes.isEmpty {
                Chart {
                    SectorMark(
                        angle: .value("Time", 1),
                        innerRadius: .ratio(0.8),
                        angularInset: 1.5
                    )
                    .cornerRadius(12)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .opacity(colorScheme == .dark ? 0.15 : 0.06)
                }
                .chartLegend(.hidden)
            } else {
                Chart(viewModel.aggregatedTimes) { session in
                    SectorMark(
                        angle: .value("Time", session.totalTime),
                        innerRadius: .ratio(0.8),
                        angularInset: 1.5
                    )
                    .cornerRadius(12)
                    .foregroundStyle(Color(UIColor(named: session.subjectColor) ?? .clear))
                }
                .chartLegend(.hidden)
            }
        }
        .onAppear {
            viewModel.updateAggregatedTimes()
        }
        .onChange(of: viewModel.selectedDateRange) { _, _ in
            viewModel.updateAggregatedTimes()
        }
    }
}
