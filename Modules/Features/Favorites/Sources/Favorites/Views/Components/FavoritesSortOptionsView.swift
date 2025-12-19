//
//  FavoritesSortOptionsView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import SwiftUI

struct FavoritesSortOptionsView: View {
    let sortOption: FavoritesSortOption
    let onSortOptionChanged: (FavoritesSortOption) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FavoritesSortOption.allCases, id: \.self) { option in
                    SortChipView(
                        title: option.title,
                        icon: option.icon,
                        isSelected: sortOption == option,
                        action: { onSortOptionChanged(option) }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}
