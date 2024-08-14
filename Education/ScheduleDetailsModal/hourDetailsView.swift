//
//  hourDetailsView.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class HourDetailsView: UIView {
    private let startTime: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "14:00"
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let endTime: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "15:00"
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let bracket: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal1")
        
        let imgView = UIImageView(image: img)
        

        imgView.frame = CGRect(x: 16, y: 32, width: 10, height: 53)
        
        return imgView
    }()
    
    
    private let lineStartTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")
        
        let imgView = UIImageView(image: img)
        
        imgView.frame = CGRect(x: 102, y: 32, width: 188, height: 2)
        
        return imgView
    }()
    
    private let lineEndTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")
        
        let imgView = UIImageView(image: img)
        
        imgView.frame = CGRect(x: 102, y: 80, width: 188, height: 2)
        
        return imgView
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setupUI()
        
        self.backgroundColor = .white.withAlphaComponent(0.15)
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
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
//            bracket.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
//            bracket.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            bracket.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            bracket.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            
            startTime.topAnchor.constraint(equalTo: bracket.topAnchor, constant: -padding * 0.5),
            startTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
            
            //lineStartTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 8),
           
            endTime.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: padding),
            endTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 8),
            
            //lineEndTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 8),
        ])
    }
}

#Preview{
    HourDetailsView()
}
