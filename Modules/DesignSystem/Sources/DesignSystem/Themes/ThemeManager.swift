//
//  ThemeManager.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 13/11/25.
//

import SwiftUI
import Combine

/// Manager singleton responsável por gerenciar o tema atual do aplicativo
@MainActor
public final class ThemeManager: ObservableObject {
    // MARK: - Singleton
    public static let shared = ThemeManager()

    // MARK: - Published Properties
    @Published public private(set) var currentTheme: any ThemeProtocol = DarkTheme()
    @Published public private(set) var currentThemeType: ThemeType = .dark

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let themeKey = "app_theme_type"
    private let hasLaunchedBeforeKey = "has_launched_before"
    private var hasAppliedInitialTheme = false

    // MARK: - Initialization
    private init() {
        loadSavedTheme()
        // Aplica o tema imediatamente na inicialização
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 segundo
            applyThemeToSystem(currentThemeType)
        }
    }

    // MARK: - Public Methods

    /// Altera o tema atual do aplicativo
    /// - Parameter type: O tipo de tema a ser aplicado
    public func setTheme(_ type: ThemeType) {
        currentThemeType = type
        currentTheme = type.theme
        saveTheme(type)
        applyThemeToSystem(type)
    }

    /// Alterna entre os temas disponíveis
    public func toggleTheme() {
        let newTheme: ThemeType = currentThemeType == .dark ? .light : .dark
        setTheme(newTheme)
    }

    /// Verifica se o tema atual é dark
    public var isDarkMode: Bool {
        currentThemeType == .dark
    }

    /// Força a aplicação do tema atual (útil após a UI estar pronta)
    public func applyCurrentTheme() {
        applyThemeToSystem(currentThemeType)
    }

    // MARK: - Private Methods

    private func loadSavedTheme() {
        let hasLaunchedBefore = userDefaults.bool(forKey: hasLaunchedBeforeKey)

        if !hasLaunchedBefore {
            // Primeira execução - define dark como padrão
            userDefaults.set(true, forKey: hasLaunchedBeforeKey)
            setTheme(.dark)
        } else if let savedThemeRawValue = userDefaults.string(forKey: themeKey),
                  let savedTheme = ThemeType(rawValue: savedThemeRawValue) {
            // Carrega o tema salvo
            currentThemeType = savedTheme
            currentTheme = savedTheme.theme
        } else {
            // Fallback para dark se não houver tema salvo
            setTheme(.dark)
        }
    }

    private func saveTheme(_ type: ThemeType) {
        userDefaults.set(type.rawValue, forKey: themeKey)
        userDefaults.synchronize() // Força a gravação imediata
    }

    private func applyThemeToSystem(_ type: ThemeType) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            // Se não houver windowScene ativa, agenda para aplicar depois
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
                self.applyThemeToSystem(type)
            }
            return
        }

        windowScene.windows.forEach { window in
            UIView.transition(with: window,
                            duration: hasAppliedInitialTheme ? 0.3 : 0.0,
                            options: .transitionCrossDissolve,
                            animations: {
                window.overrideUserInterfaceStyle = type == .dark ? .dark : .light
            })
        }

        hasAppliedInitialTheme = true
    }
}

// MARK: - View Extension para facilitar o uso
public extension View {
    /// Aplica o tema atual à view
    func withTheme() -> some View {
        self.environmentObject(ThemeManager.shared)
    }
}

// MARK: - Environment Values Extension
private struct ThemeEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any ThemeProtocol = DarkTheme()
}

public extension EnvironmentValues {
    var theme: any ThemeProtocol {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Modifier para aplicar tema
public struct ThemedViewModifier: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var hasAppliedTheme = false

    public func body(content: Content) -> some View {
        content
            .environment(\.theme, themeManager.currentTheme)
            .environmentObject(themeManager)
            .onAppear {
                if !hasAppliedTheme {
                    themeManager.applyCurrentTheme()
                    hasAppliedTheme = true
                }
            }
    }
}

public extension View {
    func themed() -> some View {
        modifier(ThemedViewModifier())
    }
}
