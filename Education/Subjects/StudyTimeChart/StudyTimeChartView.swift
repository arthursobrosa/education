
//
//  Created by Eduardo Dalencon on 11/07/24.
//

import Foundation
import SwiftUI
import Charts

struct StudyTimeChartView: View {
    @StateObject var viewModel: StudyTimeViewModel = StudyTimeViewModel()
    
    var body: some View {
        Chart(viewModel.aggregatedTimes) { session in
            SectorMark(
                angle: .value("Time", session.totalTime),
                innerRadius: .ratio(0.5),
                angularInset: 1.5
            )
            .cornerRadius(3)
            .foregroundStyle(by: .value("Subject", session.subject))
        }
//        .chartLegend(position: .bottom, spacing: 30)
        .chartLegend(.hidden)
        .onAppear {
            viewModel.updateAggregatedTimes()
        }
        .onChange(of: viewModel.selectedDateRange) { _, _ in
            viewModel.updateAggregatedTimes()
        }
    }
}
