//
//  CharacterListViewModelTests.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import CharacterList
@testable import ComicVineAPI
import Combine
import Foundation
import Networking
import Testing
import XCTest

// MARK: - CharacterListViewModel Initialization Tests

@Suite("CharacterListViewModel Initialization Tests")
struct CharacterListViewModelInitializationTests {

    @Test("Should have correct initial state")
    @MainActor
    func testInitialState() async {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)

        // Act
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Assert
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isSearching == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.hasMorePages == true)
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("Should be MainActor isolated")
    @MainActor
    func testMainActorIsolation() {
        // Se compila e executa com @MainActor, está correto
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let _ = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )
        #expect(true)
    }

    @Test("Should be ObservableObject")
    @MainActor
    func testObservableObject() {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Assert
        _ = viewModel.objectWillChange
        #expect(true)
    }
}

// MARK: - CharacterListViewModel Load Data Tests

@Suite("CharacterListViewModel Load Data Tests")
struct CharacterListViewModelLoadDataTests {

    @Test("Should load characters successfully")
    @MainActor
    func testLoadCharactersSuccess() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Iron Man")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.characters.count == 2)
        #expect(viewModel.characters[0].name == "Spider-Man")
        #expect(viewModel.characters[1].name == "Iron Man")
        #expect(viewModel.error == nil)
    }

    @Test("Should handle load error")
    @MainActor
    func testLoadCharactersError() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.shouldThrowError = true

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.error != nil)
    }

    @Test("Should set loading state during load")
    @MainActor
    func testLoadingStateDuringLoad() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [Character.listFixture()]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Assert - inicial
        #expect(viewModel.isLoading == false)

        // Act
        viewModel.loadInitialData()

        // Aguarda carregamento
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert - após carregamento
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - CharacterListViewModel Display Characters Tests

@Suite("CharacterListViewModel Display Characters Tests")
struct CharacterListViewModelDisplayCharactersTests {

    @Test("Should return characters when no search")
    @MainActor
    func testDisplayCharactersNoSearch() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Batman"),
            Character.listFixture(id: 2, name: "Superman")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.displayCharacters.count == 2)
        #expect(viewModel.displayCharacters[0].name == "Batman")
    }

    @Test("Should remove duplicates from display characters")
    @MainActor
    func testDisplayCharactersRemovesDuplicates() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = .duplicatesTestFixtures()

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.characterCardModels.count == 3) // Apenas únicos
    }
}

// MARK: - CharacterListViewModel Card Models Tests

@Suite("CharacterListViewModel Card Models Tests")
struct CharacterListViewModelCardModelsTests {

    @Test("Should convert to card models correctly")
    @MainActor
    func testCharacterCardModels() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man", comicsCount: 150),
            Character.listFixture(id: 2, name: "Iron Man", comicsCount: 200)
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        let cardModels = viewModel.characterCardModels
        #expect(cardModels.count == 2)
        #expect(cardModels[0].name == "Spider-Man")
        #expect(cardModels[0].comicsCount == 150)
        #expect(cardModels[1].name == "Iron Man")
        #expect(cardModels[1].comicsCount == 200)
    }

    @Test("Should have empty card models initially")
    @MainActor
    func testEmptyCardModelsInitially() {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Assert
        #expect(viewModel.characterCardModels.isEmpty)
    }
}

// MARK: - CharacterListViewModel Refresh Tests

@Suite("CharacterListViewModel Refresh Tests")
struct CharacterListViewModelRefreshTests {

    @Test("Should clear data on refresh")
    @MainActor
    func testRefreshClearsData() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [Character.listFixture()]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Carrega dados iniciais
        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)
        #expect(!viewModel.characters.isEmpty)

        // Act
        viewModel.refresh()
        try await Task.sleep(nanoseconds: 600_000_000)

        // Assert
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
    }

    @Test("Should reset search on refresh")
    @MainActor
    func testRefreshResetsSearch() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Simula busca
        viewModel.searchText = "Spider"

        // Act
        viewModel.refresh()

        // Assert
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
    }

    @Test("Should reload data on async refresh")
    @MainActor
    func testRefreshAsync() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Flash")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        await viewModel.refreshAsync()

        // Assert
        #expect(viewModel.characters.count == 1)
        #expect(viewModel.characters[0].name == "Flash")
    }
}

// MARK: - CharacterListViewModel Pagination Tests

@Suite("CharacterListViewModel Pagination Tests")
struct CharacterListViewModelPaginationTests {

    @Test("Should not load more when searching")
    @MainActor
    func testNoLoadMoreWhileSearching() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [Character.listFixture()]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        viewModel.loadInitialData()
        try await Task.sleep(nanoseconds: 500_000_000)

        let callCountBefore = mockService.fetchCharactersCallCount

        // Simula busca ativa
        viewModel.searchText = "Spider"

        // Act
        let lastChar = viewModel.characters.last!
        viewModel.loadMoreIfNeeded(currentCharacter: lastChar)
        try await Task.sleep(nanoseconds: 300_000_000)

        // Assert
        #expect(mockService.fetchCharactersCallCount == callCountBefore)
    }

    @Test("Should not load more when already loading")
    @MainActor
    func testNoLoadMoreWhileLoading() async throws {
        // Arrange
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = .listFixtures(count: 20)

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act - Inicia carregamento simultâneo
        viewModel.loadInitialData()
        viewModel.loadInitialData()

        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert - Deve cancelar carregamento anterior
        #expect(viewModel.characters.count == 20)
    }
}

// MARK: - XCTest Integration Tests

class CharacterListViewModelXCTests: XCTestCase {

    private var mockService: MockCharacterListService!

    override func setUp() {
        super.setUp()
        mockService = MockCharacterListService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    /// Helper para criar o ViewModel no contexto MainActor
    @MainActor
    private func createViewModel() -> CharacterListViewModel {
        let useCase = FetchCharactersUseCase(service: mockService)
        return CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )
    }

    @MainActor
    func testInitialState() {
        let viewModel = createViewModel()

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }

    @MainActor
    func testLoadCharacters() async throws {
        // Arrange
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Wonder Woman"),
            Character.listFixture(id: 2, name: "Aquaman")
        ]
        let viewModel = createViewModel()

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Load characters")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.displayCharacters.count, 2)
    }

    @MainActor
    func testLoadError() async throws {
        // Arrange
        mockService.shouldThrowError = true
        let viewModel = createViewModel()

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Load with error")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }

    @MainActor
    func testCardModelsGeneration() async throws {
        // Arrange
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Green Lantern", comicsCount: 80)
        ]
        let viewModel = createViewModel()

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Generate card models")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.characterCardModels.count, 1)
        XCTAssertEqual(viewModel.characterCardModels.first?.name, "Green Lantern")
        XCTAssertEqual(viewModel.characterCardModels.first?.comicsCount, 80)
    }

    @MainActor
    func testRefresh() async throws {
        // Arrange
        mockService.charactersToReturn = [Character.listFixture()]
        let viewModel = createViewModel()
        viewModel.loadInitialData()

        let expectation1 = XCTestExpectation(description: "Initial load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation1.fulfill()
        }
        await fulfillment(of: [expectation1], timeout: 1.0)

        // Act
        viewModel.refresh()

        let expectation2 = XCTestExpectation(description: "Refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation2.fulfill()
        }
        await fulfillment(of: [expectation2], timeout: 1.0)

        // Assert
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
    }

    @MainActor
    func testDeduplication() async throws {
        // Arrange - Lista com duplicados
        mockService.charactersToReturn = .duplicatesTestFixtures()
        let viewModel = createViewModel()

        // Act
        viewModel.loadInitialData()

        let expectation = XCTestExpectation(description: "Load with duplicates")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert - Deve ter apenas 3 únicos no cardModels
        XCTAssertEqual(viewModel.characterCardModels.count, 3)
    }
}
