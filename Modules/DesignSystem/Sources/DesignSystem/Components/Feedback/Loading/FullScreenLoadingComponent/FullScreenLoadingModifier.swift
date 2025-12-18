//
//  FullScreenLoadingModifier.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 09/12/25.
//

import SwiftUI

// MARK: - FullScreenLoadingModifier
/// ViewModifier para adicionar loading facilmente a qualquer View
public struct FullScreenLoadingModifier: ViewModifier {
    // MARK: - Properties
    let isLoading: Bool
    let message: String
    let onBack: (() -> Void)?

    // MARK: - Initialization
    public init(
        isLoading: Bool,
        message: String = "Loading",
        onBack: (() -> Void)? = nil
    ) {
        self.isLoading = isLoading
        self.message = message
        self.onBack = onBack
    }

    // MARK: - Body
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)

            if isLoading {
                FullScreenLoadingComponent(
                    logoImage: "Loading",
                    loadingText: message,
                    onBack: onBack
                )
                .transition(.opacity)
                .zIndex(999)
            }
        }
    }
}

// MARK: - View Extension
public extension View {
    /// Adiciona FullScreenLoading baseado em um estado booleano
    /// - Parameters:
    ///   - isLoading: Estado de carregamento
    ///   - message: Mensagem de loading (padrão: "Loading")
    ///   - onBack: Ação de voltar (opcional)
    /// - Returns: View modificada com loading
    func fullScreenLoading(
        isLoading: Bool,
        message: String = "Loading",
        onBack: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            FullScreenLoadingModifier(
                isLoading: isLoading,
                message: message,
                onBack: onBack
            )
        )
    }
}

// MARK: - Preview
#if DEBUG
#Preview("FullScreenLoadingModifier - Loading") {
    Text("Content")
        .fullScreenLoading(isLoading: true, message: "Processing")
}

#Preview("FullScreenLoadingModifier - Not Loading") {
    Text("Content")
        .fullScreenLoading(isLoading: false)
}
#endif
