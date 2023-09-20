//
//  ThemeManager.swift
//  kaser
//
//  Created by iMad on 20/09/2023.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()

    private init() {}

    enum Theme: String {
        case light, dark
    }

    var currentTheme: Theme {
        get {
            if let storedTheme = UserDefaults.standard.string(forKey: "AppTheme") {
                return Theme(rawValue: storedTheme) ?? .light
            }
            return .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "AppTheme")
            UserDefaults.standard.synchronize()
        }
    }

    func toggleTheme() {
        currentTheme = (currentTheme == .light) ? .dark : .light
    }
}
