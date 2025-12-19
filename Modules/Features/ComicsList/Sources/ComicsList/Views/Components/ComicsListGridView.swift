//
//  ComicsListGridView.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import SwiftUI

struct ComicsListGridView: View {
    let comics: [Comic]
    let isLoading: Bool
    let gridColumns: [GridItem]
    let onComicSelected: (Comic) -> Void
    let onLoadMore: (Comic) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(comics) { comic in
                    ComicCardView(model: ComicCardModel(from: comic)) {
                        onComicSelected(comic)
                    }
                    .onAppear {
                        onLoadMore(comic)
                    }
                }

                if isLoading && !comics.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .gridCellColumns(gridColumns.count)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
