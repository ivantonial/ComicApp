//
//  FavoritesSelectionToolbarView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct FavoritesSelectionToolbarView: View {
    let isAllSelected: Bool
    let selectedCount: Int
    let onSelectAll: () -> Void
    let onDeselectAll: () -> Void
    let onDelete: () -> Void

    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack {
            Button(action: {
                if isAllSelected {
                    onDeselectAll()
                } else {
                    onSelectAll()
                }
            }) {
                Text(isAllSelected ? "Deselect All" : "Select All")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.primaryAccent)
            }

            Spacer()

            Text("\(selectedCount) selected")
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.secondaryText)

            Spacer()

            Button(action: {
                if selectedCount > 0 {
                    onDelete()
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(selectedCount > 0 ? themeManager.currentTheme.destructiveAccent : themeManager.currentTheme.tertiaryText)
            }
            .disabled(selectedCount == 0)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(themeManager.currentTheme.tertiaryBackground.opacity(0.5))
    }
}
