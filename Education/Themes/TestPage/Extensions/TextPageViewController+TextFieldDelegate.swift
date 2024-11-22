//
//  TextPageViewControler+TextFieldDelegate.swift
//  Education
//
//  Created by Leandro Silva on 19/11/24.
//

import UIKit

extension TestPageViewController: UITextFieldDelegate {
    func textFieldEditingDidEnd(_ sender: UITextField) {
        guard let text = sender.text else { return }

        switch sender.tag {
        case 0:
            viewModel.themeName = text
            
        case 1:
            if text.isEmpty {
                sender.text = "0"
            }
            guard let intText = Int(text) else { return }
            viewModel.totalQuestions = intText
            
        case 2:
            if text.isEmpty {
                sender.text = "0"
            }
            guard let intText = Int(text) else { return }
            viewModel.rightQuestions = intText
        default:
            break
        }
    }
    
    func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.text = String()
    }
}
