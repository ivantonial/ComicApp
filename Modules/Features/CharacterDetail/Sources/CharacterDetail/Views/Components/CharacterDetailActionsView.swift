//
//  CharacterDetailActionsView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import DesignSystem
import SwiftUI

struct CharacterDetailActionsView: View {
    let hasComics: Bool
    let comicsCount: Int
    let wikiURL: URL?
    let onComicsSelected: (() -> Void)?
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(spacing: 12) {
            if hasComics {
                PrimaryButtonComponent(
                    title: "View Comics (\(comicsCount))",
                    action: { onComicsSelected?() }
                )
            }

            if let wikiURL = wikiURL {
                Link(destination: wikiURL) {
                    HStack {
                        Image(systemName: "globe")
                        Text("View on ComicVine Wiki")
                    }
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.currentTheme.tertiaryBackground.opacity(0.5))
                    .cornerRadius(12)
                }
            }
        }
    }
}
