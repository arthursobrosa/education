//
//  CreateSubjectTip.swift
//  Education
//
//  Created by Eduardo Dalencon on 29/08/24.
//

import Foundation
import TipKit
import SwiftUI
import UIKit

struct CreateSubjectTip: Tip {
    var title: Text {
        Text(String(localized: "newSubjectTip"))
            .bold()
    }
    
    var message: Text? {
        Text(String(localized: "explainSubjectTip"))
    }
    
}
