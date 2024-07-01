//
//  Coordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
