//
//  FavoritesEmptyStateView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct FavoritesEmptyStateView: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        EmptyStateComponent(
            icon: "heart.slash",
            title: "No Favorites Yet",
            message: "Start adding your favorite Comic characters"
        )
    }
}
