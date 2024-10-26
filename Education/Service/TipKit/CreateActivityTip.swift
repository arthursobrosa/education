//
//  CreateActivityTip.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import Foundation

import Foundation
import SwiftUI
import TipKit
import UIKit

struct CreateActivityTip: Tip {
    var title: Text {
        Text(String(localized: "newActivityTip"))
            .bold()
    }

    var message: Text? {
        Text(String(localized: "explainActivityTip"))
    }
}
