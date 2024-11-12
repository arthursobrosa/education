//
//  Subject+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Subject {
    var unwrappedID: String {
        id ?? String()
    }

    var unwrappedName: String {
        name ?? String()
    }

    var unwrappedColor: String {
        color ?? String()
    }
}
