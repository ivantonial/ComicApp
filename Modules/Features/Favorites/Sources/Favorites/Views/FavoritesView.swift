//
//  FavoritesView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct FavoritesView: View {
    // MARK: - Properties
    @StateObject private var viewModel: FavoritesViewModel
    @State private var showingShareSheet = false
    @State private var showingDeleteAlert = false
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss

    private let onCharacterSelected: ((Character) -> Void)?

    // MARK: - Initialization
    public init(
        viewModel: FavoritesViewModel,
        onCharacterSelected: ((Character) -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onCharacterSelected = onCharacterSelected
    }

    // MARK: - Body
    public var body: some View {
        let _ = print("📱 [FavoritesView] Rendering with \(viewModel.favoriteCharacters.count) favorites")

        ZStack {
            themeManager.currentTheme.primaryBackground.ignoresSafeArea()

            // Main Content
            VStack(spacing: 0) {
                // Header
                FavoritesHeaderView(
                    favoriteCount: viewModel.favoriteCharacters.count,
                    hasFavorites: viewModel.hasFavorites
                )

                // Search Bar
                if viewModel.hasFavorites {
                    FavoritesSearchBarView(searchText: $viewModel.searchText)
                }

                // Sort Options
                if viewModel.hasFavorites && !viewModel.isSelectionMode {
                    FavoritesSortOptionsView(
                        sortOption: viewModel.sortOption,
                        onSortOptionChanged: viewModel.updateSortOption
                    )
                }

                // Selection Toolbar
                if viewModel.isSelectionMode {
                    FavoritesSelectionToolbarView(
                        isAllSelected: viewModel.isAllSelected,
                        selectedCount: viewModel.selectedCount,
                        onSelectAll: viewModel.selectAll,
                        onDeselectAll: viewModel.deselectAll,
                        onDelete: {
                            showingDeleteAlert = true
                        }
                    )
                }

                // Content - Só mostra se não estiver carregando
                if !viewModel.isLoading {
                    if viewModel.hasFavorites {
                        FavoritesGridView(
                            filteredCharacters: viewModel.filteredCharacters,
                            selectedCharacters: viewModel.selectedCharacters,
                            isSelectionMode: viewModel.isSelectionMode,
                            onCharacterTap: { character in
                                if viewModel.isSelectionMode {
                                    viewModel.toggleSelection(for: character)
                                } else {
                                    onCharacterSelected?(character)
                                }
                            },
                            onCharacterRemove: viewModel.removeFavorite
                        )
                    } else {
                        FavoritesEmptyStateView()
                    }
                }
            }

            // FullScreen Loading (substitui LoadingComponent)
            if viewModel.isLoading {
                FullScreenLoadingComponent(
                    logoImage: "Loading",
                    loadingText: "Loading favorites", // Sem os "..."
                    onBack: {
                        // Permite cancelar e voltar
                        dismiss()
                    }
                )
                .transition(.opacity)
                .zIndex(1000)
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .alert("Delete Favorites", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.removeSelectedFavorites()
            }
        } message: {
            Text("Are you sure you want to remove \(viewModel.selectedCount) character(s) from favorites?")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheetView(items: [viewModel.exportFavorites()])
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.hasFavorites {
                Menu {
                    Button(action: {
                        viewModel.toggleSelectionMode()
                    }) {
                        Label(
                            viewModel.isSelectionMode ? "Done" : "Select",
                            systemImage: viewModel.isSelectionMode ? "checkmark.circle" : "checkmark.circle"
                        )
                    }

                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share List", systemImage: "square.and.arrow.up")
                    }

                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(themeManager.currentTheme.primaryText)
                }
            }
        }
    }
}
