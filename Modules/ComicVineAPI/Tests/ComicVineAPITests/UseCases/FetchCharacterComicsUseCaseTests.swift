//
//  FetchCharacterComicsUseCaseTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - FetchCharacterComicsUseCase Tests

@Suite("FetchCharacterComicsUseCase Tests", .serialized)
struct FetchCharacterComicsUseCaseTests {

    // MARK: - Properties

    private let mockService = MockComicVineService()

    // MARK: - Initialization Tests

    @Test("UseCase should initialize with service")
    func testInitialization() async {
        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Se compilar e não lançar erro, a inicialização foi bem-sucedida
        #expect(true)
        _ = useCase
    }

    // MARK: - Execute Tests

    @Test("Execute should return comics for character")
    func testExecuteReturnsComics() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 5)
        await mockService.setCharacterComics(comics, forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.count == 5)
    }

    @Test("Execute should return empty array when no comics")
    func testExecuteReturnsEmptyArray() async throws {
        // Arrange
        await mockService.setCharacterComics([], forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.isEmpty)
    }

    @Test("Execute should respect offset parameter")
    func testExecuteWithOffset() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 30)
        await mockService.setCharacterComics(comics, forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1, offset: 10, limit: 10)

        // Assert
        #expect(result.count == 10)
    }

    @Test("Execute should respect limit parameter")
    func testExecuteWithLimit() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 50)
        await mockService.setCharacterComics(comics, forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1, offset: 0, limit: 5)

        // Assert
        #expect(result.count == 5)
    }

    @Test("Execute should use default pagination values")
    func testExecuteDefaultPagination() async throws {
        // Arrange
        let comics = [Comic].apiFixtures(count: 25)
        await mockService.setCharacterComics(comics, forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act - usando valores padrão (offset: 0, limit: 20)
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.count == 20)
    }

    @Test("Execute should throw error when service fails")
    func testExecuteThrowsError() async {
        // Arrange
        await mockService.setShouldThrowError(true, error: MockServiceError.networkError)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute(characterId: 1)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockServiceError)
        }
    }

    @Test("Execute should call service method")
    func testExecuteCallsService() async throws {
        // Arrange
        await mockService.setCharacterComics([], forCharacterId: 1)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(characterId: 1)

        // Assert
        let callCount = await mockService.callCount(for: "fetchCharacterComics")
        #expect(callCount == 1)
    }

    // MARK: - Character ID Tests

    @Test("Execute should use correct character ID")
    func testExecuteUsesCorrectCharacterId() async throws {
        // Arrange
        let comics1 = [Comic].apiFixtures(count: 3)
        let comics2 = [Comic].apiFixtures(count: 5)

        await mockService.setCharacterComics(comics1, forCharacterId: 1)
        await mockService.setCharacterComics(comics2, forCharacterId: 2)

        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let result1 = try await useCase.execute(characterId: 1)
        let result2 = try await useCase.execute(characterId: 2)

        // Assert
        #expect(result1.count == 3)
        #expect(result2.count == 5)
    }
}

// MARK: - XCTest Integration Tests

class FetchCharacterComicsUseCaseXCTests: XCTestCase {

    private var mockService: MockComicVineService!
    private var useCase: FetchCharacterComicsUseCase!

    override func setUp() async throws {
        mockService = MockComicVineService()
        useCase = FetchCharacterComicsUseCase(service: mockService)
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

    func testExecuteWithVariousCharacterIds() async throws {
        let characterIds = [1, 10, 100, 1000]

        for id in characterIds {
            let comics = [Comic].apiFixtures(count: id % 10 + 1)
            await mockService.setCharacterComics(comics, forCharacterId: id)

            let result = try await useCase.execute(characterId: id)
            XCTAssertEqual(result.count, id % 10 + 1)
        }
    }

    func testPaginationBoundaries() async throws {
        let comics = [Comic].apiFixtures(count: 100)
        await mockService.setCharacterComics(comics, forCharacterId: 1)

        // Test first page
        let firstPage = try await useCase.execute(characterId: 1, offset: 0, limit: 20)
        XCTAssertEqual(firstPage.count, 20)

        // Test middle page
        let middlePage = try await useCase.execute(characterId: 1, offset: 40, limit: 20)
        XCTAssertEqual(middlePage.count, 20)

        // Test last page
        let lastPage = try await useCase.execute(characterId: 1, offset: 80, limit: 20)
        XCTAssertEqual(lastPage.count, 20)

        // Test beyond bounds
        let beyondBounds = try await useCase.execute(characterId: 1, offset: 100, limit: 20)
        XCTAssertEqual(beyondBounds.count, 0)
    }
}
