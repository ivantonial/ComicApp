//
//  FavoritesGridView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import SwiftUI

struct FavoritesGridView: View {
    let filteredCharacters: [Character]
    let selectedCharacters: Set<Int>
    let isSelectionMode: Bool
    let onCharacterTap: (Character) -> Void
    let onCharacterRemove: (Character) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredCharacters) { character in
                    FavoriteCardView(
                        character: character,
                        isSelected: selectedCharacters.contains(character.id),
                        isSelectionMode: isSelectionMode,
                        onTap: {
                            print("👆 [FavoritesGridView] Tapped on character: \(character.name) ID: \(character.id)")
                            onCharacterTap(character)
                        },
                        onRemove: {
                            onCharacterRemove(character)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
