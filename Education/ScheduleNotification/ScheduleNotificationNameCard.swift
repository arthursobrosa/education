//
//  ScheduleNotificationNameCard.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationNameCard: UIView {
    
    private let subjectName: UILabel = {
        
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let startTime: UILabel = {
        
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let endTime: UILabel = {
        
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.alpha = 0.7
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let bracket: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal1")
        
        let imgView = UIImageView(image: img)
        

        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    
    init(starTime: String, endTime: String, subjectName: String) {
        super.init(frame: .zero)
        
        self.startTime.text = starTime
        self.endTime.text = endTime
        self.subjectName.text = subjectName
        
        
        self.setupUI()
        
        self.backgroundColor = .black.withAlphaComponent(0.2)
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleNotificationNameCard: ViewCodeProtocol {
    func setupUI() {
        addSubview(subjectName)
        addSubview(bracket)
        addSubview(startTime)
        addSubview(endTime)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            
            bracket.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 68/219),
            bracket.widthAnchor.constraint(equalTo: bracket.heightAnchor, multiplier: 6/68),
            bracket.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding * 2),
            bracket.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            
            subjectName.topAnchor.constraint(equalTo: self.topAnchor, constant: padding * 1.5),
            subjectName.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
            
            startTime.centerYAnchor.constraint(equalTo: bracket.topAnchor),
            startTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
           
            endTime.centerYAnchor.constraint(equalTo: bracket.bottomAnchor, constant: 0),
            endTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
      
        ])
    }
}

#Preview {
    ScheduleNotificationViewController(color: UIColor(named: "ScheduleColor1"), viewModel: ScheduleNotificationViewModel(schedule: Schedule()))
}

