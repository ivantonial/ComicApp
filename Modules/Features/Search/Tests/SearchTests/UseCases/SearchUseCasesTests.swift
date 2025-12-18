//
//  SearchUseCasesTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import Search
@testable import ComicVineAPI
@testable import Cache
import Foundation
import Networking
import Testing
import XCTest

// MARK: - SearchCharactersWithCacheUseCase Initialization Tests

@Suite("SearchCharactersWithCacheUseCase Initialization Tests")
struct SearchCharactersUseCaseInitTests {

    @Test("Should initialize with service and cache manager")
    func testInitializationWithServiceAndCache() async {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()

        // Act
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Assert
        #expect(useCase != nil)
    }

    @Test("Should initialize with service only using default cache")
    func testInitializationWithServiceOnly() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let useCase = SearchCharactersWithCacheUseCase(service: mockService)

        // Assert
        #expect(useCase != nil)
    }

    @Test("Should be Sendable")
    func testSendableConformance() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let useCase: Sendable = SearchCharactersWithCacheUseCase(service: mockService)

        // Assert
        #expect(useCase is SearchCharactersWithCacheUseCase)
    }
}

// MARK: - SearchCharactersWithCacheUseCase Execute Tests

@Suite("SearchCharactersWithCacheUseCase Execute Tests")
struct SearchCharactersUseCaseExecuteTests {

    @Test("Should return empty array for empty query")
    func testEmptyQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "")

        // Assert
        #expect(result.isEmpty)
        #expect(mockService.searchCharactersCalled == false)
    }

    @Test("Should return empty array for whitespace-only query")
    func testWhitespaceQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "   ")

        // Assert
        #expect(result.isEmpty)
        #expect(mockService.searchCharactersCalled == false)
    }

    @Test("Should trim query before calling service")
    func testTrimmedQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use name matching the trimmed query "Spider"
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "  Spider  ")

        // Assert
        #expect(mockService.searchCharactersLastQuery == "Spider")
    }

    @Test("Should return characters from service")
    func testReturnsCharactersFromService() async throws {
        // Arrange
        let mockService = MockSearchService()
        let expectedCharacters = [
            Character.searchFixture(id: 1, name: "Spider-Man"),
            Character.searchFixture(id: 2, name: "Spider-Woman")
        ]
        mockService.charactersToReturn = expectedCharacters
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Spider")

        // Assert
        #expect(result.count == 2)
        #expect(result[0].name == "Spider-Man")
        #expect(result[1].name == "Spider-Woman")
    }

    @Test("Should pass offset and limit to service")
    func testPassesOffsetAndLimit() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Test", offset: 10, limit: 25)

        // Assert
        #expect(mockService.searchCharactersLastOffset == 10)
        #expect(mockService.searchCharactersLastLimit == 25)
    }

    @Test("Should use default offset 0 and limit 20")
    func testDefaultOffsetAndLimit() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Test")

        // Assert
        #expect(mockService.searchCharactersLastOffset == 0)
        #expect(mockService.searchCharactersLastLimit == 20)
    }

    @Test("Should throw error when service throws")
    func testThrowsServiceError() async {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError(.serverErrorCode(500))
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
}

// MARK: - SearchCharactersWithCacheUseCase Cache Tests

@Suite("SearchCharactersWithCacheUseCase Cache Tests")
struct SearchCharactersUseCaseCacheTests {

    @Test("Should save results to cache")
    func testSavesToCache() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use name matching the query "Spider"
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Spider")

        // Assert
        #expect(await mockCache.saveCalled)
        #expect(await mockCache.saveCallCount == 1)
    }

    @Test("Should set expiration date after saving")
    func testSetsExpirationDate() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Spider")

        // Assert
        #expect(await mockCache.setExpirationCalled)
        #expect(await mockCache.setExpirationCallCount == 1)
    }

    @Test("Should not save empty results to cache")
    func testDoesNotSaveEmptyResults() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.charactersToReturn = []
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "NonExistent")

        // Assert
        #expect(await mockCache.saveCalled == false)
    }

    @Test("Should load from cache when not expired")
    func testLoadsFromCacheWhenValid() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()

        // Setup cache with valid data
        let cachedCharacters = [
            EncodableCharacter(from: Character.searchFixture(id: 1, name: "Cached Hero"))
        ]
        await mockCache.setupValidCache(cachedCharacters, forKey: "search_characters_Spider_0_20")

        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Spider")

        // Assert
        #expect(result.count == 1)
        #expect(result[0].name == "Cached Hero")
        #expect(mockService.searchCharactersCalled == false) // Should not call service
    }

    @Test("Should call service when cache is expired")
    func testCallsServiceWhenCacheExpired() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use name that matches the query "Spider"
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man Fresh")]
        let mockCache = MockSearchCacheManager()

        // Setup expired cache
        let cachedCharacters = [
            EncodableCharacter(from: Character.searchFixture(id: 2, name: "Spider-Man Old"))
        ]
        await mockCache.setupExpiredCache(cachedCharacters, forKey: "search_characters_Spider_0_20")

        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Spider")

        // Assert
        #expect(result.count == 1)
        #expect(result[0].name == "Spider-Man Fresh")
        #expect(mockService.searchCharactersCalled == true)
    }
}

// MARK: - SearchComicsWithCacheUseCase Initialization Tests

@Suite("SearchComicsWithCacheUseCase Initialization Tests")
struct SearchComicsUseCaseInitTests {

    @Test("Should initialize with service and cache manager")
    func testInitializationWithServiceAndCache() async {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()

        // Act
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Assert
        #expect(useCase != nil)
    }

    @Test("Should initialize with service only using default cache")
    func testInitializationWithServiceOnly() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let useCase = SearchComicsWithCacheUseCase(service: mockService)

        // Assert
        #expect(useCase != nil)
    }

    @Test("Should be Sendable")
    func testSendableConformance() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let useCase: Sendable = SearchComicsWithCacheUseCase(service: mockService)

        // Assert
        #expect(useCase is SearchComicsWithCacheUseCase)
    }
}

// MARK: - SearchComicsWithCacheUseCase Execute Tests

@Suite("SearchComicsWithCacheUseCase Execute Tests")
struct SearchComicsUseCaseExecuteTests {

    @Test("Should return empty array for empty query")
    func testEmptyQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "")

        // Assert
        #expect(result.isEmpty)
        #expect(mockService.searchComicsCalled == false)
    }

    @Test("Should return empty array for whitespace-only query")
    func testWhitespaceQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "   ")

        // Assert
        #expect(result.isEmpty)
        #expect(mockService.searchComicsCalled == false)
    }

    @Test("Should trim query before calling service")
    func testTrimmedQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use name matching the trimmed query "Batman"
        mockService.comicsToReturn = [Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "  Batman  ")

        // Assert
        #expect(mockService.searchComicsLastQuery == "Batman")
    }

    @Test("Should return comics from service")
    func testReturnsComicsFromService() async throws {
        // Arrange
        let mockService = MockSearchService()
        let expectedComics = [
            Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1"),
            Comic.ongoingSearchFixture(id: 2, volumeName: "Batman", issueNumber: "2")
        ]
        mockService.comicsToReturn = expectedComics
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Batman")

        // Assert
        #expect(result.count == 2)
        #expect(result[0].title == "Batman #1")
        #expect(result[1].title == "Batman #2")
    }

    @Test("Should pass offset and limit to service")
    func testPassesOffsetAndLimit() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Test", offset: 15, limit: 30)

        // Assert
        #expect(mockService.searchComicsLastOffset == 15)
        #expect(mockService.searchComicsLastLimit == 30)
    }

    @Test("Should use default offset 0 and limit 20")
    func testDefaultOffsetAndLimit() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Test")

        // Assert
        #expect(mockService.searchComicsLastOffset == 0)
        #expect(mockService.searchComicsLastLimit == 20)
    }

    @Test("Should throw error when service throws")
    func testThrowsServiceError() async {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError(.serverErrorCode(503))
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
}

// MARK: - SearchComicsWithCacheUseCase Cache Tests

@Suite("SearchComicsWithCacheUseCase Cache Tests")
struct SearchComicsUseCaseCacheTests {

    @Test("Should save results to cache")
    func testSavesToCache() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use a comic with name matching the query
        mockService.comicsToReturn = [Comic.namedSearchComicFixture(id: 1, name: "Test Search Comic")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act - use query that matches the comic name
        _ = try await useCase.execute(query: "Test")

        // Assert
        #expect(await mockCache.saveCalled)
        #expect(await mockCache.saveCallCount == 1)
    }

    @Test("Should set expiration date after saving")
    func testSetsExpirationDate() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.comicsToReturn = [Comic.namedSearchComicFixture(id: 1, name: "Test Search Comic")]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "Test")

        // Assert
        #expect(await mockCache.setExpirationCalled)
        #expect(await mockCache.setExpirationCallCount == 1)
    }

    @Test("Should not save empty results to cache")
    func testDoesNotSaveEmptyResults() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.comicsToReturn = []
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        _ = try await useCase.execute(query: "NonExistent")

        // Assert
        #expect(await mockCache.saveCalled == false)
    }

    @Test("Should load from cache when not expired")
    func testLoadsFromCacheWhenValid() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()

        // Setup cache with valid data - use name matching the query
        let cachedComics = [
            EncodableComic(from: Comic.namedSearchComicFixture(id: 1, name: "Batman Cached"))
        ]
        await mockCache.setupValidCache(cachedComics, forKey: "search_comics_Batman_0_20")

        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Batman")

        // Assert
        #expect(result.count == 1)
        #expect(result[0].name == "Batman Cached")
        #expect(mockService.searchComicsCalled == false) // Should not call service
    }

    @Test("Should call service when cache is expired")
    func testCallsServiceWhenCacheExpired() async throws {
        // Arrange
        let mockService = MockSearchService()
        // Use name matching the query "Batman"
        mockService.comicsToReturn = [Comic.namedSearchComicFixture(id: 1, name: "Batman Fresh")]
        let mockCache = MockSearchCacheManager()

        // Setup expired cache
        let cachedComics = [
            EncodableComic(from: Comic.namedSearchComicFixture(id: 2, name: "Batman Old"))
        ]
        await mockCache.setupExpiredCache(cachedComics, forKey: "search_comics_Batman_0_20")

        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Batman")

        // Assert
        #expect(result.count == 1)
        #expect(result[0].name == "Batman Fresh")
        #expect(mockService.searchComicsCalled == true)
    }
}

// MARK: - XCTest Integration Tests

class SearchUseCasesXCTests: XCTestCase {

    // MARK: - SearchCharactersWithCacheUseCase Tests

    func testSearchCharactersReturnsResults() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Spider-Man")
        ]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Spider")

        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Spider-Man")
    }

    func testSearchCharactersEmptyQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "")

        // Assert
        XCTAssertTrue(result.isEmpty)
        XCTAssertFalse(mockService.searchCharactersCalled)
    }

    func testSearchCharactersThrowsError() async {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    // MARK: - SearchComicsWithCacheUseCase Tests

    func testSearchComicsReturnsResults() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.comicsToReturn = [
            Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")
        ]
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "Batman")

        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "Batman #1")
    }

    func testSearchComicsEmptyQuery() async throws {
        // Arrange
        let mockService = MockSearchService()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act
        let result = try await useCase.execute(query: "")

        // Assert
        XCTAssertTrue(result.isEmpty)
        XCTAssertFalse(mockService.searchComicsCalled)
    }

    func testSearchComicsThrowsError() async {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError()
        let mockCache = MockSearchCacheManager()
        let useCase = SearchComicsWithCacheUseCase(service: mockService, cacheManager: mockCache)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "Test")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
