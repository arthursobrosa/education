//
//  LiveActivityManaging.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import Foundation

protocol LiveActivityManaging {
    func startActivity(endTime: Date)
    func updateActivity(endTime: Date)
    func endActivity()
}
