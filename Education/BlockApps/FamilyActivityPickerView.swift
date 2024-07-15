//
//  FamilyActivityPickerView.swift
//  Education
//
//  Created by Lucas Cunha on 15/07/24.
//

import SwiftUI
import UIKit
import FamilyControls

class FamilyActivityPickerDelegate: ObservableObject {
    
    @Published var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey:"applications")
                print("saved selection")
            } catch {
                print("error to encode data: \(error)")
            }
        }
    }
    
}

struct FamilyActivityPickerView: View {
    
    @State var isPresented: Bool = true
    @StateObject var pickerDelegate: BlockAppsMonitor = BlockAppsMonitor()

    var body: some View {
        VStack {
            Text("")
            .familyActivityPicker(isPresented: $isPresented, selection: $pickerDelegate.selectionToDiscourage)
        }
    }
}
