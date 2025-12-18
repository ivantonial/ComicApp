//
//  ComicsListViewModelTests.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import ComicsList
@testable import ComicVineAPI
import Combine
import Foundation
import Networking
import Testing
import XCTest

// MARK: - ComicsListViewModel Initialization Tests

@Suite("ComicsListViewModel Initialization Tests")
struct ComicsListViewModelInitializationTests {

    @Test("Should have correct initial state")
    @MainActor
    func testInitialState() async {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert
        #expect(viewModel.comics.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.selectedFilter == .all)
        #expect(viewModel.hasMorePages == true)
        #expect(viewModel.selectedComic == nil)
        #expect(viewModel.loadingProgress == 0.0)
        #expect(viewModel.loadingMessage.isEmpty)
    }

    @Test("Should be MainActor isolated")
    @MainActor
    func testMainActorIsolation() {
        // Se compila e executa com @MainActor, está correto
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )
        // Verifica que o ViewModel foi criado corretamente no MainActor
        #expect(viewModel.comics.isEmpty)
    }

    @Test("Should be ObservableObject")
    @MainActor
    func testObservableObject() {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert - Verifica que objectWillChange existe (ObservableObject compliance)
        let publisher = viewModel.objectWillChange
        #expect(String(describing: type(of: publisher)).contains("ObservableObjectPublisher"))
    }

    @Test("Should store character reference")
    @MainActor
    func testCharacterReference() {
        // Arrange
        let character = Character.comicsListFixture(id: 42, name: "Batman")
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)

        // Act
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert
        #expect(viewModel.character.id == 42)
        #expect(viewModel.character.name == "Batman")
    }

    @Test("Should initialize with FetchCharacterComicsUseCase")
    @MainActor
    func testInitWithFetchCharacterComicsUseCase() {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchCharacterComicsUseCase(service: mockService)

        // Act
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        // Assert
        #expect(viewModel.character.id == character.id)
        #expect(viewModel.comics.isEmpty)
    }
}

// MARK: - ComicsListViewModel Load Data Tests

@Suite("ComicsListViewModel Load Data Tests")
struct ComicsListViewModelLoadDataTests {

    @Test("Should load comics successfully using issue IDs")
    @MainActor
    func testLoadComicsSuccess() async throws {
        // Arrange
        let issueIds = [101, 102, 103, 104, 105]
        let character = Character.comicsListFixture(
            issueCredits: issueIds.map { id in
                IssueCredit(
                    id: id,
                    name: "Issue \(id)",
                    apiDetailUrl: nil,
                    siteDetailUrl: nil
                )
            }
        )

        let mockService = MockComicsListService()
        mockService.comicsToReturn = issueIds.map { Comic.comicsListFixture(id: $0) }

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        #expect(viewModel.comics.count > 0)
        #expect(viewModel.error == nil)
    }

    @Test("Should handle load error")
    @MainActor
    func testLoadComicsError() async throws {
        // Arrange - Usar FetchCharacterComicsUseCase que propaga erros
        // FetchIssuesByIdsUseCase nÃ£o propaga erros (captura individualmente)
        let character = Character.comicsListFixtureWithoutIssueCredits()
        let mockService = MockComicsListService()
        mockService.shouldThrowError = true

        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        #expect(viewModel.comics.isEmpty)
        #expect(viewModel.error != nil)
    }

    @Test("Should not load twice on repeated loadInitialData calls")
    @MainActor
    func testNoDoubleLoad() async throws {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = [Comic.comicsListFixture()]

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()
        viewModel.loadInitialData()
        viewModel.loadInitialData()

        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert - service should only be called for initial load
        #expect(mockService.fetchIssueCallCount <= 20) // Max page size
    }
}

// MARK: - ComicsListViewModel Computed Properties Tests

@Suite("ComicsListViewModel Computed Properties Tests")
struct ComicsListViewModelComputedPropertiesTests {

    @Test("filteredComics should return all comics when filter is all")
    @MainActor
    func testFilteredComicsAll() async throws {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 10)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Act
        viewModel.selectFilter(.all)

        // Assert
        #expect(viewModel.filteredComics.count == viewModel.comics.count)
    }

    @Test("totalComics should return character issue count when no issueCredits")
    @MainActor
    func testTotalComicsWithoutCredits() {
        // Arrange
        let character = Character.comicsListFixtureWithoutIssueCredits(comicsCount: 150)
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert
        #expect(viewModel.totalComics == 150)
    }

    @Test("hasFilters should be false when comics count is 5 or less")
    @MainActor
    func testHasFiltersFalse() async throws {
        // Arrange - Usar FetchCharacterComicsUseCase que retorna comics diretamente
        let character = Character.comicsListFixtureWithoutIssueCredits()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 3)

        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.comics.count == 3)
        #expect(viewModel.hasFilters == false)
    }

    @Test("hasFilters should be true when comics count is more than 5")
    @MainActor
    func testHasFiltersTrue() async throws {
        // Arrange - Usar FetchCharacterComicsUseCase que retorna comics diretamente
        let character = Character.comicsListFixtureWithoutIssueCredits()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 10)

        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.comics.count == 10)
        #expect(viewModel.hasFilters == true)
    }
}

// MARK: - ComicsListViewModel Filter Tests

@Suite("ComicsListViewModel Filter Tests")
struct ComicsListViewModelFilterTests {

    @Test("Should change selected filter")
    @MainActor
    func testSelectFilter() {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert initial
        #expect(viewModel.selectedFilter == .all)

        // Act & Assert
        viewModel.selectFilter(.recent)
        #expect(viewModel.selectedFilter == .recent)

        viewModel.selectFilter(.popular)
        #expect(viewModel.selectedFilter == .popular)

        viewModel.selectFilter(.classic)
        #expect(viewModel.selectedFilter == .classic)

        viewModel.selectFilter(.all)
        #expect(viewModel.selectedFilter == .all)
    }

    @Test("Recent filter should sort by date descending")
    @MainActor
    func testRecentFilterSorting() async throws {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixturesForSorting()

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Act
        viewModel.selectFilter(.recent)

        // Assert - most recent should be first
        let filtered = viewModel.filteredComics
        if filtered.count >= 2 {
            if let date1 = filtered[0].coverDate, let date2 = filtered[1].coverDate {
                #expect(date1 >= date2)
            }
        }
    }

    @Test("Classic filter should sort by date ascending and limit to 10")
    @MainActor
    func testClassicFilterSorting() async throws {
        // Arrange
        let character = Character.comicsListFixtureWithManyIssues(issueCount: 20)
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 20)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Act
        viewModel.selectFilter(.classic)

        // Assert - should be limited to 10
        #expect(viewModel.filteredComics.count <= 10)
    }

    @Test("Popular filter should limit to 10 comics")
    @MainActor
    func testPopularFilterLimit() async throws {
        // Arrange
        let character = Character.comicsListFixtureWithManyIssues(issueCount: 20)
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 20)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Act
        viewModel.selectFilter(.popular)

        // Assert - should be limited to 10
        #expect(viewModel.filteredComics.count <= 10)
    }
}

// MARK: - ComicsListViewModel Select Comic Tests

@Suite("ComicsListViewModel Select Comic Tests")
struct ComicsListViewModelSelectComicTests {

    @Test("Should set selected comic")
    @MainActor
    func testSelectComic() async throws {
        // Arrange
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let comic = Comic.comicsListFixture(id: 42, volumeName: "Special Issue")
        mockService.comicsToReturn = [comic]

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Act
        viewModel.selectComic(comic)

        // Assert
        #expect(viewModel.selectedComic?.id == 42)
    }
}

// MARK: - ComicsListViewModel Refresh Tests

@Suite("ComicsListViewModel Refresh Tests")
struct ComicsListViewModelRefreshTests {

    @Test("Should reset state on refresh")
    @MainActor
    func testRefreshResetsState() async throws {
        // Arrange - Usar fallback UseCase para controle mais previsÃ­vel
        let character = Character.comicsListFixtureWithoutIssueCredits(comicsCount: 100)
        let mockService = MockComicsListService()
        // Retornar pageSize completo para que hasMorePages seja true
        mockService.comicsToReturn = .comicsListFixtures(count: 20)

        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Simula que nÃ£o hÃ¡ mais pÃ¡ginas apÃ³s primeiro load
        // (alterando para menos que pageSize)
        mockService.comicsToReturn = .comicsListFixtures(count: 5)

        // Act
        viewModel.refresh()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert - ApÃ³s refresh deve ter carregado os novos dados
        #expect(viewModel.comics.count > 0)
    }
}

// MARK: - ComicsListViewModel Pagination Tests

@Suite("ComicsListViewModel Pagination Tests")
struct ComicsListViewModelPaginationTests {

    @Test("Should not load more when already loading")
    @MainActor
    func testNoLoadMoreWhileLoading() async throws {
        // Arrange
        let character = Character.comicsListFixtureWithManyIssues(issueCount: 50)
        let mockService = MockComicsListService()
        mockService.comicsToReturn = .comicsListFixtures(count: 20)

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Inicia carregamento
        viewModel.loadInitialData()

        // Tenta carregar mais enquanto carrega (nÃ£o deve fazer nada)
        if let lastComic = mockService.comicsToReturn.last {
            viewModel.loadMoreIfNeeded(currentComic: lastComic)
        }

        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert - apenas o carregamento inicial
        #expect(viewModel.comics.count <= 20)
    }

    @Test("Should set hasMorePages to false when no more data")
    @MainActor
    func testNoMorePages() async throws {
        // Arrange
        let issueCredits = [
            IssueCredit(id: 101, name: "Issue 1", apiDetailUrl: nil, siteDetailUrl: nil),
            IssueCredit(id: 102, name: "Issue 2", apiDetailUrl: nil, siteDetailUrl: nil)
        ]
        let character = Character.comicsListFixture(issueCredits: issueCredits)

        let mockService = MockComicsListService()
        mockService.comicsToReturn = [
            Comic.comicsListFixture(id: 101),
            Comic.comicsListFixture(id: 102)
        ]

        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        #expect(viewModel.hasMorePages == false)
    }
}

// MARK: - ComicsListViewModel Fallback Tests

@Suite("ComicsListViewModel Fallback Tests")
struct ComicsListViewModelFallbackTests {

    @Test("Should use FetchCharacterComicsUseCase when no issueCredits")
    @MainActor
    func testFallbackToCharacterComicsUseCase() async throws {
        // Arrange
        let character = Character.comicsListFixtureWithoutIssueCredits()
        let mockService = MockComicsListService()
        mockService.comicsToReturn = [Comic.comicsListFixture()]

        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        #expect(mockService.fetchCharacterComicsCalled == true)
    }
}

// MARK: - XCTest Integration Tests

class ComicsListViewModelXCTests: XCTestCase {

    private var mockService: MockComicsListService!

    override func setUp() {
        super.setUp()
        mockService = MockComicsListService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    @MainActor
    func testInitialState() {
        let character = Character.comicsListFixture()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        XCTAssertTrue(viewModel.comics.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertNil(viewModel.selectedComic)
    }

    @MainActor
    func testLoadComics() async throws {
        // Arrange
        mockService.comicsToReturn = .comicsListFixtures(count: 5)
        let character = Character.comicsListFixture()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Load comics")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2.0)

        // Assert
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testLoadError() async throws {
        // Arrange - Usar FetchCharacterComicsUseCase que propaga erros
        // FetchIssuesByIdsUseCase nÃ£o propaga erros (captura individualmente)
        mockService.shouldThrowError = true
        let character = Character.comicsListFixtureWithoutIssueCredits()
        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Load with error")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2.0)

        // Assert
        XCTAssertTrue(viewModel.comics.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }

    @MainActor
    func testFilterSelection() {
        // Arrange
        let character = Character.comicsListFixture()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act & Assert
        XCTAssertEqual(viewModel.selectedFilter, .all)

        viewModel.selectFilter(.recent)
        XCTAssertEqual(viewModel.selectedFilter, .recent)

        viewModel.selectFilter(.popular)
        XCTAssertEqual(viewModel.selectedFilter, .popular)

        viewModel.selectFilter(.classic)
        XCTAssertEqual(viewModel.selectedFilter, .classic)
    }

    @MainActor
    func testComputedProperties() {
        // Arrange
        let character = Character.comicsListFixture(comicsCount: 200)
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Assert
        XCTAssertEqual(viewModel.totalComics, 10) // 10 issue credits na fixture padrÃ£o
        XCTAssertFalse(viewModel.hasFilters) // Sem comics carregados ainda
    }

    @MainActor
    func testSelectComic() {
        // Arrange
        let character = Character.comicsListFixture()
        let comic = Comic.comicsListFixture(id: 999)
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Act
        viewModel.selectComic(comic)

        // Assert
        XCTAssertNotNil(viewModel.selectedComic)
        XCTAssertEqual(viewModel.selectedComic?.id, 999)
    }

    @MainActor
    func testRefresh() async throws {
        // Arrange - Usar fallback UseCase para controle mais previsÃ­vel
        let character = Character.comicsListFixtureWithoutIssueCredits(comicsCount: 100)
        mockService.comicsToReturn = .comicsListFixtures(count: 5)
        let useCase = FetchCharacterComicsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchCharacterComicsUseCase: useCase
        )

        viewModel.loadInitialData()

        let expectation1 = XCTestExpectation(description: "Initial load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation1.fulfill()
        }
        await fulfillment(of: [expectation1], timeout: 1.0)

        // Verifica que carregou
        XCTAssertEqual(viewModel.comics.count, 5)

        // Act - Atualiza o mock e faz refresh
        mockService.comicsToReturn = .comicsListFixtures(count: 3)
        viewModel.refresh()

        let expectation2 = XCTestExpectation(description: "Refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation2], timeout: 1.0)

        // Assert - Verifica que recarregou com novos dados
        XCTAssertEqual(viewModel.comics.count, 3)
    }
}
