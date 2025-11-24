//
//  CharacterListView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

//import ComicVineAPI
//import Core
//import DesignSystem
//import SwiftUI
//
//public struct CharacterListView: View {
//    @StateObject private var viewModel: CharacterListViewModel
//    private let onCharacterSelected: ((Character) -> Void)?
//
//    @ObservedObject private var themeManager = ThemeManager.shared
//    @State private var isSearching = false
//
//    public init(
//        viewModel: CharacterListViewModel,
//        onCharacterSelected: ((Character) -> Void)? = nil
//    ) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//        self.onCharacterSelected = onCharacterSelected
//    }
//
//    public var body: some View {
//        ZStack {
//            themeManager.currentTheme.primaryBackground.ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                // Header
//                CharacterListHeaderView()
//                    .background(themeManager.currentTheme.navigationBarBackground)
//                    .zIndex(1)
//
//                if viewModel.isLoading && viewModel.characters.isEmpty {
//                    Spacer()
//                    LoadingComponent(message: "Loading heroes...")
//                    Spacer()
//                } else if let error = viewModel.error, viewModel.characters.isEmpty {
//                    Spacer()
//                    ErrorComponent(
//                        message: error.localizedDescription,
//                        retryAction: {
//                            viewModel.refresh()
//                        }
//                    )
//                    Spacer()
//                } else {
//                    CharacterListGridView(
//                        characterCardModels: viewModel.characterCardModels,
//                        displayCharacters: viewModel.displayCharacters,
//                        isLoading: viewModel.isLoading,
//                        onCharacterSelected: onCharacterSelected,
//                        onLoadMore: { character in
//                            viewModel.loadMoreIfNeeded(currentCharacter: character)
//                        }
//                    )
//                    .refreshable {
//                        await refreshData()
//                    }
//                }
//            }
//
//            // Search bar flutuante
//            VStack {
//                Spacer()
//                CharacterListSearchBarView(
//                    searchText: $viewModel.searchText,
//                    isSearching: $isSearching
//                )
//                .padding(.horizontal, 20)
//                .padding(.bottom, 30)
//            }
//        }
//        .onAppear {
//            if viewModel.characters.isEmpty {
//                viewModel.loadInitialData()
//            }
//        }
//    }
//
//    private func refreshData() async {
//        await viewModel.refreshAsync()
//    }
//}
import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct CharacterListView: View {
    @StateObject private var viewModel: CharacterListViewModel
    private let onCharacterSelected: ((Character) -> Void)?

    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isSearching = false
    @State private var showFullScreenLoading = false

    public init(
        viewModel: CharacterListViewModel,
        onCharacterSelected: ((Character) -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onCharacterSelected = onCharacterSelected
    }

    public var body: some View {
        ZStack {
            themeManager.currentTheme.primaryBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                CharacterListHeaderView()
                    .background(themeManager.currentTheme.navigationBarBackground)
                    .zIndex(1)

                if let error = viewModel.error, viewModel.characters.isEmpty {
                    Spacer()
                    ErrorComponent(
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.refresh()
                        }
                    )
                    Spacer()
                } else if !viewModel.isLoading || !viewModel.characters.isEmpty {
                    CharacterListGridView(
                        characterCardModels: viewModel.characterCardModels,
                        displayCharacters: viewModel.displayCharacters,
                        isLoading: viewModel.isLoading,
                        onCharacterSelected: onCharacterSelected,
                        onLoadMore: { character in
                            viewModel.loadMoreIfNeeded(currentCharacter: character)
                        }
                    )
                    .refreshable {
                        await refreshData()
                    }
                }
            }

            // Search bar flutuante
            VStack {
                Spacer()
                CharacterListSearchBarView(
                    searchText: $viewModel.searchText,
                    isSearching: $isSearching
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }

            // FullScreen Loading (substitui LoadingComponent)
            if viewModel.isLoading && viewModel.characters.isEmpty {
                FullScreenLoadingComponent(
                    logoImage: "Loading",
                    loadingText: "Loading heroes", // Sem os "..." pois o componente já adiciona
                    onBack: nil // Sem botão voltar nesta tela
                )
                .transition(.opacity)
                .zIndex(1000)
            }
        }
        .onAppear {
            if viewModel.characters.isEmpty {
                viewModel.loadInitialData()
            }
        }
    }

    private func refreshData() async {
        await viewModel.refreshAsync()
    }
}
