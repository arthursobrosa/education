//
//  Theme+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Theme {
    var unwrappedID: String {
        id ?? String()
    }

    var unwrappedName: String {
        name ?? String()
    }
}
