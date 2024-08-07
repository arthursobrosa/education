//
//  CurrentActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class CurrentActivityView: UIView {
    private let progressView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentActivityView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
