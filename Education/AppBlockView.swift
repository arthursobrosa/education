//
//  AppBlockView.swift
//  Education
//
//  Created by Lucas Cunha on 03/07/24.
//

import FamilyControls
import SwiftUI

struct AppBlockView: View {
    @StateObject var model = MyModel()
    @State private var isPresented = false

    var body: some View {
        VStack {
            Button("Select Apps to Discourage") {
                isPresented = true
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)

            Button("Request Authorization") {
                model.requestAuthorization()
            }

            Button("Start Monitoring Schedule") {
                model.monitorSchedule()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppBlockView()
    }
}
