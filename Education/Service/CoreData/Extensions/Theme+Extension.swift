//
//  Theme+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Theme {
    var unwrappedID: String {
        return id ?? String()
    }

    var unwrappedName: String {
        return name ?? String()
    }
}
