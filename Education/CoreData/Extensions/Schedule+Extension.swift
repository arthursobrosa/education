//
//  Schedule+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Schedule {
    var unwrappedID: String {
        return id ?? String()
    }
    
    var unwrappedDay: Int {
        return Int(dayOfTheWeek)
    }
}
