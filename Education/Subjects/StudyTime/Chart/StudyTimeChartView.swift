
//
//  Created by Eduardo Dalencon on 11/07/24.
//

import Foundation
import SwiftUI
import Charts

struct StudyTimeChartView: View {
    @StateObject var viewModel: StudyTimeViewModel = StudyTimeViewModel()
    
    var body: some View {
        ZStack{
            
            VStack{
                Text(String(localized: "totalTime"))
                    .font(Font.custom(Fonts.darkModeOnMedium, size: 15))
                Text(viewModel.getTotalAggregatedTime())
                    .font(Font.custom(Fonts.darkModeOnRegular, size: 14))
            }
            
            
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
            .padding()
        }
        .onAppear {
            viewModel.updateAggregatedTimes()
        }
        .onChange(of: viewModel.selectedDateRange) { _, _ in
            viewModel.updateAggregatedTimes()
        }
    }
}
