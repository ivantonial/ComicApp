//
//  MockCacheManager.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import Cache
import Foundation

// MARK: - MockCacheManager (Actor)

/// Mock thread-safe do CacheManager usando actor para isolamento de concorrência.
/// Projetado para ser usado em testes com operações concorrentes.
actor MockCacheManager: CacheManagerProtocol {

    // MARK: - Private Storage (Actor-Isolated)

    private var _savedObjects: [String: Any] = [:]
    private var _removedKeys: [String] = []
    private var _clearedAll = false
    private var _mockCacheSize: Int = 0
    private var _expirationDates: [String: Date] = [:]
    private var _expiredKeys: Set<String> = []
    private var _methodCalls: [String: Int] = [:]

    // MARK: - CacheManagerProtocol Implementation

    func save<T: Codable & Sendable>(_ object: T, forKey key: String) async {
        trackMethodCall("save")
        _savedObjects[key] = object
    }

    func load<T: Codable & Sendable>(_ type: T.Type, forKey key: String) async -> T? {
        trackMethodCall("load")
        return _savedObjects[key] as? T
    }

    func remove(forKey key: String) async {
        trackMethodCall("remove")
        _savedObjects.removeValue(forKey: key)
        _removedKeys.append(key)
    }

    func clearAll() async {
        trackMethodCall("clearAll")
        _savedObjects.removeAll()
        _clearedAll = true
    }

    func getCacheSize() async -> Int {
        trackMethodCall("getCacheSize")
        return _mockCacheSize
    }

    func setExpirationDate(_ date: Date, forKey key: String) async {
        trackMethodCall("setExpirationDate")
        _expirationDates[key] = date
    }

    func isExpired(forKey key: String) async -> Bool {
        trackMethodCall("isExpired")
        return _expiredKeys.contains(key)
    }

    // MARK: - Test Helper Methods (Sendable returns only)

    /// Retorna a contagem de objetos salvos (Int é Sendable)
    func getSavedObjectsCount() -> Int {
        return _savedObjects.count
    }

    /// Verifica se uma chave existe no cache (Bool é Sendable)
    func hasKey(_ key: String) -> Bool {
        return _savedObjects[key] != nil
    }

    /// Retorna a contagem de chaves removidas (Int é Sendable)
    func getRemovedKeysCount() -> Int {
        return _removedKeys.count
    }

    /// Verifica se uma chave específica foi removida (Bool é Sendable)
    func wasKeyRemoved(_ key: String) -> Bool {
        return _removedKeys.contains(key)
    }

    /// Retorna se clearAll foi chamado (Bool é Sendable)
    func getClearedAll() -> Bool {
        return _clearedAll
    }

    /// Retorna o tamanho mockado do cache (Int é Sendable)
    func getMockCacheSize() -> Int {
        return _mockCacheSize
    }

    /// Define o tamanho mockado do cache
    func setMockCacheSize(_ size: Int) {
        _mockCacheSize = size
    }

    /// Marca uma chave como expirada para testes
    func markAsExpired(_ key: String) {
        _expiredKeys.insert(key)
    }

    /// Retorna a data de expiração para uma chave (Date é Sendable)
    func getExpirationDate(forKey key: String) -> Date? {
        return _expirationDates[key]
    }

    /// Retorna a contagem de chamadas para um método específico (Int é Sendable)
    func callCount(for method: String) -> Int {
        return _methodCalls[method] ?? 0
    }

    /// Reseta todo o estado do mock para um novo teste
    func reset() {
        _savedObjects.removeAll()
        _removedKeys.removeAll()
        _clearedAll = false
        _mockCacheSize = 0
        _expirationDates.removeAll()
        _expiredKeys.removeAll()
        _methodCalls.removeAll()
    }

    // MARK: - Private Helpers

    private func trackMethodCall(_ method: String) {
        _methodCalls[method, default: 0] += 1
    }
}

// MARK: - MockPersistenceManager (Actor)

/// Mock thread-safe do PersistenceManager usando actor.
actor MockPersistenceManager {

    // MARK: - Private Storage

    private var _characters: [Int: (name: String, description: String?, thumbnailPath: String?, comicsCount: Int, isFavorite: Bool)] = [:]
    private var _comics: [Int: (title: String, issueNumber: String?, characterId: Int, thumbnailPath: String?, description: String?)] = [:]
    private var _searchHistory: [(query: String, timestamp: Date, resultCount: Int)] = []
    private var _favoriteIds: Set<Int> = []

    // MARK: - Character Methods

    func saveCharacter(
        id: Int,
        name: String,
        description: String?,
        thumbnailPath: String?,
        comicsCount: Int,
        isFavorite: Bool
    ) {
        _characters[id] = (name, description, thumbnailPath, comicsCount, isFavorite)
        if isFavorite {
            _favoriteIds.insert(id)
        }
    }

    func getCharacter(id: Int) -> (name: String, description: String?, thumbnailPath: String?, comicsCount: Int, isFavorite: Bool)? {
        return _characters[id]
    }

    func deleteCharacter(id: Int) {
        _characters.removeValue(forKey: id)
        _favoriteIds.remove(id)
    }

    func getAllCharactersCount() -> Int {
        return _characters.count
    }

    // MARK: - Favorites Methods

    func setFavorite(characterId: Int, isFavorite: Bool) {
        if var character = _characters[characterId] {
            character.isFavorite = isFavorite
            _characters[characterId] = character
        }
        if isFavorite {
            _favoriteIds.insert(characterId)
        } else {
            _favoriteIds.remove(characterId)
        }
    }

    func isFavorite(characterId: Int) -> Bool {
        return _favoriteIds.contains(characterId)
    }

    func getFavoriteIds() -> Set<Int> {
        return _favoriteIds
    }

    func getFavoritesCount() -> Int {
        return _favoriteIds.count
    }

    // MARK: - Comics Methods

    func saveComic(
        id: Int,
        title: String,
        issueNumber: String?,
        characterId: Int,
        thumbnailPath: String?,
        description: String?
    ) {
        _comics[id] = (title, issueNumber, characterId, thumbnailPath, description)
    }

    func getComic(id: Int) -> (title: String, issueNumber: String?, characterId: Int, thumbnailPath: String?, description: String?)? {
        return _comics[id]
    }

    func deleteComic(id: Int) {
        _comics.removeValue(forKey: id)
    }

    func getComicsCount() -> Int {
        return _comics.count
    }

    func getComicsForCharacter(characterId: Int) -> Int {
        return _comics.values.filter { $0.characterId == characterId }.count
    }

    // MARK: - Search History Methods

    func addSearchHistory(query: String, resultCount: Int) {
        _searchHistory.append((query, Date(), resultCount))
    }

    func getSearchHistoryCount() -> Int {
        return _searchHistory.count
    }

    func getRecentSearches(limit: Int) -> [(query: String, timestamp: Date, resultCount: Int)] {
        return Array(_searchHistory.suffix(limit))
    }

    func clearSearchHistory() {
        _searchHistory.removeAll()
    }

    // MARK: - Reset

    func reset() {
        _characters.removeAll()
        _comics.removeAll()
        _searchHistory.removeAll()
        _favoriteIds.removeAll()
    }
}

// MARK: - TestCodableObject

/// Objeto de teste Codable e Sendable para usar nos testes de cache.
struct TestCodableObject: Codable, Sendable, Equatable, Hashable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
