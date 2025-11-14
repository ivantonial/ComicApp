//
//  ThemeUseCase.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 13/11/25.
//

import DesignSystem
import Foundation

/// UseCase responsável por gerenciar operações relacionadas ao tema
@MainActor
public protocol ThemeUseCaseProtocol {
    func getCurrentTheme() -> ThemeType
    func setTheme(_ type: ThemeType)
    func toggleTheme()
}

@MainActor
public final class ThemeUseCase: ThemeUseCaseProtocol {
    private let themeManager = ThemeManager.shared

    public init() {}

    public func getCurrentTheme() -> ThemeType {
        return themeManager.currentThemeType
    }

    public func setTheme(_ type: ThemeType) {
        themeManager.setTheme(type)
    }

    public func toggleTheme() {
        themeManager.toggleTheme()
    }
}
