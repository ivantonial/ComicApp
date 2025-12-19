//
//  SearchView.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import CharacterList
import ComicsList
import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @ObservedObject private var themeManager = ThemeManager.shared
    @FocusState private var isSearchFieldFocused: Bool
    @Namespace private var searchNamespace

    private let onCharacterSelected: ((Character) -> Void)?
    private let onComicSelected: ((Comic) -> Void)?

    public init(
        viewModel: SearchViewModel,
        onCharacterSelected: ((Character) -> Void)? = nil,
        onComicSelected: ((Comic) -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onCharacterSelected = onCharacterSelected
        self.onComicSelected = onComicSelected
    }

    public var body: some View {
        ZStack {
            themeManager.currentTheme.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Search Type Selector
                searchTypeSelector

                // Search Header
                searchHeader

                // Filter Pills - Sem transição, sempre no mesmo lugar
                if viewModel.hasResults {
                    filterSection
                        .animation(nil, value: viewModel.searchType)
                }

                // Main Content
                contentView
            }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    dismissKeyboard()
                }
        )
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Dismiss Keyboard
    private func dismissKeyboard() {
        isSearchFieldFocused = false
    }

    // MARK: - Search Type Selector
    private var searchTypeSelector: some View {
        HStack(spacing: 0) {
            ForEach(SearchType.allCases, id: \.self) { type in
                Button(action: {
                    dismissKeyboard()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.switchSearchType(type)
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: type.icon)
                            .font(.system(size: 20))

                        Text(type.rawValue)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(
                        viewModel.searchType == type ?
                        themeManager.currentTheme.primaryBackground :
                        themeManager.currentTheme.primaryText
                    )
                    .background(
                        viewModel.searchType == type ?
                        themeManager.currentTheme.primaryAccent :
                        Color.clear
                    )
                }
            }
        }
        .background(themeManager.currentTheme.secondaryBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 10)
    }

    // MARK: - Search Header
    private var searchHeader: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(themeManager.currentTheme.tertiaryText)
                    .font(.system(size: 18))

                TextField("Search Comics characters...", text: $viewModel.searchText)
                    .foregroundColor(themeManager.currentTheme.primaryText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .focused($isSearchFieldFocused)
                    .onSubmit {
                        dismissKeyboard()
                        viewModel.search()
                    }

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(themeManager.currentTheme.tertiaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(themeManager.currentTheme.searchBarBackground)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)

            // Suggestions
            if !viewModel.suggestions.isEmpty {
                suggestionsView
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
            }
        }
        .background(themeManager.currentTheme.primaryBackground)
    }

    // MARK: - Suggestions View
    private var suggestionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(viewModel.suggestions.enumerated()), id: \.offset) { _, suggestion in
                    Button(action: {
                        dismissKeyboard()
                        viewModel.selectSuggestion(suggestion)
                    }) {
                        Text(suggestion)
                            .font(.caption)
                            .foregroundColor(themeManager.currentTheme.invertedText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(themeManager.currentTheme.primaryAccent.opacity(0.8))
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }

    // MARK: - Filter Section
    private var filterSection: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.currentFilters, id: \.self) { filter in
                        FilterChip(
                            title: filter.title,
                            icon: filter.icon,
                            isSelected: viewModel.selectedFilter == filter,
                            action: {
                                dismissKeyboard()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.updateFilter(filter)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 5)
        .background(themeManager.currentTheme.primaryBackground)
        .id("filterSection_\(viewModel.searchType)")
    }

    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isSearching {
            loadingView
                .transition(.opacity)
        } else if viewModel.hasResults {
            GeometryReader { geometry in
                Group {
                    switch viewModel.searchType {
                    case .characters:
                        characterResultsView
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .id("characters_results")
                    case .comics:
                        comicResultsView
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .id("comics_results")
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: viewModel.searchType)
            }
        } else if !viewModel.searchText.isEmpty {
            noResultsView
                .transition(.opacity)
        } else {
            defaultView
                .transition(.opacity)
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: themeManager.currentTheme.primaryAccent))
                .scaleEffect(1.5)
            Text("Searching...")
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.secondaryText)
                .padding(.top)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - No Results View
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 80))
                .foregroundColor(themeManager.currentTheme.tertiaryText)

            Text("No Results Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.primaryText)

            Text("Try searching with different keywords")
                .font(.body)
                .foregroundColor(themeManager.currentTheme.secondaryText)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Default View (Recent Searches)
    private var defaultView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recent Searches
                if !viewModel.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Recent Searches")
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.primaryText)

                            Spacer()

                            Button("Clear") {
                                dismissKeyboard()
                                viewModel.clearRecentSearches()
                            }
                            .font(.caption)
                            .foregroundColor(themeManager.currentTheme.primaryAccent)
                        }

                        ForEach(viewModel.recentSearches, id: \.self) { search in
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(themeManager.currentTheme.tertiaryText)
                                    .font(.caption)

                                Text(search)
                                    .foregroundColor(themeManager.currentTheme.primaryText)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(themeManager.currentTheme.secondaryBackground)
                            .cornerRadius(8)
                            .onTapGesture {
                                dismissKeyboard()
                                viewModel.searchText = search
                                viewModel.search()
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Popular Characters
                suggestedCharacters
            }
            .padding(.vertical)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    // MARK: - Suggested Characters
    private var suggestedCharacters: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Popular Characters")
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.primaryText)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(["Spider-Man", "Iron Man", "Captain America", "Thor", "Hulk",
                            "Black Widow", "Doctor Strange", "Black Panther", "Wolverine", "Deadpool"],
                           id: \.self) { name in
                        VStack {
                            Circle()
                                .fill(themeManager.currentTheme.tertiaryBackground)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(themeManager.currentTheme.tertiaryText)
                                )

                            Text(name)
                                .font(.caption2)
                                .foregroundColor(themeManager.currentTheme.secondaryText)
                                .lineLimit(1)
                        }
                        .frame(width: 70)
                        .onTapGesture {
                            dismissKeyboard()
                            viewModel.searchText = name
                            viewModel.search()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Character Results
    private var characterResultsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredCharacters) { character in
                    SearchResultCard(character: character)
                        .onTapGesture {
                            dismissKeyboard()
                            onCharacterSelected?(character)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    // MARK: - Comic Results
    private var comicResultsView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.filteredComics) { comic in
                    ComicCardView(
                        model: ComicCardModel(from: comic),
                        onTap: {
                            dismissKeyboard()
                            onComicSelected?(comic)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

// MARK: - Supporting Views
struct SearchResultCard: View {
    let character: Character
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack(spacing: 15) {
            // Character Image (ComicVine)
            AsyncImage(url: character.image.bestQualityUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                default:
                    Circle()
                        .fill(themeManager.currentTheme.tertiaryBackground)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(themeManager.currentTheme.tertiaryText)
                        )
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.primaryText)

                if let description = character.deck,
                   !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                        .lineLimit(2)
                }

                HStack(spacing: 15) {
                    Label("\(character.countOfIssueAppearances)", systemImage: "book.fill")

                    let seriesCount = character.volumeCredits?.count ?? 0
                    Label("\(seriesCount)", systemImage: "tv.fill")
                }
                .font(.caption2)
                .foregroundColor(themeManager.currentTheme.primaryAccent)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.currentTheme.tertiaryText)
                .font(.caption)
        }
        .padding()
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(10)
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundColor(
                isSelected ?
                themeManager.currentTheme.primaryBackground :
                themeManager.currentTheme.primaryText
            )
            .background(
                Capsule()
                    .fill(
                        isSelected ?
                        themeManager.currentTheme.primaryAccent :
                        themeManager.currentTheme.secondaryBackground
                    )
            )
            .overlay(
                Capsule()
                    .stroke(
                        themeManager.currentTheme.borderColor,
                        lineWidth: isSelected ? 0 : 1
                    )
            )
        }
    }
}
