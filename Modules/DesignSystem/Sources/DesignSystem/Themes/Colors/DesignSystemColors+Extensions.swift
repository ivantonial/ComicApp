//
//  DesignSystemColors+Extensions.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import SwiftUI

extension ColorType {
    /// Retorna a cor SwiftUI baseada no tema atual
    @MainActor
    public var swiftUIColor: Color {
        let theme = ThemeManager.shared.currentTheme

        switch self {
        // MARK: - Semantic Colors
        case .primaryBackground:
            return theme.primaryBackground
        case .secondaryBackground:
            return theme.secondaryBackground
        case .tertiaryBackground:
            return theme.tertiaryBackground
        case .cardBackground:
            return theme.cardBackground

        case .primaryText:
            return theme.primaryText
        case .secondaryText:
            return theme.secondaryText
        case .tertiaryText:
            return theme.tertiaryText
        case .invertedText:
            return theme.invertedText

        case .primaryAccent:
            return theme.primaryAccent
        case .secondaryAccent:
            return theme.secondaryAccent
        case .destructiveAccent:
            return theme.destructiveAccent
        case .warningAccent:
            return theme.warningAccent
        case .successAccent:
            return theme.successAccent

        case .separator:
            return theme.separatorColor
        case .border:
            return theme.borderColor
        case .shadow:
            return theme.shadowColor
        case .overlay:
            return theme.overlayColor

        // MARK: - Legacy Colors (mantidas para compatibilidade)
        case .red:
            return theme.primaryAccent
        case .blue:
            return theme.secondaryAccent
        case .yellow:
            return theme.warningAccent
        case .green:
            return theme.successAccent
        case .gray:
            return theme.disabledBackground
        }
    }

    /// Retorna a UIColor baseada no tema atual (para uso com UIKit)
    @MainActor
    public var uiColor: UIColor {
        return UIColor(swiftUIColor)
    }
}

// MARK: - Convenience Extensions
public extension Color {
    @MainActor
    static var theme: ThemeColors {
        return ThemeColors()
    }
}

@MainActor
public struct ThemeColors {
    public var primaryBackground: Color { ColorType.primaryBackground.swiftUIColor }
    public var secondaryBackground: Color { ColorType.secondaryBackground.swiftUIColor }
    public var tertiaryBackground: Color { ColorType.tertiaryBackground.swiftUIColor }
    public var cardBackground: Color { ColorType.cardBackground.swiftUIColor }

    public var primaryText: Color { ColorType.primaryText.swiftUIColor }
    public var secondaryText: Color { ColorType.secondaryText.swiftUIColor }
    public var tertiaryText: Color { ColorType.tertiaryText.swiftUIColor }
    public var invertedText: Color { ColorType.invertedText.swiftUIColor }

    public var primaryAccent: Color { ColorType.primaryAccent.swiftUIColor }
    public var secondaryAccent: Color { ColorType.secondaryAccent.swiftUIColor }
    public var destructiveAccent: Color { ColorType.destructiveAccent.swiftUIColor }
    public var warningAccent: Color { ColorType.warningAccent.swiftUIColor }
    public var successAccent: Color { ColorType.successAccent.swiftUIColor }

    public var separator: Color { ColorType.separator.swiftUIColor }
    public var border: Color { ColorType.border.swiftUIColor }
    public var shadow: Color { ColorType.shadow.swiftUIColor }
    public var overlay: Color { ColorType.overlay.swiftUIColor }
}
