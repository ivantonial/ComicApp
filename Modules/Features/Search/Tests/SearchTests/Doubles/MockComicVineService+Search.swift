//
//  MockComicVineService+Search.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import ComicVineAPI
@testable import Cache
import Foundation
import Networking

// MARK: - MockSearchService

/// Mock service para testes do módulo Search
/// Implementa ComicVineServiceProtocol para injeção de dependência nos testes
final class MockSearchService: ComicVineServiceProtocol, @unchecked Sendable {

    // MARK: - Configuration Properties

    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.serverErrorCode(500)
    var charactersToReturn: [Character] = []
    var characterToReturn: Character?
    var comicsToReturn: [Comic] = []
    var issueToReturn: Comic?

    /// When true, searchCharacters/searchComics will filter results by query.
    /// Set to false when testing ViewModel filters to return all configured data.
    var shouldFilterByQuery = true

    // MARK: - Call Tracking Properties

    private(set) var fetchCharactersCalled = false
    private(set) var fetchCharactersCallCount = 0
    private(set) var fetchCharactersLastOffset: Int?
    private(set) var fetchCharactersLastLimit: Int?

    private(set) var searchCharactersCalled = false
    private(set) var searchCharactersCallCount = 0
    private(set) var searchCharactersLastQuery: String?
    private(set) var searchCharactersLastOffset: Int?
    private(set) var searchCharactersLastLimit: Int?

    private(set) var searchComicsCalled = false
    private(set) var searchComicsCallCount = 0
    private(set) var searchComicsLastQuery: String?
    private(set) var searchComicsLastOffset: Int?
    private(set) var searchComicsLastLimit: Int?

    private(set) var fetchCharacterComicsCalled = false
    private(set) var fetchCharacterComicsCallCount = 0

    // MARK: - Initialization

    init() {}

    // MARK: - Reset

    func reset() {
        shouldThrowError = false
        errorToThrow = NetworkError.serverErrorCode(500)
        charactersToReturn = []
        characterToReturn = nil
        comicsToReturn = []
        issueToReturn = nil
        shouldFilterByQuery = true

        fetchCharactersCalled = false
        fetchCharactersCallCount = 0
        fetchCharactersLastOffset = nil
        fetchCharactersLastLimit = nil

        searchCharactersCalled = false
        searchCharactersCallCount = 0
        searchCharactersLastQuery = nil
        searchCharactersLastOffset = nil
        searchCharactersLastLimit = nil

        searchComicsCalled = false
        searchComicsCallCount = 0
        searchComicsLastQuery = nil
        searchComicsLastOffset = nil
        searchComicsLastLimit = nil

        fetchCharacterComicsCalled = false
        fetchCharacterComicsCallCount = 0
    }

    // MARK: - ComicVineServiceProtocol Implementation

    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character] {
        fetchCharactersCalled = true
        fetchCharactersCallCount += 1
        fetchCharactersLastOffset = offset
        fetchCharactersLastLimit = limit

        if shouldThrowError {
            throw errorToThrow
        }
        return charactersToReturn
    }

    func fetchCharacter(by id: Int) async throws -> Character {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let character = characterToReturn else {
            throw NetworkError.noData
        }
        return character
    }

    func fetchCharacterComics(characterId: Int, offset: Int, limit: Int) async throws -> [Comic] {
        fetchCharacterComicsCalled = true
        fetchCharacterComicsCallCount += 1

        if shouldThrowError {
            throw errorToThrow
        }
        return comicsToReturn
    }

    func fetchIssues(offset: Int, limit: Int) async throws -> [Comic] {
        if shouldThrowError {
            throw errorToThrow
        }
        return comicsToReturn
    }

    func fetchIssue(by id: Int) async throws -> Comic {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let issue = issueToReturn else {
            throw NetworkError.noData
        }
        return issue
    }

    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character] {
        searchCharactersCalled = true
        searchCharactersCallCount += 1
        searchCharactersLastQuery = query
        searchCharactersLastOffset = offset
        searchCharactersLastLimit = limit

        if shouldThrowError {
            throw errorToThrow
        }

        // Return all characters if filtering is disabled or query is empty
        if !shouldFilterByQuery || query.isEmpty {
            return charactersToReturn
        }

        return charactersToReturn.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic] {
        searchComicsCalled = true
        searchComicsCallCount += 1
        searchComicsLastQuery = query
        searchComicsLastOffset = offset
        searchComicsLastLimit = limit

        if shouldThrowError {
            throw errorToThrow
        }

        // Return all comics if filtering is disabled or query is empty
        if !shouldFilterByQuery || query.isEmpty {
            return comicsToReturn
        }

        return comicsToReturn.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }
}

// MARK: - MockSearchService Helper Methods

extension MockSearchService {

    /// Configura o mock para retornar personagens específicos
    func setupWithCharacters(_ characters: [Character]) {
        charactersToReturn = characters
    }

    /// Configura o mock para retornar um número específico de personagens
    func setupWithCharacters(count: Int) {
        charactersToReturn = (1...count).map { index in
            Character.searchFixture(id: index, name: "Hero \(index)")
        }
    }

    /// Configura o mock para retornar comics específicos
    func setupWithComics(_ comics: [Comic]) {
        comicsToReturn = comics
    }

    /// Configura o mock para retornar um número específico de comics
    func setupWithComics(count: Int) {
        comicsToReturn = (1...count).map { index in
            Comic.searchFixture(
                id: index,
                name: "Comic \(index)",
                volume: VolumeSummary(id: index + 1000, name: "Volume \(index)", apiDetailUrl: nil)
            )
        }
    }

    /// Configura o mock para simular erro de rede
    func setupNetworkError(_ error: NetworkError = .serverErrorCode(500)) {
        shouldThrowError = true
        errorToThrow = error
    }

    /// Configura o mock para simular erro de servidor
    func setupServerError(code: Int = 500) {
        shouldThrowError = true
        errorToThrow = NetworkError.serverErrorCode(code)
    }

    /// Configura o mock para simular erro de dados não encontrados
    func setupNoDataError() {
        shouldThrowError = true
        errorToThrow = NetworkError.noData
    }

    /// Configura o mock para simular erro de URL inválida
    func setupInvalidURLError() {
        shouldThrowError = true
        errorToThrow = NetworkError.invalidURL
    }

    /// Configura o mock para simular erro de não autorizado
    func setupUnauthorizedError() {
        shouldThrowError = true
        errorToThrow = NetworkError.unauthorized
    }

    /// Configura o mock com fixtures mistas para testes de filtro do ViewModel
    /// Desabilita filtro por query para que todos os characters sejam retornados
    func setupMixedCharactersForFilterTests() {
        shouldFilterByQuery = false
        charactersToReturn = [
            Character.searchFixture(id: 1, name: "Spider-Man"),
            Character.searchFixture(id: 2, name: "Doctor Doom"),
            Character.searchFixture(id: 3, name: "Avengers"),
            Character.searchFixture(id: 4, name: "Magneto"),
            Character.searchFixture(id: 5, name: "X-Men"),
            Character.searchFixture(id: 6, name: "Wonder Woman"),
            Character.searchFixture(id: 7, name: "Thanos"),
            Character.searchFixture(id: 8, name: "Fantastic Four")
        ]
    }

    /// Configura o mock com fixtures mistas de comics para testes de filtro do ViewModel
    /// Desabilita filtro por query para que todos os comics sejam retornados
    func setupMixedComicsForFilterTests() {
        shouldFilterByQuery = false
        comicsToReturn = [
            Comic.ongoingSearchFixture(id: 1, volumeName: "Amazing Spider-Man", issueNumber: "1"),
            Comic.specialSearchFixture(id: 2, specialType: "Annual"),
            Comic.ongoingSearchFixture(id: 3, volumeName: "X-Men", issueNumber: "100"),
            Comic.specialSearchFixture(id: 4, specialType: "Special"),
            Comic.ongoingSearchFixture(id: 5, volumeName: "Avengers", issueNumber: "500"),
            Comic.variantSearchFixture(id: 6, volumeName: "Avengers")
        ]
    }
}

// MARK: - MockSearchCacheManager

/// Mock do CacheManager para testes do módulo Search
/// Implementa CacheManagerProtocol como actor para thread-safety
actor MockSearchCacheManager: CacheManagerProtocol {

    // MARK: - Storage

    private var cache: [String: Data] = [:]
    private var expirationDates: [String: Date] = [:]

    // MARK: - Call Tracking Properties

    private(set) var saveCalled = false
    private(set) var saveCallCount = 0
    private(set) var lastSaveKey: String?

    private(set) var loadCalled = false
    private(set) var loadCallCount = 0
    private(set) var lastLoadKey: String?

    private(set) var removeCalled = false
    private(set) var removeCallCount = 0
    private(set) var lastRemoveKey: String?

    private(set) var isExpiredCalled = false
    private(set) var isExpiredCallCount = 0

    private(set) var setExpirationCalled = false
    private(set) var setExpirationCallCount = 0

    // MARK: - Configuration

    var shouldReturnExpired = false

    // MARK: - CacheManagerProtocol Implementation

    func save<T: Codable & Sendable>(_ object: T, forKey key: String) async {
        saveCalled = true
        saveCallCount += 1
        lastSaveKey = key

        if let data = try? JSONEncoder().encode(object) {
            cache[key] = data
        }
    }

    func load<T: Codable & Sendable>(_ type: T.Type, forKey key: String) async -> T? {
        loadCalled = true
        loadCallCount += 1
        lastLoadKey = key

        guard let data = cache[key] else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func remove(forKey key: String) async {
        removeCalled = true
        removeCallCount += 1
        lastRemoveKey = key

        cache.removeValue(forKey: key)
        expirationDates.removeValue(forKey: key)
    }

    func clearAll() async {
        cache.removeAll()
        expirationDates.removeAll()
    }

    func getCacheSize() async -> Int {
        return cache.values.reduce(0) { $0 + $1.count }
    }

    func isExpired(forKey key: String) async -> Bool {
        isExpiredCalled = true
        isExpiredCallCount += 1

        if shouldReturnExpired {
            return true
        }

        guard let expirationDate = expirationDates[key] else {
            return true
        }
        return Date() > expirationDate
    }

    func setExpirationDate(_ date: Date, forKey key: String) async {
        setExpirationCalled = true
        setExpirationCallCount += 1
        expirationDates[key] = date
    }

    // MARK: - Reset

    func reset() {
        cache.removeAll()
        expirationDates.removeAll()

        saveCalled = false
        saveCallCount = 0
        lastSaveKey = nil

        loadCalled = false
        loadCallCount = 0
        lastLoadKey = nil

        removeCalled = false
        removeCallCount = 0
        lastRemoveKey = nil

        isExpiredCalled = false
        isExpiredCallCount = 0

        setExpirationCalled = false
        setExpirationCallCount = 0

        shouldReturnExpired = false
    }

    // MARK: - Test Helpers

    /// Simula cache com dados válidos e não expirados
    func setupValidCache<T: Codable & Sendable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            cache[key] = data
            expirationDates[key] = Date().addingTimeInterval(3600) // 1 hora no futuro
        }
    }

    /// Simula cache expirado
    func setupExpiredCache<T: Codable & Sendable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            cache[key] = data
            expirationDates[key] = Date().addingTimeInterval(-3600) // 1 hora no passado
        }
    }

    /// Verifica se uma chave existe no cache
    func hasKey(_ key: String) -> Bool {
        return cache[key] != nil
    }

    /// Retorna a data de expiração para uma chave
    func getExpirationDate(forKey key: String) -> Date? {
        return expirationDates[key]
    }
}

// MARK: - TestSearchObject

/// Objeto de teste para validar o MockSearchCacheManager
struct TestSearchObject: Codable, Equatable, Sendable {
    let id: Int
    let name: String
}

// MARK: - Self-Tests

#if DEBUG
import Testing

@Suite("MockSearchService Tests")
struct MockSearchServiceTests {

    @Test("Mock should return configured characters")
    func testReturnCharacters() async throws {
        // Arrange
        let mock = MockSearchService()
        let expectedCharacters = [
            Character.searchFixture(id: 1, name: "Spider-Man"),
            Character.searchFixture(id: 2, name: "Batman")
        ]
        mock.charactersToReturn = expectedCharacters

        // Act
        let characters = try await mock.searchCharacters(query: "", offset: 0, limit: 20)

        // Assert
        #expect(characters.count == 2)
        #expect(characters[0].name == "Spider-Man")
        #expect(characters[1].name == "Batman")
    }

    @Test("Mock should return configured comics")
    func testReturnComics() async throws {
        // Arrange
        let mock = MockSearchService()
        let expectedComics = [
            Comic.searchFixture(id: 1),
            Comic.searchFixture(id: 2)
        ]
        mock.comicsToReturn = expectedComics

        // Act
        let comics = try await mock.searchComics(query: "", offset: 0, limit: 20)

        // Assert
        #expect(comics.count == 2)
        #expect(comics[0].id == 1)
        #expect(comics[1].id == 2)
    }

    @Test("Mock should throw error when configured")
    func testThrowError() async {
        // Arrange
        let mock = MockSearchService()
        mock.shouldThrowError = true
        mock.errorToThrow = NetworkError.serverErrorCode(500)

        // Act & Assert
        do {
            _ = try await mock.searchCharacters(query: "test", offset: 0, limit: 20)
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test("Mock should track search characters calls")
    func testTrackSearchCharactersCalls() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        _ = try await mock.searchCharacters(query: "Spider", offset: 0, limit: 20)
        _ = try await mock.searchCharacters(query: "Batman", offset: 10, limit: 30)

        // Assert
        #expect(mock.searchCharactersCalled)
        #expect(mock.searchCharactersCallCount == 2)
    }

    @Test("Mock should track search comics calls")
    func testTrackSearchComicsCalls() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        _ = try await mock.searchComics(query: "Spider", offset: 0, limit: 20)
        _ = try await mock.searchComics(query: "Batman", offset: 10, limit: 30)

        // Assert
        #expect(mock.searchComicsCalled)
        #expect(mock.searchComicsCallCount == 2)
    }

    @Test("Mock should track search characters parameters")
    func testTrackSearchCharactersParameters() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        _ = try await mock.searchCharacters(query: "Spider", offset: 10, limit: 25)

        // Assert
        #expect(mock.searchCharactersLastQuery == "Spider")
        #expect(mock.searchCharactersLastOffset == 10)
        #expect(mock.searchCharactersLastLimit == 25)
    }

    @Test("Mock should track search comics call parameters")
    func testTrackSearchComicsParameters() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        _ = try await mock.searchComics(query: "Batman", offset: 5, limit: 15)

        // Assert
        #expect(mock.searchComicsLastQuery == "Batman")
        #expect(mock.searchComicsLastOffset == 5)
        #expect(mock.searchComicsLastLimit == 15)
    }

    @Test("Mock search characters should filter by query")
    func testSearchCharactersFilter() async throws {
        // Arrange
        let mock = MockSearchService()
        mock.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Spider-Man"),
            Character.searchFixture(id: 2, name: "Batman"),
            Character.searchFixture(id: 3, name: "Spider-Woman")
        ]

        // Act
        let results = try await mock.searchCharacters(query: "Spider", offset: 0, limit: 20)

        // Assert
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.name.contains("Spider") })
    }

    @Test("Mock search comics should filter by query")
    func testSearchComicsFilter() async throws {
        // Arrange
        let mock = MockSearchService()
        mock.comicsToReturn = [
            Comic.ongoingSearchFixture(id: 1, volumeName: "Amazing Spider-Man", issueNumber: "1"),
            Comic.ongoingSearchFixture(id: 2, volumeName: "Batman", issueNumber: "1"),
            Comic.ongoingSearchFixture(id: 3, volumeName: "Spider-Man 2099", issueNumber: "1")
        ]

        // Act
        let results = try await mock.searchComics(query: "Spider", offset: 0, limit: 20)

        // Assert
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.title.contains("Spider") })
    }

    @Test("Mock should reset state correctly")
    func testReset() async throws {
        // Arrange
        let mock = MockSearchService()
        mock.shouldThrowError = true
        mock.charactersToReturn = [Character.searchFixture()]
        mock.comicsToReturn = [Comic.searchFixture()]
        _ = try? await mock.searchCharacters(query: "test", offset: 0, limit: 20)
        _ = try? await mock.searchComics(query: "test", offset: 0, limit: 20)

        // Act
        mock.reset()

        // Assert
        #expect(mock.shouldThrowError == false)
        #expect(mock.charactersToReturn.isEmpty)
        #expect(mock.comicsToReturn.isEmpty)
        #expect(mock.searchCharactersCalled == false)
        #expect(mock.searchCharactersCallCount == 0)
        #expect(mock.searchComicsCalled == false)
        #expect(mock.searchComicsCallCount == 0)
    }

    @Test("Mock helper should setup characters correctly")
    func testSetupWithCharacters() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        mock.setupWithCharacters(count: 5)
        let characters = try await mock.searchCharacters(query: "", offset: 0, limit: 20)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }

    @Test("Mock helper should setup comics correctly")
    func testSetupWithComics() async throws {
        // Arrange
        let mock = MockSearchService()

        // Act
        mock.setupWithComics(count: 3)
        let comics = try await mock.searchComics(query: "", offset: 0, limit: 20)

        // Assert
        #expect(comics.count == 3)
        for (index, comic) in comics.enumerated() {
            #expect(comic.id == index + 1)
        }
    }

    @Test("Mock should throw server error with custom code")
    func testServerErrorWithCode() async {
        // Arrange
        let mock = MockSearchService()
        mock.setupServerError(code: 503)

        // Act & Assert
        do {
            _ = try await mock.searchCharacters(query: "test", offset: 0, limit: 20)
            #expect(Bool(false), "Expected error to be thrown")
        } catch let error as NetworkError {
            if case .serverErrorCode(let code) = error {
                #expect(code == 503)
            } else {
                #expect(Bool(false), "Expected serverErrorCode")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError")
        }
    }
}

@Suite("MockSearchCacheManager Tests")
struct MockSearchCacheManagerTests {

    @Test("Cache should save and load data correctly")
    func testSaveAndLoad() async {
        // Arrange
        let cache = MockSearchCacheManager()
        let testObject = TestSearchObject(id: 1, name: "Test")

        // Act
        await cache.save(testObject, forKey: "test_key")
        let loaded = await cache.load(TestSearchObject.self, forKey: "test_key")

        // Assert
        #expect(loaded == testObject)
        #expect(await cache.saveCalled)
        #expect(await cache.loadCalled)
    }

    @Test("Cache should return nil for missing key")
    func testLoadMissingKey() async {
        // Arrange
        let cache = MockSearchCacheManager()

        // Act
        let loaded = await cache.load(TestSearchObject.self, forKey: "nonexistent")

        // Assert
        #expect(loaded == nil)
    }

    @Test("Cache should remove data correctly")
    func testRemove() async {
        // Arrange
        let cache = MockSearchCacheManager()
        let testObject = TestSearchObject(id: 1, name: "Test")
        await cache.save(testObject, forKey: "test_key")

        // Act
        await cache.remove(forKey: "test_key")
        let loaded = await cache.load(TestSearchObject.self, forKey: "test_key")

        // Assert
        #expect(loaded == nil)
        #expect(await cache.removeCalled)
    }

    @Test("Cache should report expired status correctly")
    func testIsExpired() async {
        // Arrange
        let cache = MockSearchCacheManager()
        let testObject = TestSearchObject(id: 1, name: "Test")
        await cache.setupValidCache(testObject, forKey: "valid_key")
        await cache.setupExpiredCache(testObject, forKey: "expired_key")

        // Act & Assert
        #expect(await cache.isExpired(forKey: "valid_key") == false)
        #expect(await cache.isExpired(forKey: "expired_key") == true)
        #expect(await cache.isExpired(forKey: "nonexistent") == true)
    }

    @Test("Cache should set expiration date")
    func testSetExpirationDate() async {
        // Arrange
        let cache = MockSearchCacheManager()
        let futureDate = Date().addingTimeInterval(3600)

        // Act
        await cache.setExpirationDate(futureDate, forKey: "test_key")

        // Assert
        #expect(await cache.setExpirationCalled)
        #expect(await cache.setExpirationCallCount == 1)
    }

    @Test("Cache should clear all data")
    func testClearAll() async {
        // Arrange
        let cache = MockSearchCacheManager()
        await cache.save(TestSearchObject(id: 1, name: "Test1"), forKey: "key1")
        await cache.save(TestSearchObject(id: 2, name: "Test2"), forKey: "key2")

        // Act
        await cache.clearAll()

        // Assert
        #expect(await cache.load(TestSearchObject.self, forKey: "key1") == nil)
        #expect(await cache.load(TestSearchObject.self, forKey: "key2") == nil)
    }

    @Test("Cache should return cache size")
    func testGetCacheSize() async {
        // Arrange
        let cache = MockSearchCacheManager()
        await cache.save(TestSearchObject(id: 1, name: "Test1"), forKey: "key1")
        await cache.save(TestSearchObject(id: 2, name: "Test2"), forKey: "key2")

        // Act
        let size = await cache.getCacheSize()

        // Assert
        #expect(size > 0)
    }

    @Test("Cache should reset state correctly")
    func testReset() async {
        // Arrange
        let cache = MockSearchCacheManager()
        await cache.save(TestSearchObject(id: 1, name: "Test"), forKey: "key")
        _ = await cache.load(TestSearchObject.self, forKey: "key")

        // Act
        await cache.reset()

        // Assert
        #expect(await cache.saveCalled == false)
        #expect(await cache.loadCalled == false)
        #expect(await cache.saveCallCount == 0)
        #expect(await cache.loadCallCount == 0)
    }
}
#endif
