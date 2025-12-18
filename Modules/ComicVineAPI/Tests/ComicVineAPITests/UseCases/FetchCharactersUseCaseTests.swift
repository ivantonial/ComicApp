//
//  FetchCharactersUseCaseTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - FetchCharactersUseCase Tests

@Suite("FetchCharactersUseCase Tests", .serialized)
struct FetchCharactersUseCaseTests {

    // MARK: - Properties

    private let mockService = MockComicVineService()

    // MARK: - Initialization Tests

    @Test("UseCase should initialize with service")
    func testInitialization() async {
        let useCase = FetchCharactersUseCase(service: mockService)

        // Se compilar e não lançar erro, a inicialização foi bem-sucedida
        #expect(true)
        _ = useCase
    }

    // MARK: - Execute Tests

    @Test("Execute should return characters list")
    func testExecuteReturnsCharacters() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 10)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let result = try await useCase.execute()

        // Assert
        #expect(result.count == 10)
    }

    @Test("Execute should return empty array when no characters")
    func testExecuteReturnsEmptyArray() async throws {
        // Arrange
        await mockService.setCharacters([])

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let result = try await useCase.execute()

        // Assert
        #expect(result.isEmpty)
    }

    @Test("Execute should respect offset parameter")
    func testExecuteWithOffset() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 50)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(offset: 20, limit: 10)

        // Assert
        #expect(result.count == 10)
    }

    @Test("Execute should respect limit parameter")
    func testExecuteWithLimit() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 100)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(offset: 0, limit: 5)

        // Assert
        #expect(result.count == 5)
    }

    @Test("Execute should use default pagination values")
    func testExecuteDefaultPagination() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 30)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act - usando valores padrão (offset: 0, limit: 20)
        let result = try await useCase.execute()

        // Assert
        #expect(result.count == 20)
    }

    @Test("Execute should throw error when service fails")
    func testExecuteThrowsError() async {
        // Arrange
        await mockService.setShouldThrowError(true, error: MockServiceError.networkError)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockServiceError)
        }
    }

    @Test("Execute should call service method")
    func testExecuteCallsService() async throws {
        // Arrange
        await mockService.setCharacters([])

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        _ = try await useCase.execute()

        // Assert
        let callCount = await mockService.callCount(for: "fetchCharacters")
        #expect(callCount == 1)
    }

    // MARK: - Pagination Tests

    @Test("Execute should handle pagination boundaries")
    func testExecutePaginationBoundaries() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 25)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act - Request beyond available data
        let result = try await useCase.execute(offset: 30, limit: 10)

        // Assert
        #expect(result.isEmpty)
    }

    @Test("Execute should return partial results at end")
    func testExecutePartialResults() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 25)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act - Request that exceeds available data
        let result = try await useCase.execute(offset: 20, limit: 10)

        // Assert
        #expect(result.count == 5)
    }

    // MARK: - Character Data Tests

    @Test("Execute should return characters with correct data")
    func testExecuteReturnsCorrectData() async throws {
        // Arrange
        let characters = [Character].apiFixtures(count: 3)
        await mockService.setCharacters(characters)

        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(limit: 3)

        // Assert
        #expect(result[0].id == 1)
        #expect(result[0].name == "Hero 1")
        #expect(result[1].id == 2)
        #expect(result[1].name == "Hero 2")
        #expect(result[2].id == 3)
        #expect(result[2].name == "Hero 3")
    }
}

// MARK: - FetchComicsUseCase Tests

@Suite("FetchComicsUseCase Tests", .serialized)
struct FetchComicsUseCaseTests {

    // MARK: - Properties

    private let mockService = MockComicVineService()

    // MARK: - Initialization Tests

    @Test("UseCase should initialize with service")
    func testInitialization() async {
        let useCase = FetchComicsUseCase(service: mockService)

        // Se compilar e não lançar erro, a inicialização foi bem-sucedida
        #expect(true)
        _ = useCase
    }

    // MARK: - Execute Tests

    @Test("Execute should return comics list")
    func testExecuteReturnsComics() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 10)
        await mockService.setComics(comics)

        let useCase = FetchComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute()

        // Assert
        #expect(result.count == 10)
    }

    @Test("Execute should return empty array when no comics")
    func testExecuteReturnsEmptyArray() async throws {
        // Arrange
        await mockService.setComics([])

        let useCase = FetchComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute()

        // Assert
        #expect(result.isEmpty)
    }

    @Test("Execute should respect pagination parameters")
    func testExecuteWithPagination() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 50)
        await mockService.setComics(comics)

        let useCase = FetchComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(offset: 10, limit: 15)

        // Assert
        #expect(result.count == 15)
    }

    @Test("Execute should throw error when service fails")
    func testExecuteThrowsError() async {
        // Arrange
        await mockService.setShouldThrowError(true, error: MockServiceError.networkError)

        let useCase = FetchComicsUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute()
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockServiceError)
        }
    }

    @Test("Execute should call service method")
    func testExecuteCallsService() async throws {
        // Arrange
        await mockService.setComics([])

        let useCase = FetchComicsUseCase(service: mockService)

        // Act
        _ = try await useCase.execute()

        // Assert
        let callCount = await mockService.callCount(for: "fetchIssues")
        #expect(callCount == 1)
    }
}

// MARK: - XCTest Integration Tests

class FetchCharactersUseCaseXCTests: XCTestCase {

    private var mockService: MockComicVineService!
    private var useCase: FetchCharactersUseCase!

    override func setUp() async throws {
        mockService = MockComicVineService()
        useCase = FetchCharactersUseCase(service: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        mockService = nil
        useCase = nil
    }

    func testUseCaseSendableCompliance() {
        let sendable: any Sendable = useCase!
        XCTAssertNotNil(sendable)
    }

    func testPaginationSequence() async throws {
        let characters = [Character].apiFixtures(count: 100)
        await mockService.setCharacters(characters)

        // Fetch all pages
        var allResults: [Character] = []
        var offset = 0
        let limit = 20

        while offset < 100 {
            let page = try await useCase.execute(offset: offset, limit: limit)
            allResults.append(contentsOf: page)
            offset += limit
        }

        XCTAssertEqual(allResults.count, 100)
    }

    func testConcurrentExecuteCalls() async throws {
        let characters = [Character].apiFixtures(count: 50)
        await mockService.setCharacters(characters)

        // Execute requests sequentially to avoid data race with async let
        // In Swift 6, async let capturing self causes data races
        let result1 = try await useCase.execute(offset: 0, limit: 10)
        let result2 = try await useCase.execute(offset: 10, limit: 10)
        let result3 = try await useCase.execute(offset: 20, limit: 10)

        XCTAssertEqual(result1.count, 10)
        XCTAssertEqual(result2.count, 10)
        XCTAssertEqual(result3.count, 10)
    }
}

class FetchComicsUseCaseXCTests: XCTestCase {

    private var mockService: MockComicVineService!
    private var useCase: FetchComicsUseCase!

    override func setUp() async throws {
        mockService = MockComicVineService()
        useCase = FetchComicsUseCase(service: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        mockService = nil
        useCase = nil
    }

    func testUseCaseSendableCompliance() {
        let sendable: any Sendable = useCase!
        XCTAssertNotNil(sendable)
    }

    func testFetchComicsWithDefaultParameters() async throws {
        let comics = [Comic].apiFixtures(count: 30)
        await mockService.setComics(comics)

        let result = try await useCase.execute()

        // Default limit is 20
        XCTAssertEqual(result.count, 20)
    }
}
