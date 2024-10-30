//
//  CreateTestTip.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import Foundation
import SwiftUI
import TipKit
import UIKit

struct CreateTestTip: Tip {
    var title: Text {
        Text(String(localized: "newTestTip"))
            .bold()
    }

    var message: Text? {
        Text(String(localized: "explainTestTip"))
    }
}
