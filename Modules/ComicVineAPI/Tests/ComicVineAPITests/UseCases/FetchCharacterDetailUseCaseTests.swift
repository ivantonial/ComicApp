//
//  FetchCharacterDetailUseCaseTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - FetchCharacterDetailUseCase Tests

@Suite("FetchCharacterDetailUseCase Tests", .serialized)
struct FetchCharacterDetailUseCaseTests {

    // MARK: - Properties

    private let mockService = MockComicVineService()

    // MARK: - Initialization Tests

    @Test("UseCase should initialize with service")
    func testInitialization() async {
        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Se compilar e não lançar erro, a inicialização foi bem-sucedida
        #expect(true)
        _ = useCase
    }

    // MARK: - Execute Tests

    @Test("Execute should return character for valid ID")
    func testExecuteReturnsCharacter() async throws {
        // Arrange
        let expectedCharacter = Character.apiFixture(id: 1, name: "Spider-Man")
        await mockService.setCharacter(expectedCharacter, forId: 1)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.id == 1)
        #expect(result.name == "Spider-Man")
    }

    @Test("Execute should return character with all details")
    func testExecuteReturnsFullDetails() async throws {
        // Arrange
        let expectedCharacter = Character.apiFixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 500,
            realName: "Bruce Wayne",
            includeRelations: true
        )
        await mockService.setCharacter(expectedCharacter, forId: 42)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 42)

        // Assert
        #expect(result.id == 42)
        #expect(result.name == "Batman")
        #expect(result.description == "The Dark Knight")
        #expect(result.countOfIssueAppearances == 500)
        #expect(result.realName == "Bruce Wayne")
        #expect(result.characterEnemies != nil)
        #expect(result.powers != nil)
    }

    @Test("Execute should throw error when character not found")
    func testExecuteThrowsNotFound() async {
        // Arrange - não configurar nenhum character
        await mockService.reset()

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute(characterId: 999)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is MockServiceError)
        }
    }

    @Test("Execute should throw error when service fails")
    func testExecuteThrowsServiceError() async {
        // Arrange
        await mockService.setShouldThrowError(true, error: MockServiceError.networkError)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

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
        let character = Character.apiFixture(id: 1)
        await mockService.setCharacter(character, forId: 1)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(characterId: 1)

        // Assert
        let callCount = await mockService.callCount(for: "fetchCharacter")
        #expect(callCount == 1)
    }

    // MARK: - Different Character IDs Tests

    @Test("Execute should fetch correct character by ID")
    func testExecuteFetchesCorrectCharacter() async throws {
        // Arrange
        let spiderman = Character.apiFixture(id: 1, name: "Spider-Man")
        let batman = Character.apiFixture(id: 2, name: "Batman")
        let superman = Character.apiFixture(id: 3, name: "Superman")

        await mockService.setCharacter(spiderman, forId: 1)
        await mockService.setCharacter(batman, forId: 2)
        await mockService.setCharacter(superman, forId: 3)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act & Assert
        let result1 = try await useCase.execute(characterId: 1)
        #expect(result1.name == "Spider-Man")

        let result2 = try await useCase.execute(characterId: 2)
        #expect(result2.name == "Batman")

        let result3 = try await useCase.execute(characterId: 3)
        #expect(result3.name == "Superman")
    }

    // MARK: - Character Data Tests

    @Test("Execute should preserve character relations")
    func testExecutePreservesRelations() async throws {
        // Arrange
        let character = Character.apiFixture(id: 1, includeRelations: true)
        await mockService.setCharacter(character, forId: 1)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.characterEnemies != nil)
        #expect(result.characterFriends != nil)
        #expect(result.powers != nil)
        #expect(result.teams != nil)
        #expect(result.issueCredits != nil)
    }

    @Test("Execute should handle character without relations")
    func testExecuteHandlesNoRelations() async throws {
        // Arrange
        let character = Character.apiFixture(id: 1, includeRelations: false)
        await mockService.setCharacter(character, forId: 1)

        let useCase = FetchCharacterDetailUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(characterId: 1)

        // Assert
        #expect(result.characterEnemies == nil)
        #expect(result.characterFriends == nil)
        #expect(result.powers == nil)
    }
}

// MARK: - XCTest Integration Tests

class FetchCharacterDetailUseCaseXCTests: XCTestCase {

    private var mockService: MockComicVineService!
    private var useCase: FetchCharacterDetailUseCase!

    override func setUp() async throws {
        mockService = MockComicVineService()
        useCase = FetchCharacterDetailUseCase(service: mockService)
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

    func testExecuteWithVariousIds() async throws {
        let testIds = [1, 100, 1000, 99999]

        for id in testIds {
            let character = Character.apiFixture(id: id, name: "Hero \(id)")
            await mockService.setCharacter(character, forId: id)

            let result = try await useCase.execute(characterId: id)
            XCTAssertEqual(result.id, id)
            XCTAssertEqual(result.name, "Hero \(id)")
        }
    }

    func testMultipleExecuteCalls() async throws {
        let character = Character.apiFixture(id: 1)
        await mockService.setCharacter(character, forId: 1)

        // Execute multiple times
        for _ in 1...5 {
            let result = try await useCase.execute(characterId: 1)
            XCTAssertEqual(result.id, 1)
        }

        // Verify service was called 5 times
        let callCount = await mockService.callCount(for: "fetchCharacter")
        XCTAssertEqual(callCount, 5)
    }

    func testErrorHandling() async {
        await mockService.setShouldThrowError(true, error: MockServiceError.invalidResponse)

        do {
            _ = try await useCase.execute(characterId: 1)
            XCTFail("Should have thrown an error")
        } catch let error as MockServiceError {
            XCTAssertEqual(error, MockServiceError.invalidResponse)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
