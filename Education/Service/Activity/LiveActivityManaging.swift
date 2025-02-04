//
//  LiveActivityManaging.swift
//  LiveActivityTest
//
//  Created by Lucas Cunha on 18/10/24.
//

import Foundation

protocol LiveActivityManaging {
    func startActivity(endTime: Int, title: String?, timerCase: TimerCase)
    func updateActivity(addedTime: Date)
    func endActivity(timerCase: TimerCase)
}
