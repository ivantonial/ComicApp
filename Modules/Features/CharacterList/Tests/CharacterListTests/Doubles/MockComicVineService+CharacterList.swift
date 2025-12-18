//
//  MockComicVineService+CharacterList.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import ComicVineAPI
import Foundation
import Networking

// MARK: - MockCharacterListService

/// Mock service para testes do módulo CharacterList
/// Implementa ComicVineServiceProtocol para injeção de dependência nos testes
final class MockCharacterListService: ComicVineServiceProtocol, @unchecked Sendable {

    // MARK: - Configuration Properties

    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.serverErrorCode(500)
    var charactersToReturn: [Character] = []
    var characterToReturn: Character?
    var comicsToReturn: [Comic] = []
    var issueToReturn: Comic?

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

        fetchCharactersCalled = false
        fetchCharactersCallCount = 0
        fetchCharactersLastOffset = nil
        fetchCharactersLastLimit = nil

        searchCharactersCalled = false
        searchCharactersCallCount = 0
        searchCharactersLastQuery = nil
        searchCharactersLastOffset = nil
        searchCharactersLastLimit = nil
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

        // Filtra por nome se houver query
        if query.isEmpty {
            return charactersToReturn
        }

        return charactersToReturn.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic] {
        if shouldThrowError {
            throw errorToThrow
        }
        return comicsToReturn
    }
}

// MARK: - MockCharacterListService Helper Methods

extension MockCharacterListService {

    /// Configura o mock para retornar um número específico de personagens
    func setupWithCharacters(count: Int) {
        charactersToReturn = (1...count).map { index in
            Character.listFixture(id: index, name: "Hero \(index)")
        }
    }

    /// Configura o mock para simular paginação
    func setupForPagination(totalItems: Int, pageSize: Int) {
        let characters = (1...totalItems).map { index in
            Character.listFixture(id: index, name: "Hero \(index)")
        }
        self.charactersToReturn = characters
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
}

// MARK: - Mock Service Tests

#if DEBUG
import Testing

@Suite("MockCharacterListService Tests")
struct MockCharacterListServiceTests {

    @Test("Mock should return empty array by default")
    func testDefaultEmptyArray() async throws {
        // Arrange
        let mock = MockCharacterListService()

        // Act
        let characters = try await mock.fetchCharacters(offset: 0, limit: 20)

        // Assert
        #expect(characters.isEmpty)
        #expect(mock.fetchCharactersCalled)
        #expect(mock.fetchCharactersCallCount == 1)
    }

    @Test("Mock should return configured characters")
    func testConfiguredCharacters() async throws {
        // Arrange
        let mock = MockCharacterListService()
        mock.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Batman")
        ]

        // Act
        let characters = try await mock.fetchCharacters(offset: 0, limit: 20)

        // Assert
        #expect(characters.count == 2)
        #expect(characters[0].name == "Spider-Man")
        #expect(characters[1].name == "Batman")
    }

    @Test("Mock should throw error when configured")
    func testThrowError() async {
        // Arrange
        let mock = MockCharacterListService()
        mock.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await mock.fetchCharacters(offset: 0, limit: 20)
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test("Mock should track call parameters")
    func testTrackCallParameters() async throws {
        // Arrange
        let mock = MockCharacterListService()

        // Act
        _ = try await mock.fetchCharacters(offset: 40, limit: 10)

        // Assert
        #expect(mock.fetchCharactersLastOffset == 40)
        #expect(mock.fetchCharactersLastLimit == 10)
    }

    @Test("Mock search should filter characters by query")
    func testSearchFilter() async throws {
        // Arrange
        let mock = MockCharacterListService()
        mock.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Batman"),
            Character.listFixture(id: 3, name: "Spider-Woman")
        ]

        // Act
        let results = try await mock.searchCharacters(query: "Spider", offset: 0, limit: 20)

        // Assert
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.name.contains("Spider") })
    }

    @Test("Mock should reset state correctly")
    func testReset() async throws {
        // Arrange
        let mock = MockCharacterListService()
        mock.shouldThrowError = true
        mock.charactersToReturn = [Character.listFixture()]
        _ = try? await mock.fetchCharacters(offset: 0, limit: 20)

        // Act
        mock.reset()

        // Assert
        #expect(mock.shouldThrowError == false)
        #expect(mock.charactersToReturn.isEmpty)
        #expect(mock.fetchCharactersCalled == false)
        #expect(mock.fetchCharactersCallCount == 0)
    }

    @Test("Mock helper should setup characters correctly")
    func testSetupWithCharacters() async throws {
        // Arrange
        let mock = MockCharacterListService()

        // Act
        mock.setupWithCharacters(count: 5)
        let characters = try await mock.fetchCharacters(offset: 0, limit: 20)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }

    @Test("Mock should throw server error with custom code")
    func testServerErrorWithCode() async {
        // Arrange
        let mock = MockCharacterListService()
        mock.setupServerError(code: 503)

        // Act & Assert
        do {
            _ = try await mock.fetchCharacters(offset: 0, limit: 20)
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
#endif
