//
//  ShowingTimer.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

protocol ShowingTimer: AnyObject {
    func showTimer<T: UIViewControllerTransitioningDelegate>(transitioningDelegate: T, timerState: FocusSessionViewModel.TimerState?, totalSeconds: Int, timerSeconds: Int, subject: Subject?, timerCase: TimerCase, isAtWorkTime: Bool, blocksApps: Bool, isTimeCountOn: Bool, isAlarmOn: Bool)
}
