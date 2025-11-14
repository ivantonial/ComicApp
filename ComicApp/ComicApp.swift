//
//  ComicApp.swift
//  ComicApp
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import AppCoordinator
import DesignSystem
import SwiftUI

@main
struct ComicApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var themeManager = ThemeManager.shared

    init() {
        // Garante que o ThemeManager seja inicializado
        _ = ThemeManager.shared
    }

    var body: some Scene {
        WindowGroup {
            coordinator.start()
                .themed()
                .preferredColorScheme(themeManager.currentThemeType == .dark ? .dark : .light)
        }
    }
}
