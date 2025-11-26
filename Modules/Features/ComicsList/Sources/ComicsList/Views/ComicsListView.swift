//
//  ComicsListView.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct ComicsListView: View {
    @StateObject private var viewModel: ComicsListViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    // Adaptação para portrait/landscape
    private var gridColumns: [GridItem] {
        let isLandscape = verticalSizeClass == .compact
        let isPad = horizontalSizeClass == .regular && verticalSizeClass == .regular

        if isLandscape {
            // 4 colunas em landscape
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
        } else if isPad {
            // 3 colunas no iPad
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
        } else {
            // 2 colunas em portrait
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
        }
    }

    public init(viewModel: ComicsListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()

            // Main Content
            VStack(spacing: 0) {
                // Header
                ComicsListHeaderView(
                    character: viewModel.character,
                    totalComics: viewModel.totalComics,
                    onBack: { dismiss() }
                )

                // Filter Pills
                if viewModel.hasFilters {
                    ComicsListFilterPillsView(
                        selectedFilter: viewModel.selectedFilter,
                        onFilterSelected: viewModel.selectFilter
                    )
                }

                // Content - Só mostra se não estiver carregando ou se já tiver comics
                if !viewModel.isLoading || !viewModel.comics.isEmpty {
                    if let error = viewModel.error, viewModel.comics.isEmpty {
                        Spacer()
                        ErrorComponent(
                            message: error.localizedDescription,
                            retryAction: viewModel.refresh
                        )
                        Spacer()
                    } else if viewModel.comics.isEmpty {
                        ComicsListEmptyStateView()
                    } else {
                        ComicsListGridView(
                            comics: viewModel.filteredComics,
                            isLoading: viewModel.isLoading,
                            gridColumns: gridColumns,
                            onComicSelected: viewModel.selectComic,
                            onLoadMore: { comic in
                                viewModel.loadMoreIfNeeded(currentComic: comic)
                            }
                        )
                        .refreshable {
                            await refreshData()
                        }
                    }
                }
            }

            // FullScreen Loading (substitui LoadingComponent)
            if viewModel.isLoading && viewModel.comics.isEmpty {
                FullScreenLoadingComponent(
                    logoImage: "Loading",
                    loadingText: "Loading Comics", // Sem os "..."
                    onBack: {
                        // Cancela e volta
                        dismiss()
                    }
                )
                .transition(.opacity)
                .zIndex(1000)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.comics.isEmpty {
                viewModel.loadInitialData()
            }
        }
    }

    private func refreshData() async {
        viewModel.refresh()
    }
}
