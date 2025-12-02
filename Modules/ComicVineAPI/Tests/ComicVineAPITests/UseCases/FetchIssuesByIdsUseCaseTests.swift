//
//  FetchIssuesByIdsUseCaseTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - FetchIssuesByIdsUseCase Tests

@Suite("FetchIssuesByIdsUseCase Tests", .serialized)
struct FetchIssuesByIdsUseCaseTests {

    // MARK: - Properties

    private let mockService = MockComicVineService()

    // MARK: - Initialization Tests

    @Test("UseCase should initialize with service")
    func testInitialization() async {
        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Se compilar e não lançar erro, a inicialização foi bem-sucedida
        #expect(true)
        _ = useCase
    }

    // MARK: - Execute Tests

    @Test("Execute should return comics for given IDs")
    func testExecuteReturnsComics() async throws {
        // Arrange
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 101)
        let comic3 = Comic.apiFixture(id: 102)

        await mockService.setComic(comic1, forId: 100)
        await mockService.setComic(comic2, forId: 101)
        await mockService.setComic(comic3, forId: 102)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [100, 101, 102])

        // Assert
        #expect(result.count == 3)
    }

    @Test("Execute should return empty array for empty IDs")
    func testExecuteReturnsEmptyForEmptyIds() async throws {
        // Arrange
        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [])

        // Assert
        #expect(result.isEmpty)
    }

    @Test("Execute should handle single ID")
    func testExecuteSingleId() async throws {
        // Arrange
        let comic = Comic.apiFixture(id: 100)
        await mockService.setComic(comic, forId: 100)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [100])

        // Assert
        #expect(result.count == 1)
        #expect(result[0].id == 100)
    }

    @Test("Execute should skip failed IDs gracefully")
    func testExecuteSkipsFailedIds() async throws {
        // Arrange
        let comic1 = Comic.apiFixture(id: 100)
        let comic3 = Comic.apiFixture(id: 102)

        await mockService.setComic(comic1, forId: 100)
        // ID 101 não configurado - vai falhar
        await mockService.setComic(comic3, forId: 102)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [100, 101, 102])

        // Assert - deve retornar apenas os que foram encontrados
        #expect(result.count == 2)
    }

    @Test("Execute should use default batch size")
    func testExecuteDefaultBatchSize() async throws {
        // Arrange
        var comics: [Comic] = []
        for i in 100..<110 {
            let comic = Comic.apiFixture(id: i)
            comics.append(comic)
            await mockService.setComic(comic, forId: i)
        }

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let ids = (100..<110).map { $0 }

        // Act
        let result = try await useCase.execute(issueIds: ids)

        // Assert
        #expect(result.count == 10)
    }

    @Test("Execute should respect custom batch size")
    func testExecuteCustomBatchSize() async throws {
        // Arrange
        for i in 100..<105 {
            let comic = Comic.apiFixture(id: i)
            await mockService.setComic(comic, forId: i)
        }

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let ids = (100..<105).map { $0 }

        // Act
        let result = try await useCase.execute(issueIds: ids, batchSize: 2)

        // Assert
        #expect(result.count == 5)
    }

    @Test("Execute should call service for each ID")
    func testExecuteCallsServiceForEachId() async throws {
        // Arrange
        for i in 100..<103 {
            let comic = Comic.apiFixture(id: i)
            await mockService.setComic(comic, forId: i)
        }

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        _ = try await useCase.execute(issueIds: [100, 101, 102])

        // Assert
        let callCount = await mockService.callCount(for: "fetchIssue")
        #expect(callCount == 3)
    }

    // MARK: - Sorting Tests

    @Test("Execute should sort results by cover date descending")
    func testExecuteSortsByCoverDate() async throws {
        // Arrange
        let comic1 = Comic.withDateFixture(id: 100, coverDate: "2020-01-01")
        let comic2 = Comic.withDateFixture(id: 101, coverDate: "2024-01-01")
        let comic3 = Comic.withDateFixture(id: 102, coverDate: "2022-01-01")

        await mockService.setComic(comic1, forId: 100)
        await mockService.setComic(comic2, forId: 101)
        await mockService.setComic(comic3, forId: 102)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [100, 101, 102])

        // Assert - deve estar ordenado por data decrescente
        #expect(result[0].coverDate == "2024-01-01")
        #expect(result[1].coverDate == "2022-01-01")
        #expect(result[2].coverDate == "2020-01-01")
    }

    @Test("Execute should sort by ID when cover date is nil")
    func testExecuteSortsById() async throws {
        // Arrange
        let comic1 = Comic.minimalApiFixture(id: 100)
        let comic2 = Comic.minimalApiFixture(id: 200)
        let comic3 = Comic.minimalApiFixture(id: 150)

        await mockService.setComic(comic1, forId: 100)
        await mockService.setComic(comic2, forId: 200)
        await mockService.setComic(comic3, forId: 150)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let result = try await useCase.execute(issueIds: [100, 200, 150])

        // Assert - deve estar ordenado por ID decrescente
        #expect(result[0].id == 200)
        #expect(result[1].id == 150)
        #expect(result[2].id == 100)
    }

    // MARK: - Large Batch Tests

    @Test("Execute should handle large number of IDs")
    func testExecuteLargeNumberOfIds() async throws {
        // Arrange
        let count = 50
        for i in 100..<(100 + count) {
            let comic = Comic.apiFixture(id: i)
            await mockService.setComic(comic, forId: i)
        }

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let ids = (100..<(100 + count)).map { $0 }

        // Act
        let result = try await useCase.execute(issueIds: ids)

        // Assert
        #expect(result.count == count)
    }
}

// MARK: - XCTest Integration Tests

class FetchIssuesByIdsUseCaseXCTests: XCTestCase {

    private var mockService: MockComicVineService!
    private var useCase: FetchIssuesByIdsUseCase!

    override func setUp() async throws {
        mockService = MockComicVineService()
        useCase = FetchIssuesByIdsUseCase(service: mockService)
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

    func testBatchProcessing() async throws {
        // Configure 20 comics
        for i in 100..<120 {
            let comic = Comic.apiFixture(id: i)
            await mockService.setComic(comic, forId: i)
        }

        let ids = (100..<120).map { $0 }

        // Use batch size of 5 (should create 4 batches)
        let result = try await useCase.execute(issueIds: ids, batchSize: 5)

        XCTAssertEqual(result.count, 20)
    }

    func testPartialFailure() async throws {
        // Configure only some comics
        await mockService.setComic(Comic.apiFixture(id: 100), forId: 100)
        await mockService.setComic(Comic.apiFixture(id: 102), forId: 102)
        await mockService.setComic(Comic.apiFixture(id: 104), forId: 104)

        // Request IDs including ones that don't exist
        let ids = [100, 101, 102, 103, 104]
        let result = try await useCase.execute(issueIds: ids)

        // Should only return the ones that exist
        XCTAssertEqual(result.count, 3)
    }

    func testSortingConsistency() async throws {
        let dates = [
            (id: 100, date: "2020-01-01"),
            (id: 101, date: "2023-06-15"),
            (id: 102, date: "2021-03-20"),
            (id: 103, date: "2024-01-01"),
            (id: 104, date: "2019-12-31")
        ]

        for item in dates {
            let comic = Comic.withDateFixture(id: item.id, coverDate: item.date)
            await mockService.setComic(comic, forId: item.id)
        }

        let result = try await useCase.execute(issueIds: dates.map { $0.id })

        // Verify descending date order
        XCTAssertEqual(result[0].coverDate, "2024-01-01")
        XCTAssertEqual(result[1].coverDate, "2023-06-15")
        XCTAssertEqual(result[2].coverDate, "2021-03-20")
        XCTAssertEqual(result[3].coverDate, "2020-01-01")
        XCTAssertEqual(result[4].coverDate, "2019-12-31")
    }

    func testEmptyResultWhenAllFail() async throws {
        // Don't configure any comics
        await mockService.reset()

        let result = try await useCase.execute(issueIds: [100, 101, 102])

        XCTAssertTrue(result.isEmpty)
    }
}
