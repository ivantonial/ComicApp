//
//  CharacterDetailRelatedContentView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import DesignSystem
import SwiftUI

struct CharacterDetailRelatedContentView: View {
    let relatedContent: CharacterRelatedContentModel
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("APPEARS IN")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .tracking(2)

            if !relatedContent.recentComics.isEmpty {
                RelatedItemsSectionView(
                    title: "Recent Comics",
                    items: relatedContent.recentComics
                )
            }

            if !relatedContent.recentSeries.isEmpty {
                RelatedItemsSectionView(
                    title: "Recent Series",
                    items: relatedContent.recentSeries
                )
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Related Items Section
private struct RelatedItemsSectionView: View {
    let title: String
    let items: [RelatedItemModel]
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.primaryText)

            ForEach(items.prefix(3)) { item in
                HStack {
                    Image(systemName: item.type.icon)
                        .foregroundColor(item.type.color.swiftUIColor.opacity(0.7))

                    Text(item.name)
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                        .lineLimit(1)

                    Spacer()
                }
            }
        }
    }
}
