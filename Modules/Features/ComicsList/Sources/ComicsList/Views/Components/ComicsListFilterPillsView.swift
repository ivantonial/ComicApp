//
//  ComicsListFilterPillsView.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct ComicsListFilterPillsView: View {
    let selectedFilter: ComicFilter
    let onFilterSelected: (ComicFilter) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ComicFilter.allCases, id: \.self) { filter in
                    FilterPillComponent(
                        title: filter.title,
                        isSelected: selectedFilter == filter,
                        style: .primary,
                        selectedColor: .red,
                        action: {
                            onFilterSelected(filter)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
