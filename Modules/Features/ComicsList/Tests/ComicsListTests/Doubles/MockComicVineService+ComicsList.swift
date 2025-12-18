//
//  MockComicVineService+ComicsList.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import ComicVineAPI
import Foundation
import Networking

// MARK: - MockComicsListService

/// Mock service para testes do módulo ComicsList
/// Implementa ComicVineServiceProtocol para injeção de dependência nos testes
/// Usa DispatchQueue para sincronização thread-safe em testes concorrentes
final class MockComicsListService: ComicVineServiceProtocol, @unchecked Sendable {

    // MARK: - Thread Safety

    private let queue = DispatchQueue(label: "com.comicapp.mockcomicslistservice")

    // MARK: - Configuration Properties (Thread-Safe Access)

    private var _shouldThrowError = false
    var shouldThrowError: Bool {
        get { queue.sync { _shouldThrowError } }
        set { queue.sync { _shouldThrowError = newValue } }
    }

    private var _errorToThrow: Error = NetworkError.serverErrorCode(500)
    var errorToThrow: Error {
        get { queue.sync { _errorToThrow } }
        set { queue.sync { _errorToThrow = newValue } }
    }

    private var _charactersToReturn: [Character] = []
    var charactersToReturn: [Character] {
        get { queue.sync { _charactersToReturn } }
        set { queue.sync { _charactersToReturn = newValue } }
    }

    private var _characterToReturn: Character?
    var characterToReturn: Character? {
        get { queue.sync { _characterToReturn } }
        set { queue.sync { _characterToReturn = newValue } }
    }

    private var _comicsToReturn: [Comic] = []
    var comicsToReturn: [Comic] {
        get { queue.sync { _comicsToReturn } }
        set { queue.sync { _comicsToReturn = newValue } }
    }

    private var _issueToReturn: Comic?
    var issueToReturn: Comic? {
        get { queue.sync { _issueToReturn } }
        set { queue.sync { _issueToReturn = newValue } }
    }

    // MARK: - Call Tracking Properties (Thread-Safe Access)

    private var _fetchCharactersCalled = false
    private(set) var fetchCharactersCalled: Bool {
        get { queue.sync { _fetchCharactersCalled } }
        set { queue.sync { _fetchCharactersCalled = newValue } }
    }

    private var _fetchCharactersCallCount = 0
    private(set) var fetchCharactersCallCount: Int {
        get { queue.sync { _fetchCharactersCallCount } }
        set { queue.sync { _fetchCharactersCallCount = newValue } }
    }

    private var _fetchCharacterCalled = false
    private(set) var fetchCharacterCalled: Bool {
        get { queue.sync { _fetchCharacterCalled } }
        set { queue.sync { _fetchCharacterCalled = newValue } }
    }

    private var _fetchCharacterCallCount = 0
    private(set) var fetchCharacterCallCount: Int {
        get { queue.sync { _fetchCharacterCallCount } }
        set { queue.sync { _fetchCharacterCallCount = newValue } }
    }

    private var _fetchCharacterLastId: Int?
    private(set) var fetchCharacterLastId: Int? {
        get { queue.sync { _fetchCharacterLastId } }
        set { queue.sync { _fetchCharacterLastId = newValue } }
    }

    private var _fetchCharacterComicsCalled = false
    private(set) var fetchCharacterComicsCalled: Bool {
        get { queue.sync { _fetchCharacterComicsCalled } }
        set { queue.sync { _fetchCharacterComicsCalled = newValue } }
    }

    private var _fetchCharacterComicsCallCount = 0
    private(set) var fetchCharacterComicsCallCount: Int {
        get { queue.sync { _fetchCharacterComicsCallCount } }
        set { queue.sync { _fetchCharacterComicsCallCount = newValue } }
    }

    private var _fetchCharacterComicsLastCharacterId: Int?
    private(set) var fetchCharacterComicsLastCharacterId: Int? {
        get { queue.sync { _fetchCharacterComicsLastCharacterId } }
        set { queue.sync { _fetchCharacterComicsLastCharacterId = newValue } }
    }

    private var _fetchCharacterComicsLastOffset: Int?
    private(set) var fetchCharacterComicsLastOffset: Int? {
        get { queue.sync { _fetchCharacterComicsLastOffset } }
        set { queue.sync { _fetchCharacterComicsLastOffset = newValue } }
    }

    private var _fetchCharacterComicsLastLimit: Int?
    private(set) var fetchCharacterComicsLastLimit: Int? {
        get { queue.sync { _fetchCharacterComicsLastLimit } }
        set { queue.sync { _fetchCharacterComicsLastLimit = newValue } }
    }

    private var _fetchIssueCalled = false
    private(set) var fetchIssueCalled: Bool {
        get { queue.sync { _fetchIssueCalled } }
        set { queue.sync { _fetchIssueCalled = newValue } }
    }

    private var _fetchIssueCallCount = 0
    private(set) var fetchIssueCallCount: Int {
        get { queue.sync { _fetchIssueCallCount } }
        set { queue.sync { _fetchIssueCallCount = newValue } }
    }

    private var _fetchIssueLastId: Int?
    private(set) var fetchIssueLastId: Int? {
        get { queue.sync { _fetchIssueLastId } }
        set { queue.sync { _fetchIssueLastId = newValue } }
    }

    private var _fetchIssueRequestedIds: [Int] = []
    private(set) var fetchIssueRequestedIds: [Int] {
        get { queue.sync { _fetchIssueRequestedIds } }
        set { queue.sync { _fetchIssueRequestedIds = newValue } }
    }

    private var _fetchIssuesCalled = false
    private(set) var fetchIssuesCalled: Bool {
        get { queue.sync { _fetchIssuesCalled } }
        set { queue.sync { _fetchIssuesCalled = newValue } }
    }

    private var _fetchIssuesCallCount = 0
    private(set) var fetchIssuesCallCount: Int {
        get { queue.sync { _fetchIssuesCallCount } }
        set { queue.sync { _fetchIssuesCallCount = newValue } }
    }

    // MARK: - Initialization

    init() {}

    // MARK: - Reset

    func reset() {
        queue.sync {
            _shouldThrowError = false
            _errorToThrow = NetworkError.serverErrorCode(500)
            _charactersToReturn = []
            _characterToReturn = nil
            _comicsToReturn = []
            _issueToReturn = nil

            _fetchCharactersCalled = false
            _fetchCharactersCallCount = 0

            _fetchCharacterCalled = false
            _fetchCharacterCallCount = 0
            _fetchCharacterLastId = nil

            _fetchCharacterComicsCalled = false
            _fetchCharacterComicsCallCount = 0
            _fetchCharacterComicsLastCharacterId = nil
            _fetchCharacterComicsLastOffset = nil
            _fetchCharacterComicsLastLimit = nil

            _fetchIssueCalled = false
            _fetchIssueCallCount = 0
            _fetchIssueLastId = nil
            _fetchIssueRequestedIds = []

            _fetchIssuesCalled = false
            _fetchIssuesCallCount = 0
        }
    }

    // MARK: - ComicVineServiceProtocol Implementation

    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character] {
        queue.sync {
            _fetchCharactersCalled = true
            _fetchCharactersCallCount += 1
        }

        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let characters = queue.sync { _charactersToReturn }

        if shouldThrow {
            throw error
        }
        return characters
    }

    func fetchCharacter(by id: Int) async throws -> Character {
        queue.sync {
            _fetchCharacterCalled = true
            _fetchCharacterCallCount += 1
            _fetchCharacterLastId = id
        }

        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let character = queue.sync { _characterToReturn }

        if shouldThrow {
            throw error
        }
        guard let character = character else {
            throw NetworkError.noData
        }
        return character
    }

    func fetchCharacterComics(characterId: Int, offset: Int, limit: Int) async throws -> [Comic] {
        queue.sync {
            _fetchCharacterComicsCalled = true
            _fetchCharacterComicsCallCount += 1
            _fetchCharacterComicsLastCharacterId = characterId
            _fetchCharacterComicsLastOffset = offset
            _fetchCharacterComicsLastLimit = limit
        }

        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let comics = queue.sync { _comicsToReturn }

        if shouldThrow {
            throw error
        }
        return comics
    }

    func fetchIssues(offset: Int, limit: Int) async throws -> [Comic] {
        queue.sync {
            _fetchIssuesCalled = true
            _fetchIssuesCallCount += 1
        }

        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let comics = queue.sync { _comicsToReturn }

        if shouldThrow {
            throw error
        }
        return comics
    }

    func fetchIssue(by id: Int) async throws -> Comic {
        queue.sync {
            _fetchIssueCalled = true
            _fetchIssueCallCount += 1
            _fetchIssueLastId = id
            _fetchIssueRequestedIds.append(id)
        }

        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let issue = queue.sync { _issueToReturn }
        let comics = queue.sync { _comicsToReturn }

        if shouldThrow {
            throw error
        }

        // Retorna uma comic específica para o ID se configurado
        if let issue = issue {
            return issue
        }

        // Ou busca na lista de comics pelo ID
        if let comic = comics.first(where: { $0.id == id }) {
            return comic
        }

        // Ou cria uma nova comic com o ID
        return Comic.comicsListFixture(id: id)
    }

    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character] {
        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let characters = queue.sync { _charactersToReturn }

        if shouldThrow {
            throw error
        }
        return characters.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic] {
        let shouldThrow = queue.sync { _shouldThrowError }
        let error = queue.sync { _errorToThrow }
        let comics = queue.sync { _comicsToReturn }

        if shouldThrow {
            throw error
        }
        return comics.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }
}

// MARK: - MockComicsListService Helper Methods

extension MockComicsListService {

    /// Configura o mock para retornar um número específico de comics
    func setupWithComics(count: Int) {
        comicsToReturn = .comicsListFixtures(count: count)
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

    /// Configura o mock com um character que tem issueCredits
    func setupCharacterWithIssueCredits(issueIds: [Int]) {
        let issueCredits = issueIds.map { id in
            IssueCredit(
                id: id,
                name: "Issue #\(id)",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/"
            )
        }
        characterToReturn = Character.comicsListFixture(issueCredits: issueCredits)
    }

    /// Configura o mock com comics para os IDs especificados
    func setupComicsForIds(_ ids: [Int]) {
        comicsToReturn = ids.map { id in
            Comic.comicsListFixture(id: id)
        }
    }
}

// MARK: - Mock Service Tests

#if DEBUG
import Testing

@Suite("MockComicsListService Tests")
struct MockComicsListServiceTests {

    @Test("Mock should return empty array by default")
    func testDefaultEmptyArray() async throws {
        // Arrange
        let mock = MockComicsListService()

        // Act
        let comics = try await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)

        // Assert
        #expect(comics.isEmpty)
        #expect(mock.fetchCharacterComicsCalled)
        #expect(mock.fetchCharacterComicsCallCount == 1)
    }

    @Test("Mock should return configured comics")
    func testConfiguredComics() async throws {
        // Arrange
        let mock = MockComicsListService()
        mock.comicsToReturn = [
            Comic.comicsListFixture(id: 1, volumeName: "Spider-Man"),
            Comic.comicsListFixture(id: 2, volumeName: "X-Men")
        ]

        // Act
        let comics = try await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)

        // Assert
        #expect(comics.count == 2)
        #expect(comics[0].volume?.name == "Spider-Man")
        #expect(comics[1].volume?.name == "X-Men")
    }

    @Test("Mock should throw error when configured")
    func testThrowError() async {
        // Arrange
        let mock = MockComicsListService()
        mock.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test("Mock should track call parameters for fetchCharacterComics")
    func testTrackCallParametersForFetchCharacterComics() async throws {
        // Arrange
        let mock = MockComicsListService()

        // Act
        _ = try await mock.fetchCharacterComics(characterId: 42, offset: 20, limit: 10)

        // Assert
        #expect(mock.fetchCharacterComicsLastCharacterId == 42)
        #expect(mock.fetchCharacterComicsLastOffset == 20)
        #expect(mock.fetchCharacterComicsLastLimit == 10)
    }

    @Test("Mock should track all requested issue IDs")
    func testTrackAllRequestedIssueIds() async throws {
        // Arrange
        let mock = MockComicsListService()
        mock.comicsToReturn = [
            Comic.comicsListFixture(id: 1),
            Comic.comicsListFixture(id: 2),
            Comic.comicsListFixture(id: 3)
        ]

        // Act
        _ = try await mock.fetchIssue(by: 1)
        _ = try await mock.fetchIssue(by: 2)
        _ = try await mock.fetchIssue(by: 3)

        // Assert
        #expect(mock.fetchIssueCallCount == 3)
        #expect(mock.fetchIssueRequestedIds == [1, 2, 3])
    }

    @Test("Mock should reset state correctly")
    func testReset() async throws {
        // Arrange
        let mock = MockComicsListService()
        mock.shouldThrowError = true
        mock.comicsToReturn = [Comic.comicsListFixture()]
        _ = try? await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)

        // Act
        mock.reset()

        // Assert
        #expect(mock.shouldThrowError == false)
        #expect(mock.comicsToReturn.isEmpty)
        #expect(mock.fetchCharacterComicsCalled == false)
        #expect(mock.fetchCharacterComicsCallCount == 0)
    }

    @Test("Mock helper should setup comics correctly")
    func testSetupWithComics() async throws {
        // Arrange
        let mock = MockComicsListService()

        // Act
        mock.setupWithComics(count: 5)
        let comics = try await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)

        // Assert
        #expect(comics.count == 5)
    }

    @Test("Mock should throw server error with custom code")
    func testServerErrorWithCode() async {
        // Arrange
        let mock = MockComicsListService()
        mock.setupServerError(code: 503)

        // Act & Assert
        do {
            _ = try await mock.fetchCharacterComics(characterId: 1, offset: 0, limit: 20)
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

    @Test("Mock should return specific comic for fetchIssue")
    func testFetchIssueReturnsConfiguredComic() async throws {
        // Arrange
        let mock = MockComicsListService()
        mock.issueToReturn = Comic.comicsListFixture(id: 999, volumeName: "Special Issue")

        // Act
        let comic = try await mock.fetchIssue(by: 123)

        // Assert
        #expect(comic.id == 999)
        #expect(comic.volume?.name == "Special Issue")
    }

    @Test("Mock should find comic by ID in comicsToReturn")
    func testFetchIssueFindsByIdInComicsToReturn() async throws {
        // Arrange
        let mock = MockComicsListService()
        mock.comicsToReturn = [
            Comic.comicsListFixture(id: 100, volumeName: "Comic 100"),
            Comic.comicsListFixture(id: 200, volumeName: "Comic 200"),
            Comic.comicsListFixture(id: 300, volumeName: "Comic 300")
        ]

        // Act
        let comic = try await mock.fetchIssue(by: 200)

        // Assert
        #expect(comic.id == 200)
        #expect(comic.volume?.name == "Comic 200")
    }
}
#endif
