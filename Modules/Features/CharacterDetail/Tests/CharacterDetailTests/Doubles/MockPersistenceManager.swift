//
//  MockPersistenceManager.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

import Cache
import ComicVineAPI
import Foundation

// MARK: - MockPersistenceManager (Actor)

/// Mock thread-safe do PersistenceManagerProtocol usando actor para isolamento de concorrência.
/// Projetado para ser usado em testes com operações concorrentes.
actor MockPersistenceManager: PersistenceManagerProtocol {

    // MARK: - Private Storage (Actor-Isolated)

    private var _characters: [Int: Character] = [:]
    private var _comics: [Int: [Comic]] = [:]
    private var _favorites: Set<Int> = []
    private var _searchHistory: [String] = []
    private var _shouldThrowError = false
    private var _errorToThrow: Error?
    private var _methodCalls: [String: Int] = [:]
    private var _cacheAge: TimeInterval?

    // MARK: - PersistenceManagerProtocol Implementation

    func saveCharacters(_ characters: [Character]) async throws {
        trackMethodCall("saveCharacters")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        for character in characters {
            _characters[character.id] = character
        }
    }

    func loadCharacters(offset: Int, limit: Int) async -> [Character] {
        trackMethodCall("loadCharacters")

        let allCharacters = Array(_characters.values)
        let sorted = allCharacters.sorted { $0.name < $1.name }
        let startIndex = min(offset, sorted.count)
        let endIndex = min(startIndex + limit, sorted.count)

        guard startIndex < endIndex else { return [] }
        return Array(sorted[startIndex..<endIndex])
    }

    func saveCharacter(_ character: Character) async throws {
        trackMethodCall("saveCharacter")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _characters[character.id] = character
    }

    func loadCharacter(withId id: Int) async -> Character? {
        trackMethodCall("loadCharacter")
        return _characters[id]
    }

    func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws {
        trackMethodCall("saveComics")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _comics[characterId] = comics
    }

    func loadComics(forCharacterId characterId: Int) async -> [Comic] {
        trackMethodCall("loadComics")
        return _comics[characterId] ?? []
    }

    func saveFavorite(_ character: Character) async throws {
        trackMethodCall("saveFavorite")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _characters[character.id] = character
        _favorites.insert(character.id)
    }

    func removeFavorite(characterId: Int) async throws {
        trackMethodCall("removeFavorite")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _favorites.remove(characterId)
    }

    func loadFavorites() async -> [Character] {
        trackMethodCall("loadFavorites")
        return _favorites.compactMap { _characters[$0] }
    }

    func isFavorite(characterId: Int) async -> Bool {
        trackMethodCall("isFavorite")
        return _favorites.contains(characterId)
    }

    func saveSearchHistory(_ query: String, resultCount: Int) async {
        trackMethodCall("saveSearchHistory")
        _searchHistory.removeAll { $0 == query }
        _searchHistory.insert(query, at: 0)
        if _searchHistory.count > 20 {
            _searchHistory = Array(_searchHistory.prefix(20))
        }
    }

    func loadSearchHistory() async -> [String] {
        trackMethodCall("loadSearchHistory")
        return _searchHistory
    }

    func clearSearchHistory() async {
        trackMethodCall("clearSearchHistory")
        _searchHistory.removeAll()
    }

    func clearAllCache() async throws {
        trackMethodCall("clearAllCache")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _characters.removeAll()
        _comics.removeAll()
        _favorites.removeAll()
        _searchHistory.removeAll()
    }

    func getCacheAge() async -> TimeInterval? {
        trackMethodCall("getCacheAge")
        return _cacheAge
    }

    // MARK: - Test Setup Methods

    /// Define os characters que serão retornados pelo mock
    func setCharacters(_ characters: [Character]) {
        for character in characters {
            _characters[character.id] = character
        }
    }

    /// Define um character específico por ID
    func setCharacter(_ character: Character) {
        _characters[character.id] = character
    }

    /// Define os comics para um personagem específico
    func setComics(_ comics: [Comic], forCharacterId id: Int) {
        _comics[id] = comics
    }

    /// Define os IDs de favoritos iniciais
    func setFavorites(_ ids: Set<Int>) {
        _favorites = ids
    }

    /// Adiciona um ID aos favoritos
    func addFavoriteId(_ id: Int) {
        _favorites.insert(id)
    }

    /// Define o histórico de busca
    func setSearchHistory(_ history: [String]) {
        _searchHistory = history
    }

    /// Define a idade do cache
    func setCacheAge(_ age: TimeInterval?) {
        _cacheAge = age
    }

    /// Configura o mock para lançar um erro
    func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
        _shouldThrowError = shouldThrow
        _errorToThrow = error ?? MockPersistenceError.genericError
    }

    // MARK: - Test Helper Methods

    /// Retorna a contagem de characters salvos
    func getCharactersCount() -> Int {
        return _characters.count
    }

    /// Retorna a contagem de favoritos
    func getFavoritesCount() -> Int {
        return _favorites.count
    }

    /// Verifica se um character existe por ID
    func hasCharacter(id: Int) -> Bool {
        return _characters[id] != nil
    }

    /// Verifica se um character está nos favoritos
    func isFavoriteId(_ id: Int) -> Bool {
        return _favorites.contains(id)
    }

    /// Retorna a contagem de chamadas para um método específico
    func callCount(for method: String) -> Int {
        return _methodCalls[method] ?? 0
    }

    /// Retorna todos os IDs de favoritos
    func getAllFavoriteIds() -> Set<Int> {
        return _favorites
    }

    /// Reseta todo o estado do mock
    func reset() {
        _characters.removeAll()
        _comics.removeAll()
        _favorites.removeAll()
        _searchHistory.removeAll()
        _shouldThrowError = false
        _errorToThrow = nil
        _methodCalls.removeAll()
        _cacheAge = nil
    }

    // MARK: - Private Helpers

    private func trackMethodCall(_ method: String) {
        _methodCalls[method, default: 0] += 1
    }
}

// MARK: - MockPersistenceError

/// Erros que podem ser lançados pelo MockPersistenceManager
enum MockPersistenceError: Error, LocalizedError {
    case genericError
    case saveFailed
    case loadFailed
    case deleteFailed
    case cacheCorrupted

    var errorDescription: String? {
        switch self {
        case .genericError:
            return "A generic persistence error occurred"
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .deleteFailed:
            return "Failed to delete data"
        case .cacheCorrupted:
            return "Cache data is corrupted"
        }
    }
}

// MARK: - MockPersistenceManager Tests Support

extension MockPersistenceManager {

    /// Cria um MockPersistenceManager com configuração pré-definida
    static func configured(
        characters: [Character] = [],
        favorites: Set<Int> = [],
        shouldThrowError: Bool = false,
        error: Error? = nil
    ) -> MockPersistenceManager {
        let mock = MockPersistenceManager()
        Task {
            await mock.setCharacters(characters)
            await mock.setFavorites(favorites)
            if shouldThrowError {
                await mock.setShouldThrowError(true, error: error)
            }
        }
        return mock
    }
}
