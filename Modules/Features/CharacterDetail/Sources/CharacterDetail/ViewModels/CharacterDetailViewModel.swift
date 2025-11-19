//
//  CharacterDetailViewModel.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

//import Cache
//import ComicVineAPI
//import Core
//import Foundation
//import SwiftUI
//import UIKit
//
//#if DEBUG
//private func characterDetailDebugPrint(_ message: String) {
//    Swift.print("🛠 [CharacterDetailVM] \(message)")
//}
//#else
//private func characterDetailDebugPrint(_ message: String) { }
//#endif
//
//@MainActor
//public final class CharacterDetailViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published public private(set) var detailModel: CharacterDetailModel
//    @Published public private(set) var isLoading = false
//    @Published public private(set) var error: Error?
//    @Published public private(set) var isFavorite = false
//
//    // MARK: - Private Properties
//    private let fetchCharacterDetailUseCase: FetchCharacterDetailUseCase?
//    private let fetchCharacterComicsUseCase: FetchCharacterComicsUseCase?
//    private let favoritesService: FavoritesServiceProtocol?
//    private let persistenceManager: PersistenceManagerProtocol?
//
//    private let safeCharacterId: Int
//    private let safeCharacterName: String
//
//    private var loadDetailsTask: Task<Void, Never>?
//
//    // MARK: - Derived Properties (CORRIGIDO)
//    public var hasRelatedContent: Bool {
//        // Verifica se tem teams, powers, enemies ou friends
//        let character = detailModel.character
//        return (character.teams?.isEmpty == false) ||
//               (character.powers?.isEmpty == false) ||
//               (character.characterEnemies?.isEmpty == false) ||
//               (character.characterFriends?.isEmpty == false)
//    }
//
//    public var hasComics: Bool {
//        // USA countOfIssueAppearances DIRETAMENTE
//        detailModel.character.countOfIssueAppearances > 0
//    }
//
//    public var shareItems: [Any] { detailModel.shareInfo.shareItems }
//
//    // MARK: - Initialization
//    public init(
//        character: ComicVineAPI.Character,
//        fetchCharacterDetailUseCase: FetchCharacterDetailUseCase? = nil,
//        fetchCharacterComicsUseCase: FetchCharacterComicsUseCase? = nil,
//        favoritesService: FavoritesServiceProtocol? = nil,
//        persistenceManager: PersistenceManagerProtocol? = nil
//    ) {
//        characterDetailDebugPrint("🟢 CharacterDetailViewModel.init - Starting")
//
//        self.safeCharacterId = character.id
//        self.safeCharacterName = character.name
//
//        characterDetailDebugPrint("📋 Character ID: \(safeCharacterId)")
//        characterDetailDebugPrint("📋 Character Name: \(safeCharacterName)")
//        characterDetailDebugPrint("📋 Has Image: \(character.image.originalUrl != nil)")
//
//        self.detailModel = CharacterDetailModel(from: character)
//        self.fetchCharacterDetailUseCase = fetchCharacterDetailUseCase
//        self.fetchCharacterComicsUseCase = fetchCharacterComicsUseCase
//        self.favoritesService = favoritesService
//        self.persistenceManager = persistenceManager
//
//        characterDetailDebugPrint("📊 Stats - Comics: \(character.countOfIssueAppearances)")
//        characterDetailDebugPrint("📊 Stats - Teams: \(character.teams?.count ?? 0)")
//        characterDetailDebugPrint("📊 Stats - Powers: \(character.powers?.count ?? 0)")
//        characterDetailDebugPrint("📊 Stats - Enemies: \(character.characterEnemies?.count ?? 0)")
//        characterDetailDebugPrint("📊 Stats - Friends: \(character.characterFriends?.count ?? 0)")
//
//        // Debug: Verificar se persistenceManager foi passado
//        characterDetailDebugPrint("🔍 PersistenceManager disponível: \(persistenceManager != nil)")
//
//        // Salva o personagem inicial no Core Data IMEDIATAMENTE
//        if let persistenceManager = persistenceManager {
//            // IMPORTANTE: Usar Task.detached para garantir que execute mesmo se o view for desmontado
//            Task.detached {
//                do {
//                    characterDetailDebugPrint("💾 [INIT] Salvando personagem inicial no Core Data...")
//                    characterDetailDebugPrint("💾 [INIT] Character ID: \(character.id)")
//                    characterDetailDebugPrint("💾 [INIT] Character Name: \(character.name)")
//
//                    try await persistenceManager.saveCharacter(character)
//
//                    characterDetailDebugPrint("✅ [INIT] Personagem salvo com sucesso no Core Data!")
//
//                    // Verificar imediatamente se foi salvo
//                    let savedCharacter = await persistenceManager.loadCharacter(withId: character.id)
//                    if savedCharacter != nil {
//                        characterDetailDebugPrint("✅ [INIT] Verificação: Personagem encontrado no Core Data após salvamento")
//                    } else {
//                        characterDetailDebugPrint("❌ [INIT] Verificação: Personagem NÃO encontrado no Core Data após salvamento")
//                    }
//                } catch {
//                    characterDetailDebugPrint("❌ [INIT] Erro ao salvar personagem inicial: \(error)")
//                }
//            }
//        } else {
//            characterDetailDebugPrint("⚠️ [INIT] PersistenceManager NÃO disponível - personagem não será salvo no Core Data")
//            characterDetailDebugPrint("⚠️ [INIT] Favoritos NÃO funcionarão corretamente!")
//        }
//
//        characterDetailDebugPrint("🟢 CharacterDetailViewModel.init - Completed")
//    }
//
//    deinit {
//        characterDetailDebugPrint("🔴 CharacterDetailViewModel.deinit - Cleaning up for ID: \(safeCharacterId)")
//        loadDetailsTask?.cancel()
//    }
//
//    // MARK: - Public API
//    public func loadCharacterDetails() {
//        characterDetailDebugPrint("🔥 loadCharacterDetails called")
//
//        loadDetailsTask?.cancel()
//        guard !isLoading else {
//            characterDetailDebugPrint("⚠️ Already loading, skipping...")
//            return
//        }
//
//        loadDetailsTask = Task { [weak self] in
//            guard let self else { return }
//            await self.performLoadCharacterDetails()
//        }
//    }
//
//    public func toggleFavorite() {
//        characterDetailDebugPrint("❤️ Toggle favorite called")
//        characterDetailDebugPrint("❤️ Current favorite status: \(isFavorite)")
//        characterDetailDebugPrint("❤️ Character ID: \(safeCharacterId)")
//        characterDetailDebugPrint("❤️ PersistenceManager disponível: \(persistenceManager != nil)")
//        characterDetailDebugPrint("❤️ FavoritesService disponível: \(favoritesService != nil)")
//
//        // Otimista: atualiza UI imediatamente
//        isFavorite.toggle()
//        scheduleSaveFavoriteStatus(currentValue: isFavorite)
//
//        // Haptic feedback
//        let impact = UIImpactFeedbackGenerator(style: .medium)
//        impact.prepare()
//        impact.impactOccurred()
//    }
//
//    public func refresh() {
//        characterDetailDebugPrint("🔄 Refresh called")
//        loadDetailsTask?.cancel()
//        loadDetailsTask = Task { [weak self] in
//            guard let self else { return }
//            await self.performLoadCharacterDetails()
//        }
//    }
//
//    // MARK: - Private (Loading)
//    private func performLoadCharacterDetails() async {
//        characterDetailDebugPrint("🚀 performLoadCharacterDetails - Starting")
//        isLoading = true
//        error = nil
//        defer {
//            isLoading = false
//            characterDetailDebugPrint("🏁 performLoadCharacterDetails - Completed")
//        }
//
//        do {
//            if let useCase = fetchCharacterDetailUseCase {
//                characterDetailDebugPrint("📡 Fetching character details from API...")
//                let updated = try await useCase.execute(characterId: safeCharacterId)
//                characterDetailDebugPrint("✅ Character details fetched successfully")
//                characterDetailDebugPrint("📋 Updated Name: \(updated.name)")
//                characterDetailDebugPrint("📋 Comics Count: \(updated.countOfIssueAppearances)")
//                characterDetailDebugPrint("📋 Has Teams: \(updated.teams?.isEmpty == false)")
//                characterDetailDebugPrint("📋 Has Powers: \(updated.powers?.isEmpty == false)")
//
//                // Atualiza o model com os dados completos
//                detailModel = CharacterDetailModel(from: updated)
//
//                // Salva o personagem completo no Core Data
//                if let persistenceManager = persistenceManager {
//                    characterDetailDebugPrint("💾 [LOAD] Salvando personagem atualizado no Core Data...")
//                    try await persistenceManager.saveCharacter(updated)
//                    characterDetailDebugPrint("✅ [LOAD] Personagem atualizado salvo no Core Data")
//                }
//            }
//
//            if let comicsUseCase = fetchCharacterComicsUseCase {
//                characterDetailDebugPrint("📚 Fetching character comics...")
//                let comics = try await comicsUseCase.execute(
//                    characterId: safeCharacterId,
//                    limit: 10
//                )
//                characterDetailDebugPrint("✅ Fetched \(comics.count) comics")
//                // Aqui você poderia atualizar o detailModel com os comics se necessário
//            }
//
//            // Carrega status de favorito
//            scheduleLoadFavoriteStatus()
//        } catch {
//            self.error = error
//            characterDetailDebugPrint("❌ Error loading details: \(error.localizedDescription)")
//        }
//    }
//
//    // MARK: - Favorites (non-blocking)
//    private func scheduleLoadFavoriteStatus() {
//        characterDetailDebugPrint("⭐ Loading favorite status...")
//
//        if let service = favoritesService {
//            Task.detached { [safeCharacterId] in
//                let status = await service.isFavorite(characterId: safeCharacterId)
//                await MainActor.run {
//                    self.isFavorite = status
//                    characterDetailDebugPrint("☁️ Loaded from service: \(status)")
//                }
//            }
//            return
//        }
//
//        // Fallback local
//        Task.detached { [safeCharacterId] in
//            let favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []
//            let status = favorites.contains(safeCharacterId)
//            await MainActor.run {
//                self.isFavorite = status
//                characterDetailDebugPrint("📱 Loaded from UserDefaults: \(status)")
//            }
//        }
//    }
//
//    private func scheduleSaveFavoriteStatus(currentValue: Bool) {
//        characterDetailDebugPrint("💾 Saving favorite status (async)...")
//        characterDetailDebugPrint("💾 New favorite value: \(currentValue)")
//
//        // Caminho com serviço remoto de favoritos
//        if let service = favoritesService {
//            Task { [weak self] in
//                guard let self else { return }
//
//                do {
//                    if currentValue {
//                        characterDetailDebugPrint("💾 Preparando para adicionar aos favoritos...")
//
//                        // IMPORTANTE: Primeiro garantir que o personagem está salvo no Core Data
//                        if let persistenceManager = self.persistenceManager {
//                            // Verificar se o personagem já está no Core Data
//                            let existingCharacter = await persistenceManager.loadCharacter(withId: self.safeCharacterId)
//
//                            if existingCharacter == nil {
//                                characterDetailDebugPrint("⚠️ Personagem não encontrado no Core Data, salvando agora...")
//                                // Se não estiver, salvar o personagem atual
//                                try await persistenceManager.saveCharacter(self.detailModel.character)
//                                characterDetailDebugPrint("✅ Personagem salvo no Core Data antes de favoritar")
//                            } else {
//                                characterDetailDebugPrint("✅ Personagem já existe no Core Data")
//                            }
//                        }
//
//                        // Agora adicionar aos favoritos
//                        let imageURL = self.detailModel.character.image.bestQualityUrl
//                        let input = FavoriteCharacterInput(
//                            id: self.safeCharacterId,
//                            name: self.safeCharacterName,
//                            thumbnailURL: imageURL
//                        )
//
//                        try await service.addFavorite(character: input)
//                        characterDetailDebugPrint("✅ Added to favorites")
//                    } else {
//                        characterDetailDebugPrint("💾 Removendo dos favoritos...")
//                        try await service.removeFavorite(characterId: self.safeCharacterId)
//                        characterDetailDebugPrint("✅ Removed from favorites")
//                    }
//                } catch {
//                    characterDetailDebugPrint("❌ Error saving favorite: \(error)")
//                    // Reverte o toggle otimista em caso de erro
//                    self.isFavorite.toggle()
//                }
//            }
//            return
//        }
//
//        // Fallback local (UserDefaults)
//        Task { [weak self] in
//            guard let self else { return }
//
//            var favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []
//
//            if currentValue {
//                if !favorites.contains(self.safeCharacterId) {
//                    favorites.append(self.safeCharacterId)
//                }
//            } else {
//                favorites.removeAll { $0 == self.safeCharacterId }
//            }
//
//            UserDefaults.standard.set(favorites, forKey: "FavoriteCharacters")
//            UserDefaults.standard.synchronize()
//            characterDetailDebugPrint("📱 Saved to UserDefaults")
//        }
//    }
//}
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

    deinit {
        characterDetailDebugPrint("🔴 CharacterDetailViewModel.deinit - Cleaning up for ID: \(safeCharacterId)")
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

                // Salva o personagem completo no Core Data
                if let persistenceManager = persistenceManager {
                    characterDetailDebugPrint("💾 [LOAD] Salvando personagem atualizado no Core Data...")
                    try await persistenceManager.saveCharacter(updated)
                    characterDetailDebugPrint("✅ [LOAD] Personagem atualizado salvo no Core Data")
                }
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

        // CORREÇÃO: Usar Task normal em vez de Task.detached
        loadFavoriteTask?.cancel()

        if let service = favoritesService {
            loadFavoriteTask = Task { @MainActor [weak self] in
                guard let self else { return }
                let status = await service.isFavorite(characterId: self.safeCharacterId)
                self.isFavorite = status
                characterDetailDebugPrint("☁️ Loaded from service: \(status)")
            }
            return
        }

        // Fallback local - também corrigido
        loadFavoriteTask = Task { @MainActor [weak self] in
            guard let self else { return }
            let favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []
            let status = favorites.contains(self.safeCharacterId)
            self.isFavorite = status
            characterDetailDebugPrint("📱 Loaded from UserDefaults: \(status)")
        }
    }

    private func scheduleSaveFavoriteStatus(currentValue: Bool) {
        characterDetailDebugPrint("💾 Saving favorite status (async)...")
        characterDetailDebugPrint("💾 New favorite value: \(currentValue)")

        // Caminho com serviço remoto de favoritos
        if let service = favoritesService {
            // CORREÇÃO: Usar Task normal
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    if currentValue {
                        let favoriteInput = FavoriteCharacterInput(
                                id: self.safeCharacterId,
                                name: self.safeCharacterName,
                                thumbnailURL: self.detailModel.character.image.bestQualityUrl
                            )
                            try await service.addFavorite(character: favoriteInput)
                            characterDetailDebugPrint("☁️ [Service] Added as favorite")
                    } else {
                        try await service.removeFavorite(characterId: self.safeCharacterId)
                        characterDetailDebugPrint("☁️ [Service] Removed from favorites")
                    }
                } catch {
                    characterDetailDebugPrint("❌ [Service] Favorite operation failed: \(error.localizedDescription)")
                    // Reverter UI em caso de erro
                    await MainActor.run {
                        self.isFavorite = !currentValue
                    }
                }
            }
            return
        }

        // Salvamento local com PersistenceManager
        if let persistenceManager = persistenceManager {
            // CORREÇÃO: Usar Task normal
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    if currentValue {
                        try await persistenceManager.saveFavorite(self.detailModel.character)
                        characterDetailDebugPrint("💾 [Persistence] Saved favorite")
                    } else {
                        try await persistenceManager.removeFavorite(characterId: self.safeCharacterId)
                        characterDetailDebugPrint("💾 [Persistence] Removed favorite")
                    }
                } catch {
                    characterDetailDebugPrint("❌ [Persistence] Failed: \(error.localizedDescription)")
                    // Reverter UI em caso de erro
                    self.isFavorite = !currentValue
                }
            }
            return
        }

        // Fallback UserDefaults
        var favorites = UserDefaults.standard.array(forKey: "FavoriteCharacters") as? [Int] ?? []
        if currentValue {
            if !favorites.contains(safeCharacterId) {
                favorites.append(safeCharacterId)
                characterDetailDebugPrint("📱 [UserDefaults] Added to favorites")
            }
        } else {
            favorites.removeAll { $0 == safeCharacterId }
            characterDetailDebugPrint("📱 [UserDefaults] Removed from favorites")
        }
        UserDefaults.standard.set(favorites, forKey: "FavoriteCharacters")
        characterDetailDebugPrint("💾 [UserDefaults] Saved favorite status: \(currentValue)")
    }
}
