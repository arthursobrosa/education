//
//  Onboarding3Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import Foundation

protocol Onboarding3Delegate: AnyObject {
    func addSubjectName(forSubjectIndex index: Int)
    func removeSubjectName(fromSubjectIndex index: Int)
    func createNewSubjectName(_ name: String)
    func isSelected(atIndex index: Int) -> Bool
}

extension Onboarding3ViewController: Onboarding3Delegate {
    func addSubjectName(forSubjectIndex index: Int) {
        viewModel.addSubjectName(fromSubjectIndex: index)
    }
    
    func removeSubjectName(fromSubjectIndex index: Int) {
        viewModel.removeSubjectName(fromSubjectIndex: index)
    }
    
    func createNewSubjectName(_ name: String) {
        viewModel.createNewSubjectName(name)
    }
    
    func isSelected(atIndex index: Int) -> Bool {
        viewModel.isSelected(atIndex: index)
    }
}
