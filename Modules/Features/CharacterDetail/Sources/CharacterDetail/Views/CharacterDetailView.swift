//
//  CharacterDetailView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import Core
import DesignSystem
import SwiftUI

public struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared
    private let onComicsSelected: (() -> Void)?

    // Debug tracking
    @State private var appearCount = 0
    @State private var hasLoadedOnce = false

    public init(
        viewModel: CharacterDetailViewModel,
        onComicsSelected: (() -> Void)? = nil
    ) {
        print("🟦 CharacterDetailView.init")
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onComicsSelected = onComicsSelected
    }

    public var body: some View {
        ZStack {
            // CORREÇÃO: Mostrar loading APENAS quando está carregando pela primeira vez
            if viewModel.isLoading && !hasLoadedOnce {
                FullScreenLoadingComponent(
                    logoImage: "Loading", // Use o nome correto da imagem
                    loadingText: "Loading",
                    onBack: {
                        print("🔙 Cancelling loading and going back")
                        viewModel.cancelLoading()
                        dismiss()
                    }
                )
                .transition(.opacity)
            } else {
                // Conteúdo principal - só mostra após o primeiro loading
                mainContent
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearCount += 1
            print("🟩 CharacterDetailView.onAppear - Count: \(appearCount)")

            // Só carrega na primeira vez que aparecer
            if appearCount == 1 {
                viewModel.loadCharacterDetails()
            }
        }
        .onDisappear {
            print("🟥 CharacterDetailView.onDisappear")
            viewModel.cancelLoading()
        }
        // IMPORTANTE: Observar mudanças no isLoading
        .onChange(of: viewModel.isLoading) { newValue in
            print("📊 isLoading changed to: \(newValue)")
            // Quando terminar de carregar pela primeira vez, marcar como carregado
            if !newValue && !hasLoadedOnce {
                withAnimation {
                    hasLoadedOnce = true
                }
            }
        }
    }

    // MARK: - Main Content
    private var mainContent: some View {
        ZStack {
            themeManager.currentTheme.primaryBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    CharacterDetailHeaderImageView(
                        comicVineImage: viewModel.detailModel.character.image
                    )

                    contentSection
                }
            }
            .ignoresSafeArea(edges: .top)

            // Navigation Bar Overlay (sempre visível no conteúdo principal)
            CharacterDetailNavigationBarView(
                isFavorite: viewModel.isFavorite,
                onBack: {
                    print("🔙 Back button pressed")
                    dismiss()
                },
                onToggleFavorite: {
                    print("❤️ Favorite button pressed")
                    viewModel.toggleFavorite()
                }
            )
        }
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Character Info Section (Nome, Real Name, Publisher)
            CharacterDetailInfoSectionView(
                character: viewModel.detailModel.character
            )

            // Description com deck e description HTML
            CharacterDetailDescriptionView(
                name: viewModel.detailModel.character.name,
                deck: viewModel.detailModel.character.deck,
                description: viewModel.detailModel.character.description
            )

            // Stats Grid
            CharacterDetailStatsGridView(
                stats: viewModel.detailModel.stats
            )

            // TEAMS Section - Só mostra se tiver dados
            if let teams = viewModel.detailModel.character.teams, !teams.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TEAMS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .tracking(2)

                    ForEach(teams.prefix(3), id: \.id) { team in
                        HStack {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.currentTheme.warningAccent)
                            Text(team.name)
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.currentTheme.primaryText)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.3), value: teams.count)
            }

            // POWERS Section - Só mostra se tiver dados
            if let powers = viewModel.detailModel.character.powers, !powers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("POWERS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .tracking(2)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(powers, id: \.id) { power in
                                Text(power.name)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(themeManager.currentTheme.primaryBackground)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(themeManager.currentTheme.warningAccent)
                                    )
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.3), value: powers.count)
            }

            // Actions
            CharacterDetailActionsView(
                hasComics: viewModel.hasComics,
                comicsCount: viewModel.detailModel.character.countOfIssueAppearances,
                wikiURL: URL(string: viewModel.detailModel.character.siteDetailUrl),
                onComicsSelected: onComicsSelected
            )

            // Related Content (se houver)
            if viewModel.hasRelatedContent {
                CharacterDetailRelatedContentView(
                    relatedContent: viewModel.detailModel.relatedContent
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, -40)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(themeManager.currentTheme.cardBackground)
                .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.3), radius: 20, x: 0, y: -10)
        )
    }
}
