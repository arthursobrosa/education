//
//  ChartView.swift
//  Education
//
//  Created by Eduardo Dalencon on 28/06/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @StateObject var viewModel: ThemePageViewModel
    
    var body: some View {
        VStack {
            Picker("Entries", selection: $viewModel.selectedLimit) {
                ForEach(viewModel.limits, id: \.self) { limit in
                    Text("\(limit)").tag(limit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Chart {
                ForEach(Array(viewModel.limitedItems.enumerated()), id: \.offset) { index, result in
                    result
                }
            }
        }
        .onAppear {
            self.viewModel.getLimitedItems()
        }
    }
}
