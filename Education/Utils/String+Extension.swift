//
//  String+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 24/11/24.
//

import Foundation

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespaces)
    }
}
