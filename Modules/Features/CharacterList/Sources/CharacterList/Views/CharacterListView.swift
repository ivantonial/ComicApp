//
//  CharacterListView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct CharacterListView: View {
    @StateObject private var viewModel: CharacterListViewModel
    private let onCharacterSelected: ((Character) -> Void)?

    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var isSearching = false

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
                headerView
                    .background(themeManager.currentTheme.navigationBarBackground)
                    .zIndex(1)

                if viewModel.isLoading && viewModel.characters.isEmpty {
                    Spacer()
                    LoadingComponent(message: "Loading heroes...")
                    Spacer()
                } else if let error = viewModel.error, viewModel.characters.isEmpty {
                    Spacer()
                    ErrorComponent(
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.refresh()
                        }
                    )
                    Spacer()
                } else {
                    contentScrollView
                }
            }

            // Search bar flutuante
            VStack {
                Spacer()
                floatingSearchBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .onAppear {
            if viewModel.characters.isEmpty {
                viewModel.loadInitialData()
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        Text("Comics Characters")
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(themeManager.currentTheme.primaryText)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .padding(.bottom, 15)
    }

    // MARK: - Conteúdo
    private var contentScrollView: some View {
        ScrollView {
            LazyVGrid(
                columns: gridColumns(),
                spacing: 16
            ) {
                ForEach(viewModel.characterCardModels, id: \.id) { cardModel in
                    let character = viewModel.displayCharacters.first { $0.id == cardModel.id }

                    CharacterCardView(
                        model: cardModel,
                        onTap: {
                            if let character {
                                onCharacterSelected?(character)
                            }
                        }
                    )
                    .onAppear {
                        if let character {
                            viewModel.loadMoreIfNeeded(currentCharacter: character)
                        }
                    }
                }

                if viewModel.isLoading && !viewModel.characters.isEmpty {
                    ProgressView()
                        .tint(themeManager.currentTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .padding(.bottom, 100)
        }
        .refreshable {
            await refreshData()
        }
    }

    // MARK: - Search bar
    private var floatingSearchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.currentTheme.invertedText)
                .font(.system(size: 18))

            if isSearching {
                TextField("Search character", text: $viewModel.searchText)
                    .foregroundColor(themeManager.currentTheme.invertedText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .accentColor(themeManager.currentTheme.invertedText)

                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(themeManager.currentTheme.invertedText.opacity(0.8))
                    }
                }

                Button("Cancel") {
                    withAnimation(.spring()) {
                        isSearching = false
                        viewModel.searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .foregroundColor(themeManager.currentTheme.invertedText)
                .font(.system(size: 14, weight: .medium))
            } else {
                Text("Search")
                    .foregroundColor(themeManager.currentTheme.invertedText)
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: isSearching ? 25 : 30)
                .fill(themeManager.currentTheme.primaryAccent.opacity(isSearching ? 0.75 : 0.7))
                .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.5), radius: 15, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: isSearching ? 25 : 30)
                .stroke(themeManager.currentTheme.primaryAccent.opacity(0.8), lineWidth: 1.5)
        )
        .onTapGesture {
            if !isSearching {
                withAnimation(.spring()) { isSearching = true }
            }
        }
    }

    private func gridColumns() -> [GridItem] {
        [
            GridItem(.flexible(), spacing: 16, alignment: .top),
            GridItem(.flexible(), spacing: 16, alignment: .top)
        ]
    }

    private func refreshData() async {
        await viewModel.refreshAsync()
    }
}
