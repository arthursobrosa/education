//
//  TestDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import Foundation

class TestDetailsViewModel {
    
    let theme: Theme
    let test: Test

    init(theme: Theme, test: Test) {
        self.theme = theme
        self.test = test
    }
    
    func getDateString(from test: Test) -> String {
        let date = test.unwrappedDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")

        return dateFormatter.string(from: date)
    }
    
    func getDateFullString(from test: Test) -> String {
        let date = test.unwrappedDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // Usar o idioma atual do sistema
        dateFormatter.dateFormat = "EEEE, dd 'de' MMMM 'de' yyyy"

        // Ajustar o formato do texto "de" para idiomas como inglês
        if Locale.current.languageCode == "en" {
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        }

        return dateFormatter.string(from: date)
    }
}
