//
//  FocusSession+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension FocusSession {
    var unwrappedID: String {
        return id ?? String()
    }

    var unwrappedTotalTime: Int {
        return Int(totalTime)
    }

    var unwrappedSubjectID: String {
        return subjectID ?? String()
    }
}
