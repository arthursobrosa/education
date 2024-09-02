//
//  CreateActivityTip.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import Foundation
import TipKit
import SwiftUI
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
