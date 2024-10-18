//
//  WidgetConfigurationBundle.swift
//  WidgetConfiguration
//
//  Created by Arthur Sobrosa on 18/10/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetConfigurationBundle: WidgetBundle {
    var body: some Widget {
        WidgetConfiguration()
        WidgetConfigurationLiveActivity()
    }
}
