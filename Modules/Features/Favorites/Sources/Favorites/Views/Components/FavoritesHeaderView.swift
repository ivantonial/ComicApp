//
//  FavoritesHeaderView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct FavoritesHeaderView: View {
    let favoriteCount: Int
    let hasFavorites: Bool
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Favorites")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(themeManager.currentTheme.primaryText)

            if hasFavorites {
                Text("\(favoriteCount) Characters")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, hasFavorites ? 10 : 20)
    }
}
