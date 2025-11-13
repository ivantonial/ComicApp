//
//  FavoritesCardView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import DesignSystem
import SwiftUI

public struct FavoriteCardView: View {
    public let character: Character
    public let isSelected: Bool
    public let isSelectionMode: Bool
    public let onTap: () -> Void
    public let onRemove: () -> Void

    public init(
        character: Character,
        isSelected: Bool,
        isSelectionMode: Bool,
        onTap: @escaping () -> Void,
        onRemove: @escaping () -> Void
    ) {
        self.character = character
        self.isSelected = isSelected
        self.isSelectionMode = isSelectionMode
        self.onTap = onTap
        self.onRemove = onRemove
    }

    public var body: some View {
        _ = print("🔧 [FavoriteCardView] Rendering card for: \(character.name)")
        ZStack(alignment: .topTrailing) {
            // Card principal - passa o onTap diretamente para o ContentCardComponent
            ContentCardComponent(
                model: character.toContentCardModel(),
                onTap: {
                    print("🎯 [FavoriteCardView] onTap triggered for: \(character.name)")
                    onTap()
                }  // ✅ Passa o callback corretamente
            )

            // Overlay de seleção / remoção
            overlayView
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        if isSelectionMode {
            // Modo seleção: bolinha de seleção
            Circle()
                .fill(isSelected ? Color.red : Color.gray.opacity(0.3))
                .frame(width: 24, height: 24)
                .overlay(
                    Image(systemName: isSelected ? "checkmark" : "circle")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                )
                .padding(8)
        } else {
            // Modo normal: botão de remover favorito (coração)
            Button(action: {
                print("❤️ [FavoriteCardView] Remove button tapped for: \(character.name)")
                onRemove()
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .padding(6)
                    .background(
                        Circle().fill(Color.black.opacity(0.6))
                    )
            }
            .buttonStyle(.plain)
            .padding(8)
            .allowsHitTesting(true) // ✅ Garante que apenas o botão responda ao toque
        }
    }
}

// MARK: - Mapper para ContentCardModel

private extension Character {
    func toContentCardModel() -> ContentCardModel {
        let image = self.image
        let countOfIssueAppearances = self.countOfIssueAppearances

        return ContentCardModel(
            id: id,
            title: name,
            subtitle: nil,
            // ComicVine: melhor URL disponível
            imageURL: image.bestQualityUrl,
            // No DesignSystem atual o aspectRatio está como CGFloat (ex.: 1.0)
            aspectRatio: 1.0,
            badge: ContentCardModel.BadgeModel(
                icon: "book.fill",
                // Marvel: comics.available
                // ComicVine: countOfIssueAppearances
                text: "\(countOfIssueAppearances) comics",
                color: .gray
            )
        )
    }
}
