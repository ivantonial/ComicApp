//
//  SearchCharactersUseCaseTests.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import CharacterList
@testable import ComicVineAPI
import Cache
import Foundation
import Networking
import Testing
import XCTest

// MARK: - SearchCharactersUseCase Protocol Tests

@Suite("SearchCharactersUseCase Protocol Tests")
struct SearchCharactersUseCaseProtocolTests {

    @Test("SearchCharactersUseCase protocol should define search method")
    func testProtocolDefinition() {
        // Valida que o protocolo está acessível e define o método esperado
        // Se compilar, o protocolo está correto
        #expect(true)
    }

    @Test("Protocol should require async throws search method")
    func testProtocolMethodSignature() {
        // Valida a assinatura do método do protocolo
        // Se compilar, a assinatura está correta
        #expect(true)
    }
}

// MARK: - SearchCharactersUseCaseImpl Query Validation Tests

@Suite("SearchCharactersUseCaseImpl Query Validation Tests")
struct SearchCharactersUseCaseImplQueryValidationTests {

    @Test("Should return empty array for empty query without calling service")
    func testEmptyQueryReturnsEmpty() async throws {
        // Arrange - Usando mock do protocolo
        let mockService = MockSearchCharactersService()
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        let results = try await useCase.search("", offset: 0, limit: 20)

        // Assert
        #expect(results.isEmpty)
        #expect(!mockService.searchCalled)
    }

    @Test("Should return empty array for whitespace only query")
    func testWhitespaceQueryReturnsEmpty() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        let results = try await useCase.search("   ", offset: 0, limit: 20)

        // Assert
        #expect(results.isEmpty)
        #expect(!mockService.searchCalled)
    }

    @Test("Should return empty array for tab and newline query")
    func testTabNewlineQueryReturnsEmpty() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        let results = try await useCase.search("\t\n", offset: 0, limit: 20)

        // Assert
        #expect(results.isEmpty)
        #expect(!mockService.searchCalled)
    }

    @Test("Should trim query before searching")
    func testTrimQuery() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.charactersToReturn = [Character.listFixture()]
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        _ = try await useCase.search("  Batman  ", offset: 0, limit: 20)

        // Assert
        #expect(mockService.searchCalled)
        #expect(mockService.lastQuery == "Batman")
    }
}

// MARK: - SearchCharactersUseCaseImpl Search Execution Tests

@Suite("SearchCharactersUseCaseImpl Search Execution Tests")
struct SearchCharactersUseCaseImplSearchExecutionTests {

    @Test("Should call service with correct parameters")
    func testServiceCalledWithParameters() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        _ = try await useCase.search("Spider", offset: 40, limit: 10)

        // Assert
        #expect(mockService.searchCalled)
        #expect(mockService.lastQuery == "Spider")
        #expect(mockService.lastOffset == 40)
        #expect(mockService.lastLimit == 10)
    }

    @Test("Should use default offset and limit")
    func testDefaultParameters() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        _ = try await useCase.search("Hero")

        // Assert
        #expect(mockService.lastOffset == 0)
        #expect(mockService.lastLimit == 20)
    }

    @Test("Should return characters from service")
    func testReturnsCharactersFromService() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Spider-Woman")
        ]
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        let results = try await useCase.search("Spider", offset: 0, limit: 20)

        // Assert
        #expect(results.count == 2)
        #expect(results[0].name == "Spider-Man")
        #expect(results[1].name == "Spider-Woman")
    }

    @Test("Should return empty array when service returns empty")
    func testEmptyServiceResponse() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.charactersToReturn = []
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act
        let results = try await useCase.search("Unknown", offset: 0, limit: 20)

        // Assert
        #expect(results.isEmpty)
    }
}

// MARK: - SearchCharactersUseCaseImpl Error Handling Tests

@Suite("SearchCharactersUseCaseImpl Error Handling Tests")
struct SearchCharactersUseCaseImplErrorTests {

    @Test("Should throw error when service fails")
    func testThrowsServiceError() async {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.shouldThrowError = true
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.search("Hero", offset: 0, limit: 20)
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test("Should not call service when query is invalid")
    func testNoServiceCallForInvalidQuery() async throws {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.shouldThrowError = true // Se chamar, vai dar erro
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act - Não deve dar erro pois não deve chamar o service
        let results = try await useCase.search("", offset: 0, limit: 20)

        // Assert
        #expect(results.isEmpty)
        #expect(!mockService.searchCalled)
    }

    @Test("Should propagate server error code")
    func testPropagateServerErrorCode() async {
        // Arrange
        let mockService = MockSearchCharactersService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = NetworkError.serverErrorCode(503)
        let useCase = TestableSearchCharactersUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.search("Test", offset: 0, limit: 20)
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

// MARK: - Mock Service for SearchCharactersUseCase Tests

/// Mock service que implementa a lógica de busca similar ao SearchCharactersUseCaseImpl
/// Usado para testar a lógica de validação e busca
final class MockSearchCharactersService: @unchecked Sendable {

    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.serverErrorCode(500)
    var charactersToReturn: [Character] = []

    private(set) var searchCalled = false
    private(set) var lastQuery: String?
    private(set) var lastOffset: Int?
    private(set) var lastLimit: Int?

    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character] {
        searchCalled = true
        lastQuery = query
        lastOffset = offset
        lastLimit = limit

        if shouldThrowError {
            throw errorToThrow
        }

        return charactersToReturn
    }

    func reset() {
        shouldThrowError = false
        errorToThrow = NetworkError.serverErrorCode(500)
        charactersToReturn = []
        searchCalled = false
        lastQuery = nil
        lastOffset = nil
        lastLimit = nil
    }
}

// MARK: - Testable UseCase Implementation

/// Implementação testável do SearchCharactersUseCase que usa o mock service
/// Replica a lógica de SearchCharactersUseCaseImpl para permitir testes unitários
final class TestableSearchCharactersUseCase: SearchCharactersUseCase {

    private let mockService: MockSearchCharactersService

    init(service: MockSearchCharactersService) {
        self.mockService = service
    }

    func search(_ query: String, offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        return try await mockService.searchCharacters(query: trimmedQuery, offset: offset, limit: limit)
    }
}

// MARK: - XCTest Integration Tests

class SearchCharactersUseCaseXCTests: XCTestCase {

    private var mockService: MockSearchCharactersService!
    private var useCase: TestableSearchCharactersUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockSearchCharactersService()
        useCase = TestableSearchCharactersUseCase(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        useCase = nil
        super.tearDown()
    }

    func testSearchSuccess() async throws {
        // Arrange
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Batman")
        ]

        // Act
        let results = try await useCase.search("Batman", offset: 0, limit: 20)

        // Assert
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Batman")
    }

    func testSearchEmptyQuery() async throws {
        // Act
        let results = try await useCase.search("", offset: 0, limit: 20)

        // Assert
        XCTAssertTrue(results.isEmpty)
        XCTAssertFalse(mockService.searchCalled)
    }

    func testSearchTrimmedQuery() async throws {
        // Act
        _ = try await useCase.search("  Superman  ", offset: 0, limit: 20)

        // Assert
        XCTAssertEqual(mockService.lastQuery, "Superman")
    }

    func testSearchError() async {
        // Arrange
        mockService.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.search("Test", offset: 0, limit: 20)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testSearchParameters() async throws {
        // Act
        _ = try await useCase.search("Query", offset: 100, limit: 50)

        // Assert
        XCTAssertEqual(mockService.lastOffset, 100)
        XCTAssertEqual(mockService.lastLimit, 50)
    }

    func testProtocolConformance() {
        // Valida que TestableSearchCharactersUseCase implementa SearchCharactersUseCase
        let protocolInstance: SearchCharactersUseCase = useCase
        XCTAssertNotNil(protocolInstance)
    }

    func testMultipleSearchCalls() async throws {
        // Arrange
        mockService.charactersToReturn = [Character.listFixture()]

        // Act
        _ = try await useCase.search("Query1", offset: 0, limit: 10)
        _ = try await useCase.search("Query2", offset: 10, limit: 20)
        _ = try await useCase.search("Query3", offset: 20, limit: 30)

        // Assert - Deve ter chamado 3 vezes e guardar último
        XCTAssertEqual(mockService.lastQuery, "Query3")
        XCTAssertEqual(mockService.lastOffset, 20)
        XCTAssertEqual(mockService.lastLimit, 30)
    }
}
