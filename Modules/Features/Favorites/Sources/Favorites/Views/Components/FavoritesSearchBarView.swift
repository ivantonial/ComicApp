//
//  FavoritesSearchBarView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct FavoritesSearchBarView: View {
    @Binding var searchText: String
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.currentTheme.tertiaryText)

            TextField("Search favorites...", text: $searchText)
                .foregroundColor(themeManager.currentTheme.primaryText)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(themeManager.currentTheme.searchBarBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
