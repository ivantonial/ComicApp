//
//  CharacterListSearchUseCaseTests.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import CharacterList
@testable import ComicVineAPI
import Foundation
import Networking
import Testing
import XCTest

// MARK: - CharacterListSearchUseCase Creation Tests

@Suite("CharacterListSearchUseCase Creation Tests")
struct CharacterListSearchUseCaseCreationTests {

    @Test("Should create use case with service")
    func testCreateWithService() {
        // Arrange
        let mockService = MockCharacterListService()

        // Act
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Assert
        #expect(useCase != nil)
    }

    @Test("UseCase should be Sendable")
    func testSendableConformance() {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act & Assert
        let _: Sendable = useCase
        #expect(true)
    }
}

// MARK: - CharacterListSearchUseCase Execute Tests

@Suite("CharacterListSearchUseCase Execute Tests")
struct CharacterListSearchUseCaseExecuteTests {

    @Test("Should return characters from service")
    func testExecuteReturnsCharacters() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Spider-Woman")
        ]
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        let results = try await useCase.execute(query: "Spider")

        // Assert
        #expect(results.count == 2)
        #expect(results[0].name == "Spider-Man")
        #expect(results[1].name == "Spider-Woman")
    }

    @Test("Should use default offset and limit")
    func testExecuteWithDefaultParameters() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(query: "Batman")

        // Assert
        #expect(mockService.searchCharactersCalled)
        #expect(mockService.searchCharactersLastOffset == 0)
        #expect(mockService.searchCharactersLastLimit == 20)
    }

    @Test("Should respect custom offset and limit")
    func testExecuteWithCustomParameters() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(query: "Superman", offset: 40, limit: 10)

        // Assert
        #expect(mockService.searchCharactersLastOffset == 40)
        #expect(mockService.searchCharactersLastLimit == 10)
    }

    @Test("Should pass query to service")
    func testExecutePassesQuery() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(query: "Wonder Woman")

        // Assert
        #expect(mockService.searchCharactersLastQuery == "Wonder Woman")
    }

    @Test("Should return empty array when service returns empty")
    func testExecuteReturnsEmptyArray() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = []
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        let results = try await useCase.execute(query: "Unknown Hero")

        // Assert
        #expect(results.isEmpty)
    }
}

// MARK: - CharacterListSearchUseCase Error Handling Tests

@Suite("CharacterListSearchUseCase Error Handling Tests")
struct CharacterListSearchUseCaseErrorTests {

    @Test("Should throw error when service fails")
    func testExecuteThrowsError() async {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.shouldThrowError = true
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Hero")
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test("Should propagate network error")
    func testPropagatNetworkError() async {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = NetworkError.noData
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            #expect(Bool(false), "Expected error to be thrown")
        } catch let error as NetworkError {
            if case .noData = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected noData error")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError")
        }
    }

    @Test("Should propagate server error")
    func testPropagateServerError() async {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.setupNetworkError(.serverErrorCode(503))
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
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

// MARK: - CharacterListSearchUseCase Pagination Tests

@Suite("CharacterListSearchUseCase Pagination Tests")
struct CharacterListSearchUseCasePaginationTests {

    @Test("Should handle pagination correctly")
    func testPagination() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = .listFixtures(count: 20)
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act - First page
        let page1 = try await useCase.execute(query: "Hero", offset: 0, limit: 10)

        // Act - Second page
        let page2 = try await useCase.execute(query: "Hero", offset: 10, limit: 10)

        // Assert
        #expect(page1.count == 20) // Mock retorna todos
        #expect(page2.count == 20) // Mock retorna todos
        #expect(mockService.searchCharactersCallCount == 2)
    }

    @Test("Should track multiple calls")
    func testMultipleCalls() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(query: "Query1")
        _ = try await useCase.execute(query: "Query2")
        _ = try await useCase.execute(query: "Query3")

        // Assert
        #expect(mockService.searchCharactersCallCount == 3)
        #expect(mockService.searchCharactersLastQuery == "Query3")
    }
}

// MARK: - XCTest Integration Tests

class CharacterListSearchUseCaseXCTests: XCTestCase {

    private var mockService: MockCharacterListService!
    private var useCase: CharacterListSearchUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockCharacterListService()
        useCase = CharacterListSearchUseCase(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        useCase = nil
        super.tearDown()
    }

    func testExecuteSuccess() async throws {
        // Arrange
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Test Hero")
        ]

        // Act
        let results = try await useCase.execute(query: "Test")

        // Assert
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Test Hero")
    }

    func testExecuteWithEmptyQuery() async throws {
        // Arrange
        mockService.charactersToReturn = .searchTestFixtures()

        // Act
        let results = try await useCase.execute(query: "")

        // Assert
        XCTAssertEqual(results.count, 10) // Retorna todos quando query vazia
    }

    func testExecuteError() async {
        // Arrange
        mockService.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testExecuteCallsService() async throws {
        // Act
        _ = try await useCase.execute(query: "Spider", offset: 20, limit: 15)

        // Assert
        XCTAssertTrue(mockService.searchCharactersCalled)
        XCTAssertEqual(mockService.searchCharactersLastQuery, "Spider")
        XCTAssertEqual(mockService.searchCharactersLastOffset, 20)
        XCTAssertEqual(mockService.searchCharactersLastLimit, 15)
    }
}
