//
//  UserDefaults.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    let container = UserDefaults.standard
    
    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    public enum Keys {
        static let isFirstEntry = "isFirstEntry"
    }
    
    @UserDefault(key: UserDefaults.Keys.isFirstEntry, defaultValue: true)
    static var isFirstEntry
}
