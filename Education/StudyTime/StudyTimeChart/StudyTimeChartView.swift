
//
//  Created by Eduardo Dalencon on 11/07/24.
//

import Foundation
import SwiftUI
import Charts

struct StudyTimeChartView: View {
    
    @StateObject var viewModel: StudyTimeChartViewModel = StudyTimeChartViewModel()
    
    var body: some View {
        VStack {
            Picker("Date Range", selection: $viewModel.selectedDateRange) {
                            Text("Última semana").tag(DateRange.lastWeek)
                            Text("Último Mês").tag(DateRange.lastMonth)
                            Text("Último Ano").tag(DateRange.lastYear)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
            
            Chart(viewModel.aggregatedTimes) { session in
                SectorMark(
                    angle: .value("Time", session.totalTime),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .cornerRadius(3)
                .foregroundStyle(by: .value("Subject", session.subject))
            }
            .chartLegend(position: .bottom, spacing: 30)
            .padding()
            .frame(height: 300)
            
            Spacer()
        }
        .onAppear {
            viewModel.aggregateTimes()
        }
        .onChange(of: viewModel.selectedDateRange) { _ in
                    viewModel.aggregateTimes()
                }
        .padding()
    }
}

#Preview {
    StudyTimeChartView()
}
