//
//  ChartView.swift
//  Education
//
//  Created by Eduardo Dalencon on 28/06/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    // MARK: - ViewModel
    @ObservedObject var viewModel: ThemePageViewModel
    
    // MARK: - UI Components
    var body: some View {
        Chart {
            ForEach(Array(viewModel.limitedItems.enumerated()), id: \.offset) { index, result in
                result
            }
        }
        .onAppear {
            self.viewModel.getLimitedItems()
        }
    }
}
