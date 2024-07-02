//
//  TimerViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class TimerViewController: UIViewController {
    
    var totalTimeInMinutes: Int = 0
    
    private lazy var timerView: TimerView = TimerView(frame: .zero, totalTimeInMinutes: self.totalTimeInMinutes)
    
    override func loadView() {
        super.loadView()
        
        self.view = self.timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
