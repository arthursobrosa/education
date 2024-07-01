//
//  ChartViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 28/06/24.
//

import Foundation
import Charts

class ChartViewModel: ObservableObject {
    @Published var items: [Test] = []
    private var themeId: String
    
    init(themeId: String) {
        self.themeId = themeId
        fetchItems()
    }
    
    func fetchItems() {
        if let themes = CoreDataManager.shared.fetchTests(from: self.themeId) {
            self.items = themes
        }
    }
    
    func limitedItems(for limit: Int) -> [BarMark] {
        var limitedItems: [BarMark] = []
        let itemsToShow = items.prefix(limit)
        for (index, item) in itemsToShow.enumerated() {
            let bar = BarMark(
                x: .value("Index", index),
                y: .value("Test", (Double(item.rightQuestions) / Double(item.totalQuestions)))
            )
            limitedItems.append(bar)
        }
        while (limitedItems.count < limit) {
            let additionalBar = BarMark(
                x: .value("Index", limitedItems.count),
                y: .value("Test", 0)
            )
            limitedItems.append(additionalBar)
            
        }
        return limitedItems
    }
    
}


