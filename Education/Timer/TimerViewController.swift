//
//  TimerViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class TimerViewController: UIViewController {
    weak var coordinator: Coordinator?
    private let viewModel: TimerViewModel
    private let totalTimeInMinutes: Int
    
    private lazy var timerView: TimerView =  {
        let timerView = TimerView(frame: .zero, totalTimeInMinutes: self.totalTimeInMinutes, viewModel: self.viewModel)
        return timerView
    }()
    
    init(totalTimeInMinutes: Int = 0, viewModel: TimerViewModel) {
        self.totalTimeInMinutes = totalTimeInMinutes
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
