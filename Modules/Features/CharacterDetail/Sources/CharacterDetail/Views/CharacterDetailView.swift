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
    private let onComicsSelected: (() -> Void)?

    // Debug tracking
    @State private var appearCount = 0

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
            Color.black.ignoresSafeArea()

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

            // Navigation Bar Overlay
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
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Character Name
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.detailModel.character.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Real Name (se disponível)
                if let realName = viewModel.detailModel.character.realName,
                   !realName.isEmpty {
                    Text("Real Name: \(realName)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                // Publisher (se disponível)
                if let publisher = viewModel.detailModel.character.publisher?.name {
                    HStack(spacing: 4) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 12))
                        Text(publisher)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.top, 4)
                }
            }
            .onAppear {
                print("📝 Displaying character: \(viewModel.detailModel.character.name)")
            }

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

            // Additional Info (se disponível após carregar detalhes)
            additionalInfoSection

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
                .fill(Color.black)
                .shadow(color: .red.opacity(0.3), radius: 20, x: 0, y: -10)
        )
    }

    @ViewBuilder
    private var additionalInfoSection: some View {
        let character = viewModel.detailModel.character

        // Teams
        if let teams = character.teams, !teams.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("TEAMS")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .tracking(2)

                ForEach(teams.prefix(3), id: \.id) { team in
                    HStack {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text(team.name)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
            }
        }

        // Powers
        if let powers = character.powers, !powers.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("POWERS")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .tracking(2)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(powers, id: \.id) { power in
                            Text(power.name)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.yellow)
                                )
                        }
                    }
                }
            }
        }
    }
}
