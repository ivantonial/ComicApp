//
//  FullScreenLoadingComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 22/11/25.
//

import SwiftUI
import Core // Para acessar o LoadingManager

// MARK: - FullScreenLoadingComponent
/// Componente de loading em tela cheia com logo animado
public struct FullScreenLoadingComponent: View {
    // MARK: - Properties
    let logoImage: String
    let loadingText: String
    let onBack: (() -> Void)?
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isAnimating = false
    @State private var dotCount = 0

    // MARK: - Initialization
    public init(
        logoImage: String = "Loading",
        loadingText: String = "Loading",
        onBack: (() -> Void)? = nil
    ) {
        self.logoImage = logoImage
        self.loadingText = loadingText
        self.onBack = onBack
    }

    // MARK: - Body
    public var body: some View {
        ZStack {
            // Background
            themeManager.currentTheme.primaryBackground
                .ignoresSafeArea()

            // Back Button no topo (apenas se onBack for fornecido)
            if onBack != nil {
                VStack {
                    HStack {
                        backButton
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 60) // Safe area for status bar

                    Spacer()
                }
            }

            // Centro da tela - Tudo junto
            ZStack {
                // Glow vermelho como background absoluto
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                themeManager.currentTheme.primaryAccent.opacity(0.2),
                                themeManager.currentTheme.primaryAccent.opacity(0.1),
                                themeManager.currentTheme.primaryAccent.opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 200
                        )
                    )
                    .frame(width: 400, height: 400)
                    .scaleEffect(isAnimating ? 1.15 : 0.95)
                    .animation(
                        Animation.easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .blur(radius: 10)

                // Logo e Loading COLADOS
                VStack(spacing: 0) { // SEM ESPAÇAMENTO
                    // Logo
                    Group {
                        if let uiImage = UIImage(named: logoImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120) // Apenas altura definida
                        } else {
                            // Fallback balloon com texto
                            ZStack {
                                Ellipse()
                                    .fill(themeManager.currentTheme.cardBackground)
                                    .frame(width: 280, height: 160)

                                VStack(spacing: 0) {
                                    Text("Comic")
                                        .font(.system(size: 46, weight: .bold, design: .rounded))
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                    Text("App")
                                        .font(.system(size: 40, weight: .medium, design: .rounded))
                                        .foregroundColor(themeManager.currentTheme.primaryText)
                                }
                            }
                        }
                    }
                    .scaleEffect(isAnimating ? 1.05 : 0.95)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                    // Loading text IMEDIATAMENTE abaixo
                    HStack(spacing: 0) {
                        Text(loadingText)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.primaryText)

                        // Animated dots
                        HStack(spacing: 2) {
                            ForEach(0..<3) { index in
                                Text(".")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(themeManager.currentTheme.primaryText)
                                    .opacity(dotCount > index ? 1 : 0)
                            }
                        }
                        .frame(width: 30, alignment: .leading)
                    }
                    .offset(y: 0)
                }
            }
        }
        .onAppear {
            startAnimations()
            logLoadingStart()
        }
        .onDisappear {
            logLoadingEnd()
        }
    }

    // MARK: - Back Button
    @ViewBuilder
    private var backButton: some View {
        if let onBack = onBack {
            Button(action: onBack) {
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.tertiaryBackground.opacity(0.3))
                        .frame(width: 44, height: 44)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(themeManager.currentTheme.primaryText)
                }
            }
        }
    }

    // MARK: - Animations
    private func startAnimations() {
        withAnimation {
            isAnimating = true
        }

        // Animate dots
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                dotCount = (dotCount + 1) % 4
            }
        }
    }

    // MARK: - Debug Logging
    private func logLoadingStart() {
        #if DEBUG
        print("🔄 [FullScreenLoading] Started - Message: \(loadingText)")
        #endif
    }

    private func logLoadingEnd() {
        #if DEBUG
        print("✅ [FullScreenLoading] Ended - Message: \(loadingText)")
        #endif
    }
}

// MARK: - ManagedFullScreenLoadingComponent
/// Versão que observa automaticamente o LoadingManager
public struct ManagedFullScreenLoadingComponent: View {
    @ObservedObject private var loadingManager = LoadingManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared

    let context: LoadingManager.LoadingContext?
    let onBack: (() -> Void)?

    public init(
        context: LoadingManager.LoadingContext? = nil,
        onBack: (() -> Void)? = nil
    ) {
        self.context = context
        self.onBack = onBack
    }

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

// MARK: - View Modifier
/// ViewModifier para adicionar loading facilmente a qualquer View
public struct FullScreenLoadingModifier: ViewModifier {
    let isLoading: Bool
    let message: String
    let onBack: (() -> Void)?

    public init(
        isLoading: Bool,
        message: String = "Loading",
        onBack: (() -> Void)? = nil
    ) {
        self.isLoading = isLoading
        self.message = message
        self.onBack = onBack
    }

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

// MARK: - View Extensions
public extension View {
    /// Adiciona FullScreenLoading baseado em um estado booleano
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

    /// Adiciona FullScreenLoading gerenciado pelo LoadingManager
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
