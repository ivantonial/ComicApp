//
//  FavoritesService.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Cache
import Core
import ComicVineAPI
import Combine
import Foundation

@MainActor
public final class FavoritesService: ObservableObject {
    // MARK: - Singleton
    public static let shared = FavoritesService(persistenceManager: PersistenceManager())

    // MARK: - Published Properties
    @Published public private(set) var favoriteCharacters: [Character] = []
    @Published public private(set) var favoriteComics: [Comic] = []

    // MARK: - Private Properties
    private let persistenceManager: PersistenceManagerProtocol

    // MARK: - Initialization
    public init(persistenceManager: PersistenceManagerProtocol) {
        self.persistenceManager = persistenceManager
        Task {
            await loadFavorites()
        }
    }

    // MARK: - Public API (sincrono em memória)

    /// Verifica se um personagem é favorito com base no array em memória.
    public func isFavorite(characterId: Int) -> Bool {
        favoriteCharacters.contains { $0.id == characterId }
    }

    /// Verifica se um comic é favorito com base no array em memória.
    public func isFavorite(comicId: Int) -> Bool {
        favoriteComics.contains { $0.id == comicId }
    }

    /// Alterna o status de favorito para um personagem.
    public func toggleFavorite(_ character: Character) async {
        // Usa a persistência como fonte da verdade
        if await persistenceManager.isFavorite(characterId: character.id) {
            await removeFavoriteCharacter(character)
        } else {
            await addFavorite(character)
        }
    }

    /// Alterna o status de favorito para um comic (somente em memória).
    public func toggleFavorite(_ comic: Comic) async {
        if isFavorite(comicId: comic.id) {
            await removeFavoriteComic(comic)
        } else {
            await addFavorite(comic)
        }
    }

    /// Retorna todos os favoritos persistidos e sincroniza o array em memória.
    public func getAllFavorites() async throws -> [Character] {
        let favorites = await persistenceManager.loadFavorites()
        favoriteCharacters = favorites
        return favorites
    }

    // MARK: - Private Helpers

    private func loadFavorites() async {
        favoriteCharacters = await persistenceManager.loadFavorites()
    }

    /// Adiciona um personagem aos favoritos (persiste + atualiza memória).
    private func addFavorite(_ character: Character) async {
        // Evita duplicar se já estiver favoritado na persistência
        let alreadyFavorite = await persistenceManager.isFavorite(characterId: character.id)
        guard !alreadyFavorite else { return }

        do {
            try await persistenceManager.saveFavorite(character)
            favoriteCharacters.append(character)

            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": character.id, "isFavorite": true]
            )
        } catch {
            print("Erro ao adicionar favorito: \(error)")
        }
    }

    /// Remove um personagem dos favoritos (persiste + atualiza memória).
    private func removeFavoriteCharacter(_ character: Character) async {
        favoriteCharacters.removeAll { $0.id == character.id }

        do {
            try await persistenceManager.removeFavorite(characterId: character.id)

            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": character.id, "isFavorite": false]
            )
        } catch {
            print("Erro ao remover favorito: \(error)")
        }
    }

    /// Adiciona um comic aos favoritos (somente em memória).
    private func addFavorite(_ comic: Comic) async {
        guard !isFavorite(comicId: comic.id) else { return }
        favoriteComics.append(comic)
    }

    /// Remove um comic dos favoritos (somente em memória).
    private func removeFavoriteComic(_ comic: Comic) async {
        favoriteComics.removeAll { $0.id == comic.id }
    }
}

// MARK: - FavoritesServiceProtocol Implementation
extension FavoritesService: FavoritesServiceProtocol {
    /// Versão assíncrona usada por outros módulos (CharacterDetail).
    public func isFavorite(characterId: Int) async -> Bool {
        // Usa persistência como fonte da verdade.
        return await persistenceManager.isFavorite(characterId: characterId)
    }

    /// Adiciona um favorito vindo de um `FavoriteCharacterInput`.
    public func addFavorite(character: FavoriteCharacterInput) async throws {
        // Tenta carregar o Character completo da persistência.
        if let loaded = await persistenceManager.loadCharacter(withId: character.id) {
            await addFavorite(loaded)
            return
        }

        // Se não encontrar, simplesmente ignora para evitar criar Character incompleto.
        print("⚠️ [FavoritesService] Character \(character.id) não encontrado na persistência; favorito ignorado.")
    }

    /// Remove favorito pelo ID, compatível com o protocolo.
    public func removeFavorite(characterId: Int) async throws {
        if let character = favoriteCharacters.first(where: { $0.id == characterId }) {
            await removeFavoriteCharacter(character)
        } else {
            try await persistenceManager.removeFavorite(characterId: characterId)
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": characterId, "isFavorite": false]
            )
        }
    }
}

// MARK: - Notification Extension
public extension Notification.Name {
    /// Notificação de alteração de status de um único personagem
    static let favoriteStatusChanged = Notification.Name("favoriteStatusChanged")
}
