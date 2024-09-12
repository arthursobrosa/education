//
//  hourDetailsView.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class HourDetailsView: UIView {
    
    
    let startTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 20)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    let endTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnMedium, size: 20)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
     let bracket: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal1")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)

        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    
     let lineStartTime: UIImageView = {
         let img = UIImage(named: "ScheduleDetailsModal2")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
     let lineEndTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    init(starTime: String, endTime: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.startTime.text = starTime
        self.endTime.text = endTime
        
        
        self.setupUI()
        
        self.backgroundColor = color.withAlphaComponent(0.3)
       
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HourDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(bracket)
        addSubview(startTime)
        addSubview(lineStartTime)
        addSubview(endTime)
        addSubview(lineEndTime)
        
        NSLayoutConstraint.activate([
            bracket.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 53/102),
            bracket.widthAnchor.constraint(equalTo: bracket.heightAnchor, multiplier: 6/53),
            bracket.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bracket.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            
            startTime.centerYAnchor.constraint(equalTo: bracket.topAnchor),
            startTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
            
            lineStartTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 8),
            lineStartTime.centerYAnchor.constraint(equalTo: startTime.centerYAnchor),
            lineStartTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 188/321),
           
            endTime.centerYAnchor.constraint(equalTo: bracket.bottomAnchor, constant: 0),
            endTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
            
            lineEndTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 8),
            lineEndTime.centerYAnchor.constraint(equalTo: endTime.centerYAnchor),
            lineEndTime.widthAnchor.constraint(equalTo: lineStartTime.widthAnchor)
        ])
    }
}
