//
//  CharacterDetailViewModel.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Cache
import ComicVineAPI
import Core
import Foundation
import SwiftUI
import UIKit

#if DEBUG
private func characterDetailDebugPrint(_ message: String) {
    Swift.print("🛠 [CharacterDetailVM] \(message)")
}
#else
private func characterDetailDebugPrint(_ message: String) { }
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
    private let persistenceManager: PersistenceManagerProtocol?

    private let safeCharacterId: Int
    private let safeCharacterName: String

    // MARK: - Task Management (IMPORTANTE para cancelamento)
    private var loadDetailsTask: Task<Void, Never>?
    private var saveCharacterTask: Task<Void, Never>?
    private var loadFavoriteTask: Task<Void, Never>?

    // MARK: - Derived Properties
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
        favoritesService: FavoritesServiceProtocol? = nil,
        persistenceManager: PersistenceManagerProtocol? = nil
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
        self.persistenceManager = persistenceManager

        characterDetailDebugPrint("📊 Stats - Comics: \(character.countOfIssueAppearances)")
        characterDetailDebugPrint("📊 Stats - Teams: \(character.teams?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Powers: \(character.powers?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Enemies: \(character.characterEnemies?.count ?? 0)")
        characterDetailDebugPrint("📊 Stats - Friends: \(character.characterFriends?.count ?? 0)")

        // Debug: Verificar se persistenceManager foi passado
        characterDetailDebugPrint("🔍 PersistenceManager disponível: \(persistenceManager != nil)")

        // CORREÇÃO: Usar Task normal em vez de Task.detached
        // Salva o personagem inicial no Core Data
        if let persistenceManager = persistenceManager {
            // Task regular mantém o contexto do MainActor
            saveCharacterTask = Task { @MainActor in
                do {
                    characterDetailDebugPrint("💾 [INIT] Salvando personagem inicial no Core Data...")
                    characterDetailDebugPrint("💾 [INIT] Character ID: \(character.id)")
                    characterDetailDebugPrint("💾 [INIT] Character Name: \(character.name)")

                    try await persistenceManager.saveCharacter(character)

                    characterDetailDebugPrint("✅ [INIT] Personagem salvo com sucesso no Core Data!")

                    // Verificar imediatamente se foi salvo
                    let savedCharacter = await persistenceManager.loadCharacter(withId: character.id)
                    if savedCharacter != nil {
                        characterDetailDebugPrint("✅ [INIT] Verificação: Personagem encontrado no Core Data após salvamento")
                    } else {
                        characterDetailDebugPrint("❌ [INIT] Verificação: Personagem NÃO encontrado no Core Data após salvamento")
                    }
                } catch {
                    characterDetailDebugPrint("❌ [INIT] Erro ao salvar personagem inicial: \(error)")
                }
            }
        } else {
            characterDetailDebugPrint("⚠️ [INIT] PersistenceManager NÃO disponível - personagem não será salvo no Core Data")
            characterDetailDebugPrint("⚠️ [INIT] Favoritos NÃO funcionarão corretamente!")
        }

        characterDetailDebugPrint("🟢 CharacterDetailViewModel.init - Completed")
    }

    // CORREÇÃO 1: deinit não pode chamar métodos MainActor
    deinit {
        characterDetailDebugPrint("🔴 CharacterDetailViewModel.deinit - Cleaning up for ID: \(safeCharacterId)")
        // Cancela as tasks diretamente sem chamar o método MainActor
        loadDetailsTask?.cancel()
        saveCharacterTask?.cancel()
        loadFavoriteTask?.cancel()
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

    // MARK: - Cancel Loading Method
    /// Cancela todas as tarefas de loading em andamento
    public func cancelLoading() {
        characterDetailDebugPrint("🛑 cancelLoading called - Cancelling all loading tasks")

        // Cancela a task principal de loading
        if loadDetailsTask != nil {
            loadDetailsTask?.cancel()
            loadDetailsTask = nil
            characterDetailDebugPrint("✅ Load details task cancelled")
        }

        // Cancela task de salvamento se existir
        if saveCharacterTask != nil {
            saveCharacterTask?.cancel()
            saveCharacterTask = nil
            characterDetailDebugPrint("✅ Save character task cancelled")
        }

        // Cancela task de favoritos se existir
        if loadFavoriteTask != nil {
            loadFavoriteTask?.cancel()
            loadFavoriteTask = nil
            characterDetailDebugPrint("✅ Load favorite task cancelled")
        }

        // Reset do estado de loading
        isLoading = false

        characterDetailDebugPrint("✅ All loading tasks cancelled successfully")
    }

    public func toggleFavorite() {
        characterDetailDebugPrint("❤️ Toggle favorite called")
        characterDetailDebugPrint("❤️ Current favorite status: \(isFavorite)")
        characterDetailDebugPrint("❤️ Character ID: \(safeCharacterId)")
        characterDetailDebugPrint("❤️ PersistenceManager disponível: \(persistenceManager != nil)")
        characterDetailDebugPrint("❤️ FavoritesService disponível: \(favoritesService != nil)")

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
            // Verifica se a task foi cancelada antes de começar
            try Task.checkCancellation()

            if let useCase = fetchCharacterDetailUseCase {
                characterDetailDebugPrint("📡 Fetching character details from API...")
                let updated = try await useCase.execute(characterId: safeCharacterId)

                // Verifica cancelamento após a operação assíncrona
                try Task.checkCancellation()

                characterDetailDebugPrint("✅ Character details fetched successfully")
                characterDetailDebugPrint("📋 Updated Name: \(updated.name)")
                characterDetailDebugPrint("📋 Comics Count: \(updated.countOfIssueAppearances)")
                characterDetailDebugPrint("📋 Has Teams: \(updated.teams?.isEmpty == false)")
                characterDetailDebugPrint("📋 Has Powers: \(updated.powers?.isEmpty == false)")

                // Atualiza o model com os dados completos
                detailModel = CharacterDetailModel(from: updated)

                // Salva o personagem completo no Core Data
                if let persistenceManager = persistenceManager {
                    characterDetailDebugPrint("💾 [LOAD] Salvando personagem atualizado no Core Data...")
                    try await persistenceManager.saveCharacter(updated)
                    characterDetailDebugPrint("✅ [LOAD] Personagem atualizado salvo no Core Data")
                }
            }

            // Verifica cancelamento novamente
            try Task.checkCancellation()

            if let comicsUseCase = fetchCharacterComicsUseCase {
                characterDetailDebugPrint("📚 Fetching character comics...")
                let comics = try await comicsUseCase.execute(
                    characterId: safeCharacterId,
                    limit: 10
                )

                // Verifica cancelamento após buscar comics
                try Task.checkCancellation()

                characterDetailDebugPrint("✅ Fetched \(comics.count) comics")
                // Aqui você poderia atualizar o detailModel com os comics se necessário
            }

            // Carrega status de favorito
            scheduleLoadFavoriteStatus()

        } catch is CancellationError {
            characterDetailDebugPrint("🟡 Loading was cancelled")
            // Não faz nada, cancelamento é esperado
        } catch {
            self.error = error
            characterDetailDebugPrint("❌ Error loading details: \(error.localizedDescription)")
        }
    }

    // MARK: - Private (Core Data)
    private func scheduleSaveCharacter() {
        saveCharacterTask?.cancel()
        saveCharacterTask = Task { @MainActor [weak self] in
            guard let self,
                  let persistenceManager = self.persistenceManager else { return }

            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
                try Task.checkCancellation()

                characterDetailDebugPrint("💾 [SCHEDULE] Salvando personagem no Core Data...")
                try await persistenceManager.saveCharacter(self.detailModel.character)
                characterDetailDebugPrint("✅ [SCHEDULE] Personagem salvo com sucesso")
            } catch is CancellationError {
                characterDetailDebugPrint("🟡 [SCHEDULE] Save cancelled")
            } catch {
                characterDetailDebugPrint("❌ [SCHEDULE] Erro ao salvar: \(error)")
            }
        }
    }

    // MARK: - Private (Favorites)
    private func scheduleLoadFavoriteStatus() {
        characterDetailDebugPrint("🔍 [FAV] Scheduling load favorite status")

        loadFavoriteTask?.cancel()
        loadFavoriteTask = Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1s delay
                try Task.checkCancellation()

                let characterId = self.safeCharacterId

                characterDetailDebugPrint("🔍 [FAV] Checking favorite status for ID: \(characterId)")

                if let favService = self.favoritesService {
                    let isFav = await favService.isFavorite(characterId: characterId)

                    try Task.checkCancellation()

                    self.isFavorite = isFav
                    characterDetailDebugPrint("✅ [FAV] Favorite status loaded: \(isFav)")
                } else {
                    characterDetailDebugPrint("⚠️ [FAV] FavoritesService not available")
                    self.isFavorite = false
                }
            } catch is CancellationError {
                characterDetailDebugPrint("🟡 [FAV] Load favourite cancelled")
            } catch {
                characterDetailDebugPrint("❌ [FAV] Error loading favorite status: \(error)")
            }
        }
    }

    // CORREÇÃO 2: Usar FavoriteCharacterInput ao invés de Character
    private func scheduleSaveFavoriteStatus(currentValue: Bool) {
        characterDetailDebugPrint("💾 [FAV] Scheduling save favorite status: \(currentValue)")

        Task { @MainActor [weak self] in
            guard let self,
                  let favService = self.favoritesService else {
                characterDetailDebugPrint("⚠️ [FAV] Cannot save - FavoritesService not available")
                return
            }

            do {
                let characterId = self.safeCharacterId

                if currentValue {
                    characterDetailDebugPrint("➕ [FAV] Adding to favorites...")

                    // Carrega o personagem do Core Data ou usa o atual
                    let characterToSave: ComicVineAPI.Character
                    if let savedCharacter = await persistenceManager?.loadCharacter(withId: characterId) {
                        characterDetailDebugPrint("✅ [FAV] Using character from Core Data")
                        characterToSave = savedCharacter
                    } else {
                        characterDetailDebugPrint("⚠️ [FAV] Character not in Core Data, using current model")
                        characterToSave = self.detailModel.character

                        // Tenta salvar no Core Data primeiro
                        if let pm = self.persistenceManager {
                            try await pm.saveCharacter(characterToSave)
                            characterDetailDebugPrint("✅ [FAV] Character saved to Core Data")
                        }
                    }

                    // CORREÇÃO: Cria FavoriteCharacterInput ao invés de passar Character diretamente
                    let favoriteInput = FavoriteCharacterInput(
                        id: characterToSave.id,
                        name: characterToSave.name,
                        thumbnailURL: URL(string: characterToSave.image.smallUrl ?? characterToSave.image.thumbUrl ?? "")
                    )

                    try await favService.addFavorite(character: favoriteInput)
                    characterDetailDebugPrint("✅ [FAV] Added to favorites successfully")
                } else {
                    characterDetailDebugPrint("➖ [FAV] Removing from favorites...")
                    try await favService.removeFavorite(characterId: characterId)
                    characterDetailDebugPrint("✅ [FAV] Removed from favorites successfully")
                }

                // Confirma o estado final
                let finalStatus = await favService.isFavorite(characterId: characterId)
                self.isFavorite = finalStatus
                characterDetailDebugPrint("✅ [FAV] Final status confirmed: \(finalStatus)")

            } catch {
                // Reverte em caso de erro
                self.isFavorite = !currentValue
                characterDetailDebugPrint("❌ [FAV] Error saving favorite status: \(error)")
                characterDetailDebugPrint("↩️ [FAV] Reverted to: \(self.isFavorite)")
            }
        }
    }
}
