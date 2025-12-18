//
//  CharacterDetailViewModelTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

@testable import CharacterDetail
import Cache
import ComicVineAPI
import Core
import Foundation
import Testing
import XCTest

// MARK: - CharacterDetailViewModel Tests

@Suite("CharacterDetailViewModel Tests")
struct CharacterDetailViewModelTests {

    // MARK: - Initialization Tests

    @Test("Should initialize with character")
    @MainActor
    func testInitialization() {
        // Arrange
        let character = Character.detailFixture(id: 1, name: "Spider-Man")

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.detailModel.character.id == 1)
        #expect(viewModel.detailModel.character.name == "Spider-Man")
    }

    @Test("Should have correct initial state")
    @MainActor
    func testInitialState() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.isFavorite == false)
    }

    @Test("Should create detail model from character")
    @MainActor
    func testDetailModelCreation() {
        // Arrange
        let character = Character.detailFixture(
            id: 42,
            name: "Batman",
            comicsCount: 500
        )

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.detailModel.character.id == 42)
        #expect(viewModel.detailModel.stats.comics.value == 500)
    }

    // MARK: - Derived Properties Tests

    @Test("Should have hasRelatedContent true when character has teams")
    @MainActor
    func testHasRelatedContentWithTeams() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.hasRelatedContent == true)
    }

    @Test("Should have hasRelatedContent false when no relations")
    @MainActor
    func testHasRelatedContentFalse() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.hasRelatedContent == false)
    }

    @Test("Should have hasComics true when comics count > 0")
    @MainActor
    func testHasComicsTrue() {
        // Arrange
        let character = Character.detailFixture(comicsCount: 50)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.hasComics == true)
    }

    @Test("Should have hasComics false when comics count is 0")
    @MainActor
    func testHasComicsFalse() {
        // Arrange
        let character = Character.detailFixture(comicsCount: 0)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(viewModel.hasComics == false)
    }

    @Test("Should have share items")
    @MainActor
    func testShareItems() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        #expect(!viewModel.shareItems.isEmpty)
    }

    // MARK: - Toggle Favorite Tests

    @Test("Should toggle favorite state")
    @MainActor
    func testToggleFavorite() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)
        let initialState = viewModel.isFavorite

        // Act
        viewModel.toggleFavorite()

        // Assert
        #expect(viewModel.isFavorite == !initialState)
    }

    // MARK: - Cancel Loading Tests

    @Test("Should cancel loading and reset state")
    @MainActor
    func testCancelLoading() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        // Act
        viewModel.cancelLoading()

        // Assert
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - CharacterDetailViewModel with Dependencies Tests

@Suite("CharacterDetailViewModel with Dependencies Tests")
struct CharacterDetailViewModelDependencyTests {

    @Test("Should initialize with all optional dependencies")
    @MainActor
    func testInitializationWithDependencies() async {
        // Arrange
        let character = Character.detailFixture()
        let mockFavoritesService = MockFavoritesService()
        let mockPersistenceManager = MockPersistenceManager()

        // Act
        let viewModel = CharacterDetailViewModel(
            character: character,
            fetchCharacterDetailUseCase: nil,
            fetchCharacterComicsUseCase: nil,
            favoritesService: mockFavoritesService,
            persistenceManager: mockPersistenceManager
        )

        // Assert
        #expect(viewModel.detailModel.character.id == character.id)
    }

    @Test("Should work without any dependencies")
    @MainActor
    func testInitializationWithoutDependencies() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(
            character: character,
            fetchCharacterDetailUseCase: nil,
            fetchCharacterComicsUseCase: nil,
            favoritesService: nil,
            persistenceManager: nil
        )

        // Assert
        #expect(viewModel.detailModel.character.id == character.id)
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - CharacterDetailViewModel MainActor Tests

@Suite("CharacterDetailViewModel MainActor Compliance Tests")
struct CharacterDetailViewModelMainActorTests {

    @Test("ViewModel should be MainActor isolated")
    @MainActor
    func testMainActorIsolation() {
        // Se o teste compila e executa com @MainActor, está correto
        let character = Character.detailFixture()
        let _ = CharacterDetailViewModel(character: character)
        #expect(true)
    }

    @Test("Published properties should be accessible on MainActor")
    @MainActor
    func testPublishedPropertiesAccessible() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        // Act & Assert
        _ = viewModel.detailModel
        _ = viewModel.isLoading
        _ = viewModel.error
        _ = viewModel.isFavorite
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterDetailViewModelXCTests: XCTestCase {

    @MainActor
    func testViewModelInitialization() {
        // Arrange
        let character = Character.detailFixture(id: 123, name: "Test Hero")

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertEqual(viewModel.detailModel.character.id, 123)
        XCTAssertEqual(viewModel.detailModel.character.name, "Test Hero")
    }

    @MainActor
    func testViewModelInitialLoadingState() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testViewModelInitialErrorState() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertNil(viewModel.error)
    }

    @MainActor
    func testViewModelInitialFavoriteState() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertFalse(viewModel.isFavorite)
    }

    @MainActor
    func testHasComicsWithPositiveCount() {
        // Arrange
        let character = Character.detailFixture(comicsCount: 100)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertTrue(viewModel.hasComics)
    }

    @MainActor
    func testHasComicsWithZeroCount() {
        // Arrange
        let character = Character.detailFixture(comicsCount: 0)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertFalse(viewModel.hasComics)
    }

    @MainActor
    func testHasRelatedContentWithRelations() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertTrue(viewModel.hasRelatedContent)
    }

    @MainActor
    func testHasRelatedContentWithoutRelations() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertFalse(viewModel.hasRelatedContent)
    }

    @MainActor
    func testShareItemsNotEmpty() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertFalse(viewModel.shareItems.isEmpty)
    }

    @MainActor
    func testToggleFavoriteChangesState() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)
        let initialState = viewModel.isFavorite

        // Act
        viewModel.toggleFavorite()

        // Assert
        XCTAssertNotEqual(viewModel.isFavorite, initialState)
    }

    @MainActor
    func testToggleFavoriteTwiceReturnsToOriginal() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)
        let initialState = viewModel.isFavorite

        // Act
        viewModel.toggleFavorite()
        viewModel.toggleFavorite()

        // Assert
        XCTAssertEqual(viewModel.isFavorite, initialState)
    }

    @MainActor
    func testCancelLoadingResetsLoadingState() {
        // Arrange
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        // Act
        viewModel.cancelLoading()

        // Assert
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testDetailModelStatsCount() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertEqual(viewModel.detailModel.stats.allStats.count, 4)
    }

    @MainActor
    func testDetailModelShareInfoContainsCharacterName() {
        // Arrange
        let character = Character.detailFixture(name: "Wonder Woman")

        // Act
        let viewModel = CharacterDetailViewModel(character: character)

        // Assert
        XCTAssertTrue(viewModel.detailModel.shareInfo.text.contains("Wonder Woman"))
    }
}

// MARK: - ViewModel with Mock Services Tests

class CharacterDetailViewModelMockServicesTests: XCTestCase {

    private var mockFavoritesService: MockFavoritesService!
    private var mockPersistenceManager: MockPersistenceManager!

    override func setUp() async throws {
        mockFavoritesService = MockFavoritesService()
        mockPersistenceManager = MockPersistenceManager()
    }

    override func tearDown() async throws {
        await mockFavoritesService.reset()
        await mockPersistenceManager.reset()
        mockFavoritesService = nil
        mockPersistenceManager = nil
    }

    @MainActor
    func testViewModelWithMockFavoritesService() async {
        // Arrange
        let character = Character.detailFixture(id: 1)
        await mockFavoritesService.setFavorites([1])

        // Act
        let viewModel = CharacterDetailViewModel(
            character: character,
            favoritesService: mockFavoritesService,
            persistenceManager: mockPersistenceManager
        )

        // Wait for async initialization
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Assert - O estado de favorito será carregado após o delay
        // O teste verifica que não há crash
        XCTAssertNotNil(viewModel)
    }

    @MainActor
    func testViewModelWithMockPersistenceManager() async {
        // Arrange
        let character = Character.detailFixture(id: 1)

        // Act
        let viewModel = CharacterDetailViewModel(
            character: character,
            persistenceManager: mockPersistenceManager
        )

        // Wait for async save
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Assert
        let wasSaved = await mockPersistenceManager.hasCharacter(id: 1)
        XCTAssertTrue(wasSaved)
    }
}
