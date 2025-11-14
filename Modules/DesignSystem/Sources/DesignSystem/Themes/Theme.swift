//
//  Theme.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 13/11/25.
//

import SwiftUI

/// Protocolo que define a estrutura de um tema
public protocol ThemeProtocol: Sendable {
    // MARK: - Background Colors
    var primaryBackground: Color { get }
    var secondaryBackground: Color { get }
    var tertiaryBackground: Color { get }
    var cardBackground: Color { get }

    // MARK: - Text Colors
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var tertiaryText: Color { get }
    var invertedText: Color { get }

    // MARK: - Accent Colors
    var primaryAccent: Color { get }
    var secondaryAccent: Color { get }
    var destructiveAccent: Color { get }
    var warningAccent: Color { get }
    var successAccent: Color { get }

    // MARK: - Component Colors
    var separatorColor: Color { get }
    var borderColor: Color { get }
    var shadowColor: Color { get }
    var overlayColor: Color { get }

    // MARK: - Specific UI Elements
    var tabBarBackground: Color { get }
    var navigationBarBackground: Color { get }
    var searchBarBackground: Color { get }
    var buttonBackground: Color { get }
    var disabledBackground: Color { get }
}

/// Tema Dark (atual)
public struct DarkTheme: ThemeProtocol, Sendable {
    // MARK: - Background Colors
    public let primaryBackground = Color(UIColor.systemBackground)
    public let secondaryBackground = Color(UIColor.secondarySystemBackground)
    public let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    public let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
    })

    // MARK: - Text Colors
    public let primaryText = Color(UIColor.label)
    public let secondaryText = Color(UIColor.secondaryLabel)
    public let tertiaryText = Color(UIColor.tertiaryLabel)
    public let invertedText = Color.white

    // MARK: - Accent Colors
    public let primaryAccent = Color.red
    public let secondaryAccent = Color.blue
    public let destructiveAccent = Color.red
    public let warningAccent = Color.orange
    public let successAccent = Color.green

    // MARK: - Component Colors
    public let separatorColor = Color(UIColor.separator)
    public let borderColor = Color(UIColor.systemGray4)
    public let shadowColor = Color.black.opacity(0.3)
    public let overlayColor = Color.black.opacity(0.5)

    // MARK: - Specific UI Elements
    public let tabBarBackground = Color(UIColor.secondarySystemBackground)
    public let navigationBarBackground = Color(UIColor.secondarySystemBackground)
    public let searchBarBackground = Color(UIColor.tertiarySystemBackground)
    public let buttonBackground = Color.red
    public let disabledBackground = Color(UIColor.systemGray)

    public init() {}
}

/// Tema Light (novo)
public struct LightTheme: ThemeProtocol, Sendable {
    // MARK: - Background Colors
    public let primaryBackground = Color.white
    public let secondaryBackground = Color(UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0))
    public let tertiaryBackground = Color(UIColor(red: 0.92, green: 0.92, blue: 0.94, alpha: 1.0))
    public let cardBackground = Color.white

    // MARK: - Text Colors
    public let primaryText = Color.black
    public let secondaryText = Color(UIColor.systemGray)
    public let tertiaryText = Color(UIColor.systemGray2)
    public let invertedText = Color.white

    // MARK: - Accent Colors
    public let primaryAccent = Color(UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0))
    public let secondaryAccent = Color(UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0))
    public let destructiveAccent = Color(UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0))
    public let warningAccent = Color(UIColor(red: 1.0, green: 0.584, blue: 0.0, alpha: 1.0))
    public let successAccent = Color(UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0))

    // MARK: - Component Colors
    public let separatorColor = Color(UIColor.systemGray4)
    public let borderColor = Color(UIColor.systemGray5)
    public let shadowColor = Color.black.opacity(0.1)
    public let overlayColor = Color.black.opacity(0.3)

    // MARK: - Specific UI Elements
    public let tabBarBackground = Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
    public let navigationBarBackground = Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
    public let searchBarBackground = Color(UIColor.systemGray6)
    public let buttonBackground = Color(UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0))
    public let disabledBackground = Color(UIColor.systemGray4)

    public init() {}
}

/// Enum para identificar o tipo de tema
public enum ThemeType: String, CaseIterable, Sendable {
    case dark = "dark"
    case light = "light"

    public var displayName: String {
        switch self {
        case .dark:
            return "Dark Mode"
        case .light:
            return "Light Mode"
        }
    }

    public var theme: any ThemeProtocol {
        switch self {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
