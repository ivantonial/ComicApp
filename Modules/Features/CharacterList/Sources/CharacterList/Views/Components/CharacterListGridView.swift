//
//  CharacterListGridView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import DesignSystem
import SwiftUI

struct CharacterListGridView: View {
    let characterCardModels: [CharacterCardModel]
    let displayCharacters: [Character]
    let isLoading: Bool
    let onCharacterSelected: ((Character) -> Void)?
    let onLoadMore: ((Character) -> Void)

    @ObservedObject private var themeManager = ThemeManager.shared

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 16, alignment: .top),
            GridItem(.flexible(), spacing: 16, alignment: .top)
        ]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns,
                spacing: 16
            ) {
                ForEach(characterCardModels, id: \.id) { cardModel in
                    let character = displayCharacters.first { $0.id == cardModel.id }

                    CharacterCardView(
                        model: cardModel,
                        onTap: {
                            if let character {
                                onCharacterSelected?(character)
                            }
                        }
                    )
                    .onAppear {
                        if let character {
                            onLoadMore(character)
                        }
                    }
                }

                if isLoading && !displayCharacters.isEmpty {
                    ProgressView()
                        .tint(themeManager.currentTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .padding(.bottom, 100)
        }
    }
}
