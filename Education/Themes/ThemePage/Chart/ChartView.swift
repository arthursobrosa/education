//
//  ChartView.swift
//  Education
//
//  Created by Eduardo Dalencon on 28/06/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @StateObject var vm: ChartViewModel
    @State private var selectedLimit: Int = 7
    let limits = [7, 15, 30]
    
    private var limitedItems: [BarMark] {
        vm.limitedItems(for: selectedLimit)
    }
    
    var body: some View {
        VStack {
            Picker("Entries", selection: $selectedLimit) {
                ForEach(limits, id: \.self) { limit in
                    Text("\(limit)").tag(limit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Chart {
                ForEach(Array(limitedItems.enumerated()), id: \.offset) { index, result in
                    result
                }
            }
        }
        .onAppear {
            vm.fetchItems()
        }
    }
}

//#Preview {
//    ChartView()
//}
