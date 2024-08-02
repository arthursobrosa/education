//
//  ShowingTimer.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import Foundation

protocol ShowingTimer: AnyObject {
    func showTimer(totalTimeInSeconds: Int, subject: Subject?, timerCase: TimerCase)
}
