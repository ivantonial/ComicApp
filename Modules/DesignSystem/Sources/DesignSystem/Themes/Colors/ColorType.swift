//
//  ColorType.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import Foundation
import SwiftUI

/// Paleta de cores sem dependência de UI frameworks.
/// Essa camada é neutra (não importa se é UIKit ou SwiftUI).
public enum ColorType: String, CaseIterable, Sendable {
    // MARK: - Semantic Colors
    case primaryBackground
    case secondaryBackground
    case tertiaryBackground
    case cardBackground

    case primaryText
    case secondaryText
    case tertiaryText
    case invertedText

    case primaryAccent
    case secondaryAccent
    case destructiveAccent
    case warningAccent
    case successAccent

    case separator
    case border
    case shadow
    case overlay

    // MARK: - Legacy Colors (mantidas para compatibilidade)
    case red
    case blue
    case yellow
    case green
    case gray
}
