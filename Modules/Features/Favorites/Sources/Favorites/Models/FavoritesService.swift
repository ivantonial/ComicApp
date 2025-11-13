//
//  FavoritesService.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Cache
import Combine
import ComicVineAPI
import Core
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

    // MARK: - Date formatter (mesmo formato aproximado da ComicVine)
    private static let comicVineDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }()

    // MARK: - Initialization
    public init(persistenceManager: PersistenceManagerProtocol) {
        self.persistenceManager = persistenceManager
        Task {
            await loadFavorites()
        }
    }

    // MARK: - Public API (síncrono em memória)

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
        print("🔍 [FavoritesService] addFavorite chamado para character ID: \(character.id)")

        // 1. Tenta carregar o Character completo da persistência.
        if let loaded = await persistenceManager.loadCharacter(withId: character.id) {
            print("✅ [FavoritesService] Personagem encontrado no Core Data, adicionando aos favoritos")
            await addFavorite(loaded)
            return
        }

        // 2. Se não encontrar, cria um Character "básico" compatível com o modelo da ComicVine.
        print("⚠️ [FavoritesService] Character \(character.id) não encontrado no Core Data")
        print("🔨 [FavoritesService] Criando personagem básico para salvar...")

        let slugName = character.name
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")

        let apiDetailUrl = "https://comicvine.gamespot.com/api/character/4005-\(character.id)/"
        let siteDetailUrl = "https://comicvine.gamespot.com/\(slugName)/4005-\(character.id)/"

        let thumbnailString = character.thumbnailURL?.absoluteString
        let nowString = FavoritesService.comicVineDateFormatter.string(from: Date())

        // Monta o payload mínimo de JSON esperado pelo Decodable de `Character`.
        let imagePayload = MinimalCharacterPayload.ImagePayload(
            iconUrl: thumbnailString,
            mediumUrl: thumbnailString,
            screenUrl: thumbnailString,
            screenLargeUrl: thumbnailString,
            smallUrl: thumbnailString,
            superUrl: thumbnailString,
            thumbUrl: thumbnailString,
            tinyUrl: thumbnailString,
            originalUrl: thumbnailString
        )

        let payload = MinimalCharacterPayload(
            id: character.id,
            name: character.name,
            image: imagePayload,
            apiDetailUrl: apiDetailUrl,
            siteDetailUrl: siteDetailUrl,
            countOfIssueAppearances: 0,
            dateAdded: nowString,
            dateLastUpdated: nowString
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(payload)

        // Aqui deixamos o próprio Decodable do módulo ComicVineAPI montar o Character,
        // incluindo o `ComicVineImage`, sem precisar chamar init público.
        let basicCharacter = try JSONDecoder().decode(Character.self, from: data)

        do {
            // Primeiro salva o personagem básico no Core Data
            print("💾 [FavoritesService] Salvando personagem básico no Core Data...")
            try await persistenceManager.saveCharacter(basicCharacter)
            print("✅ [FavoritesService] Personagem básico salvo no Core Data")

            // Agora adiciona aos favoritos
            print("⭐ [FavoritesService] Marcando como favorito...")
            try await persistenceManager.saveFavorite(basicCharacter)
            favoriteCharacters.append(basicCharacter)

            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": character.id, "isFavorite": true]
            )

            print("✅ [FavoritesService] Personagem adicionado aos favoritos com sucesso!")
        } catch {
            print("❌ [FavoritesService] Erro ao criar e salvar personagem básico: \(error)")
            throw error
        }
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

// MARK: - MinimalCharacterPayload (somente para construção de Character básico)

/// Payload mínimo só para gerar um `Character` válido via `JSONDecoder`,
/// sem precisar acessar o init do `ComicVineImage` (que é interno ao módulo ComicVineAPI).
private struct MinimalCharacterPayload: Encodable {

    struct ImagePayload: Encodable {
        let iconUrl: String?
        let mediumUrl: String?
        let screenUrl: String?
        let screenLargeUrl: String?
        let smallUrl: String?
        let superUrl: String?
        let thumbUrl: String?
        let tinyUrl: String?
        let originalUrl: String?

        enum CodingKeys: String, CodingKey {
            case iconUrl = "icon_url"
            case mediumUrl = "medium_url"
            case screenUrl = "screen_url"
            case screenLargeUrl = "screen_large_url"
            case smallUrl = "small_url"
            case superUrl = "super_url"
            case thumbUrl = "thumb_url"
            case tinyUrl = "tiny_url"
            case originalUrl = "original_url"
        }
    }

    let id: Int
    let name: String
    let image: ImagePayload
    let apiDetailUrl: String
    let siteDetailUrl: String
    let countOfIssueAppearances: Int
    let dateAdded: String
    let dateLastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
        case countOfIssueAppearances = "count_of_issue_appearances"
        case dateAdded = "date_added"
        case dateLastUpdated = "date_last_updated"
    }
}
