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
                UserDefaults.standard.set(encoded, forKey: "applications")
            } catch {
                print("error to encode data: \(error)")
            }
        }
    }
}

struct FamilyActivityPickerView: View {
    @State var isPresented: Bool = true
    @State var pickerDelegate: BlockingManager

    var body: some View {
        VStack {
            Text("")
                .familyActivityPicker(isPresented: $isPresented, selection: $pickerDelegate.selectionToDiscourage)
                .onAppear {
                    Task {
                        do {
                            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                        } catch {
                            print("Failed to request authorization: \(error)")
                        }
                    }
                }
        }
    }
}
