//
//  SubjectCreationViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 22/08/24.
//

import Foundation

protocol SubjectCreationDelegate: AnyObject {
    func textFieldDidChange(newText: String)
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        self.subjectName = newText
    }
}
