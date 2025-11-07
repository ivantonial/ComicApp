//
//  CharacterDetailViewModel.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Core
import Foundation
import ComicVineAPI
import SwiftUI
import UIKit

#if DEBUG
fileprivate func characterDetailDebugPrint(_ message: String) {
    Swift.print("🛠 [CharacterDetailVM] \(message)")
}
#else
fileprivate func characterDetailDebugPrint(_ message: String) { }
#endif

@MainActor
public final class CharacterDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public private(set) var detailModel: CharacterDetailModel
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?
    @Published public private(set) var isFavorite = false

    // MARK: - Private Properties
    private let fetchCharacterDetailUseCase: FetchCharacterDetailUseCase?
    private let fetchCharacterComicsUseCase: FetchCharacterComicsUseCase?
    private let favoritesService: FavoritesServiceProtocol?

    private let safeCharacterId: Int
    private let safeCharacterName: String

    private var loadDetailsTask: Task<Void, Never>?

    // MARK: - Derived Properties (CORRIGIDO)
    public var hasRelatedContent: Bool {
        // Verifica se tem teams, powers, enemies ou friends
        let character = detailModel.character
        return (character.teams?.isEmpty == false) ||
               (character.powers?.isEmpty == false) ||
               (character.characterEnemies?.isEmpty == false) ||
               (character.characterFriends?.isEmpty == false)
    }

    public var hasComics: Bool {
        // USA countOfIssueAppearances DIRETAMENTE
        detailModel.character.countOfIssueAppearances > 0
    }

    public var shareItems: [Any] { detailModel.shareInfo.shareItems }

    // MARK: - Initialization
    public init(
        character: ComicVineAPI.Character,
        fetchCharacterDetailUseCase: FetchCharacterDetailUseCase? = nil,
        fetchCharacterComicsUseCase: FetchCharacterComicsUseCase? = nil,
        favoritesService: FavoritesServiceProtocol? = nil
    ) {
        characterDetailDebugPrint("🟢 CharacterDetailViewModel.init - Starting")

        self.safeCharacterId = character.id
        self.safeCharacterName = character.name

        characterDetailDebugPrint("📋 Character ID: \(safeCharacterId)")
        characterDetailDebugPrint("📋 Character Name: \(safeCharacterName)")
        characterDetailDebugPrint("📋 Has Image: \(character.image.originalUrl != nil)")

        self.detailModel = CharacterDetailModel(from: character)
        self.fetchCharacterDetailUseCase = fetchCharacterDetailUseCase
        self.fetchCharacterComicsUseCase = fetchCharacterComicsUseCase
        self.favoritesService = favoritesService

        characterDetailDebugPrint("📊 Stats - Comics: \(character.countOfIssueAppearances)")
        characterDetailDebugPrint("📊 Stats - Teams: \(character.teams?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Powers: \(character.powers?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Enemies: \(character.characterEnemies?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Friends: \(character.characterFriends?.count ?? 0)")
        characterDetailDebugPrint("🟢 CharacterDetailViewModel.init - Completed")
    }

    deinit {
        characterDetailDebugPrint("🔴 CharacterDetailViewModel.deinit - Cleaning up for ID: \(safeCharacterId)")
        loadDetailsTask?.cancel()
    }

    // MARK: - Public API
    public func loadCharacterDetails() {
        characterDetailDebugPrint("🔥 loadCharacterDetails called")

        loadDetailsTask?.cancel()
        guard !isLoading else {
            characterDetailDebugPrint("⚠️ Already loading, skipping...")
            return
        }

        loadDetailsTask = Task { [weak self] in
            guard let self else { return }
            await self.performLoadCharacterDetails()
        }
    }

    public func toggleFavorite() {
        characterDetailDebugPrint("❤️ Toggle favorite called")
        // Otimista: atualiza UI imediatamente
        isFavorite.toggle()
        scheduleSaveFavoriteStatus(currentValue: isFavorite)
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
    }

    public func refresh() {
        characterDetailDebugPrint("🔄 Refresh called")
        loadDetailsTask?.cancel()
        loadDetailsTask = Task { [weak self] in
            guard let self else { return }
            await self.performLoadCharacterDetails()
        }
    }

    // MARK: - Private (Loading)
    private func performLoadCharacterDetails() async {
        characterDetailDebugPrint("🚀 performLoadCharacterDetails - Starting")
        isLoading = true
        error = nil
        defer {
            isLoading = false
            characterDetailDebugPrint("🏁 performLoadCharacterDetails - Completed")
        }

        do {
            if let useCase = fetchCharacterDetailUseCase {
                characterDetailDebugPrint("📡 Fetching character details from API...")
                let updated = try await useCase.execute(characterId: safeCharacterId)
                characterDetailDebugPrint("✅ Character details fetched successfully")
                characterDetailDebugPrint("📋 Updated Name: \(updated.name)")
                characterDetailDebugPrint("📋 Comics Count: \(updated.countOfIssueAppearances)")
                characterDetailDebugPrint("📋 Has Teams: \(updated.teams?.isEmpty == false)")
                characterDetailDebugPrint("📋 Has Powers: \(updated.powers?.isEmpty == false)")

                // Atualiza o model com os dados completos
                detailModel = CharacterDetailModel(from: updated)
            }

            if let comicsUseCase = fetchCharacterComicsUseCase {
                characterDetailDebugPrint("📚 Fetching character comics...")
                let comics = try await comicsUseCase.execute(
                    characterId: safeCharacterId,
                    limit: 10
                )
                characterDetailDebugPrint("✅ Fetched \(comics.count) comics")
                // Aqui você poderia atualizar o detailModel com os comics se necessário
            }

            // Carrega status de favorito
            scheduleLoadFavoriteStatus()
        } catch {
            self.error = error
            characterDetailDebugPrint("❌ Error loading details: \(error.localizedDescription)")
        }
    }

    // MARK: - Favorites (non-blocking)
    private func scheduleLoadFavoriteStatus() {
        characterDetailDebugPrint("⭐ Loading favorite status...")

        if let service = favoritesService {
            Task.detached { [safeCharacterId] in
                let status = await service.isFavorite(characterId: safeCharacterId)
                await MainActor.run {
                    self.isFavorite = status
                    characterDetailDebugPrint("☁️ Loaded from service: \(status)")
                }
            }
            return
        }

        // Fallback local
        Task.detached { [safeCharacterId] in
            let favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []
            let status = favorites.contains(safeCharacterId)
            await MainActor.run {
                self.isFavorite = status
                characterDetailDebugPrint("📱 Loaded from UserDefaults: \(status)")
            }
        }
    }
    private func scheduleSaveFavoriteStatus(currentValue: Bool) {
        characterDetailDebugPrint("💾 Saving favorite status (async)...")

        // Caminho com serviço remoto de favoritos
        if let service = favoritesService {
            Task { [weak self] in
                guard let self else { return }

                do {
                    if currentValue {
                        // Aqui estamos no MainActor, acesso direto é seguro
                        let imageURL = self.detailModel.character.image.bestQualityUrl

                        let input = FavoriteCharacterInput(
                            id: self.safeCharacterId,
                            name: self.safeCharacterName,
                            thumbnailURL: imageURL
                        )

                        try await service.addFavorite(character: input)
                        characterDetailDebugPrint("✅ Added to favorites")
                    } else {
                        try await service.removeFavorite(characterId: self.safeCharacterId)
                        characterDetailDebugPrint("✅ Removed from favorites")
                    }
                } catch {
                    characterDetailDebugPrint("❌ Error saving favorite: \(error)")
                    // Reverte o toggle otimista em caso de erro
                    self.isFavorite.toggle()
                }
            }
            return
        }

        // Fallback local (UserDefaults)
        Task { [weak self] in
            guard let self else { return }

            var favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []

            if currentValue {
                if !favorites.contains(self.safeCharacterId) {
                    favorites.append(self.safeCharacterId)
                }
            } else {
                favorites.removeAll { $0 == self.safeCharacterId }
            }

            UserDefaults.standard.set(favorites, forKey: "FavoriteCharacters")
            UserDefaults.standard.synchronize()
            characterDetailDebugPrint("📱 Saved to UserDefaults")
        }
    }
}
