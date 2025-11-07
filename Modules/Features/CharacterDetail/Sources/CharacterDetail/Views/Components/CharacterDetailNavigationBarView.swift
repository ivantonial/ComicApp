//
//  CharacterDetailNavigationBarView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import SwiftUI

struct CharacterDetailNavigationBarView: View {
    let isFavorite: Bool
    let onBack: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack {
            HStack {
                // Botão Voltar
                NavigationBackButton(action: onBack)

                Spacer()

                // Botão Favorito
                AnimatedFavoriteButton(
                    isFavorite: isFavorite,
                    action: onToggleFavorite
                )
            }
            .padding(.horizontal)
            .padding(.top, 50)

            Spacer()
        }
    }
}

// MARK: - Navigation Back Button

private struct NavigationBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .blur(radius: 1)
                )
        }
        .buttonStyle(InteractiveButtonStyle(feedbackStyle: .light))
    }
}

// MARK: - Animated Favorite Button

private struct AnimatedFavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    @State private var animationScale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            triggerAnimation()
            action()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isFavorite ? .red : .white)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .blur(radius: 1)
                )
                .scaleEffect(animationScale)
        }
        .buttonStyle(InteractiveButtonStyle(feedbackStyle: .medium))
        .onChange(of: isFavorite) { _ in
            triggerAnimation()
        }
    }

    private func triggerAnimation() {
        // Animação de escala com spring
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 15)) {
            animationScale = 1.3
        }

        // Retorna ao tamanho normal com animação spring
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 15).delay(0.1)) {
            animationScale = 1.0
        }
    }
}

// MARK: - Interactive Button Style

private struct InteractiveButtonStyle: ButtonStyle {
    let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    provideFeedback()
                }
            }
    }

    private func provideFeedback() {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }
}
