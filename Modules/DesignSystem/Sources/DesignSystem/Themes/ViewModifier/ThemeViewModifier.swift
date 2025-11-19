//
//  ThemeViewModifier.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 13/11/25.
//

import SwiftUI

/// ViewModifier que aplica automaticamente as cores do tema à view
public struct ThemeBackgroundModifier: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    let backgroundType: BackgroundType

    public enum BackgroundType {
        case primary
        case secondary
        case tertiary
        case card
    }

    public init(_ type: BackgroundType = .primary) {
        self.backgroundType = type
    }

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
    }

    private var backgroundColor: Color {
        switch backgroundType {
        case .primary:
            return themeManager.currentTheme.primaryBackground
        case .secondary:
            return themeManager.currentTheme.secondaryBackground
        case .tertiary:
            return themeManager.currentTheme.tertiaryBackground
        case .card:
            return themeManager.currentTheme.cardBackground
        }
    }
}

/// Extension para facilitar o uso
public extension View {
    func themedBackground(_ type: ThemeBackgroundModifier.BackgroundType = .primary) -> some View {
        modifier(ThemeBackgroundModifier(type))
    }
}
