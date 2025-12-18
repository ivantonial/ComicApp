//
//  ManagedFullScreenLoadingComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 09/12/25.
//

import SwiftUI
import Core

// MARK: - ManagedFullScreenLoadingComponent
/// Versão que observa automaticamente o LoadingManager
public struct ManagedFullScreenLoadingComponent: View {
    // MARK: - Properties
    @ObservedObject private var loadingManager = LoadingManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared

    let context: LoadingManager.LoadingContext?
    let onBack: (() -> Void)?

    // MARK: - Initialization
    public init(
        context: LoadingManager.LoadingContext? = nil,
        onBack: (() -> Void)? = nil
    ) {
        self.context = context
        self.onBack = onBack
    }

    // MARK: - Body
    public var body: some View {
        if loadingManager.isLoading {
            // Se um contexto específico foi fornecido, só mostra se for o contexto atual
            if let context = context {
                if loadingManager.currentLoadingContext == context {
                    FullScreenLoadingComponent(
                        logoImage: "Loading",
                        loadingText: loadingManager.loadingMessage.replacingOccurrences(of: "...", with: ""),
                        onBack: onBack
                    )
                    .transition(.opacity)
                }
            } else {
                // Sem contexto específico, sempre mostra quando loading
                FullScreenLoadingComponent(
                    logoImage: "Loading",
                    loadingText: loadingManager.loadingMessage.replacingOccurrences(of: "...", with: ""),
                    onBack: onBack
                )
                .transition(.opacity)
            }
        }
    }
}

// MARK: - View Extension
public extension View {
    /// Adiciona FullScreenLoading gerenciado pelo LoadingManager
    /// - Parameters:
    ///   - context: Contexto específico de loading (opcional)
    ///   - onBack: Ação de voltar (opcional)
    /// - Returns: View modificada com loading gerenciado
    func managedFullScreenLoading(
        context: LoadingManager.LoadingContext? = nil,
        onBack: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            self
            ManagedFullScreenLoadingComponent(
                context: context,
                onBack: onBack
            )
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview("ManagedFullScreenLoadingComponent") {
    ManagedFullScreenLoadingComponent()
}
#endif
