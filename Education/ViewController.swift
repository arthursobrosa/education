//
//  ViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
//        view.addSubview(TimerView())
        
    }
    
    override func loadView() {
        self.view = TimerPickerView(frame: .zero)
    }


}

