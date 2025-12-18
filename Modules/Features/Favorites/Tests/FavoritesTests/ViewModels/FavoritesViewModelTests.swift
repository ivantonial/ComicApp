//
//  FavoritesViewModelTests.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import Favorites
@testable import ComicVineAPI
import Cache
import Combine
import Foundation
import Networking
import Testing
import XCTest

// MARK: - FavoritesViewModel Initialization Tests

@Suite("FavoritesViewModel Initialization Tests")
struct FavoritesViewModelInitializationTests {

    @Test("Should have correct initial state")
    @MainActor
    func testInitialState() async {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)

        // Act
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.favoriteCharacters.isEmpty)
        #expect(viewModel.isLoading == true) // Começa carregando
        #expect(viewModel.error == nil)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.sortOption == .dateAdded)
        #expect(viewModel.selectedCharacters.isEmpty)
        #expect(viewModel.isSelectionMode == false)
    }

    @Test("Should be MainActor isolated")
    @MainActor
    func testMainActorIsolation() {
        // Se compila e executa com @MainActor, está correto
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let _ = FavoritesViewModel(favoritesService: service)
        #expect(true)
    }

    @Test("Should be ObservableObject")
    @MainActor
    func testObservableObject() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        _ = viewModel.objectWillChange
        #expect(true)
    }
}

// MARK: - FavoritesViewModel Computed Properties Tests

@Suite("FavoritesViewModel Computed Properties Tests")
struct FavoritesViewModelComputedPropertiesTests {

    @Test("hasFavorites should return false when empty")
    @MainActor
    func testHasFavoritesEmpty() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.hasFavorites == false)
    }

    @Test("selectedCount should return correct count")
    @MainActor
    func testSelectedCount() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Act
        viewModel.selectedCharacters = Set([1, 2, 3])

        // Assert
        #expect(viewModel.selectedCount == 3)
    }

    @Test("selectedCount should return zero when empty")
    @MainActor
    func testSelectedCountEmpty() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.selectedCount == 0)
    }

    @Test("isAllSelected should return false when no characters")
    @MainActor
    func testIsAllSelectedNoCharacters() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.isAllSelected == false)
    }

    @Test("filteredCharacters should return empty when no favorites")
    @MainActor
    func testFilteredCharactersEmpty() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.filteredCharacters.isEmpty)
    }
}

// MARK: - FavoritesViewModel Selection Mode Tests

@Suite("FavoritesViewModel Selection Mode Tests")
struct FavoritesViewModelSelectionModeTests {

    @Test("toggleSelectionMode should toggle selection mode")
    @MainActor
    func testToggleSelectionMode() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert initial state
        #expect(viewModel.isSelectionMode == false)

        // Act
        viewModel.toggleSelectionMode()

        // Assert after toggle
        #expect(viewModel.isSelectionMode == true)

        // Act again
        viewModel.toggleSelectionMode()

        // Assert after second toggle
        #expect(viewModel.isSelectionMode == false)
    }

    @Test("toggleSelectionMode should clear selections when turning off")
    @MainActor
    func testToggleSelectionModeClearsSelections() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Setup selection mode with selections
        viewModel.isSelectionMode = true
        viewModel.selectedCharacters = Set([1, 2, 3])

        // Act - Turn off selection mode
        viewModel.toggleSelectionMode()

        // Assert
        #expect(viewModel.isSelectionMode == false)
        #expect(viewModel.selectedCharacters.isEmpty)
    }

    @Test("deselectAll should clear all selections")
    @MainActor
    func testDeselectAll() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        viewModel.selectedCharacters = Set([1, 2, 3, 4, 5])

        // Act
        viewModel.deselectAll()

        // Assert
        #expect(viewModel.selectedCharacters.isEmpty)
        #expect(viewModel.selectedCount == 0)
    }
}

// MARK: - FavoritesViewModel Toggle Selection Tests

@Suite("FavoritesViewModel Toggle Selection Tests")
struct FavoritesViewModelToggleSelectionTests {

    @Test("toggleSelection should add character to selection")
    @MainActor
    func testToggleSelectionAdd() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)
        let character = Character.favoritesFixture(id: 1)

        // Act
        viewModel.toggleSelection(for: character)

        // Assert
        #expect(viewModel.selectedCharacters.contains(1))
        #expect(viewModel.selectedCount == 1)
    }

    @Test("toggleSelection should remove character from selection")
    @MainActor
    func testToggleSelectionRemove() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)
        let character = Character.favoritesFixture(id: 1)

        viewModel.selectedCharacters.insert(1)

        // Act
        viewModel.toggleSelection(for: character)

        // Assert
        #expect(!viewModel.selectedCharacters.contains(1))
        #expect(viewModel.selectedCount == 0)
    }

    @Test("toggleSelection should toggle correctly")
    @MainActor
    func testToggleSelectionToggle() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)
        let character = Character.favoritesFixture(id: 42)

        // Initial - not selected
        #expect(!viewModel.selectedCharacters.contains(42))

        // Act - Add
        viewModel.toggleSelection(for: character)
        #expect(viewModel.selectedCharacters.contains(42))

        // Act - Remove
        viewModel.toggleSelection(for: character)
        #expect(!viewModel.selectedCharacters.contains(42))
    }
}

// MARK: - FavoritesViewModel Sort Option Tests

@Suite("FavoritesViewModel Sort Option Tests")
struct FavoritesViewModelSortOptionTests {

    @Test("updateSortOption should change sort option")
    @MainActor
    func testUpdateSortOption() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert initial
        #expect(viewModel.sortOption == .dateAdded)

        // Act - Change to name
        viewModel.updateSortOption(.name)
        #expect(viewModel.sortOption == .name)

        // Act - Change to mostComics
        viewModel.updateSortOption(.mostComics)
        #expect(viewModel.sortOption == .mostComics)

        // Act - Change back to dateAdded
        viewModel.updateSortOption(.dateAdded)
        #expect(viewModel.sortOption == .dateAdded)
    }

    @Test("updateSortOption should handle all options")
    @MainActor
    func testUpdateSortOptionAllOptions() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Act & Assert for each option
        for option in FavoritesSortOption.allCases {
            viewModel.updateSortOption(option)
            #expect(viewModel.sortOption == option)
        }
    }
}

// MARK: - FavoritesViewModel Export Tests

@Suite("FavoritesViewModel Export Tests")
struct FavoritesViewModelExportTests {

    @Test("exportFavorites should return formatted string")
    @MainActor
    func testExportFavoritesFormat() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Act
        let exported = viewModel.exportFavorites()

        // Assert
        #expect(exported.contains("My Comics Favorites:"))
    }

    @Test("exportFavorites should be empty when no favorites")
    @MainActor
    func testExportFavoritesEmpty() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Act
        let exported = viewModel.exportFavorites()

        // Assert
        #expect(exported.contains("My Comics Favorites:"))
        #expect(exported.contains("\n\n"))
    }
}

// MARK: - FavoritesViewModel Search Tests

@Suite("FavoritesViewModel Search Tests")
struct FavoritesViewModelSearchTests {

    @Test("searchText should be empty initially")
    @MainActor
    func testSearchTextInitiallyEmpty() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Assert
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("searchText can be set")
    @MainActor
    func testSearchTextCanBeSet() {
        // Arrange
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Act
        viewModel.searchText = "Spider"

        // Assert
        #expect(viewModel.searchText == "Spider")
    }
}

// MARK: - XCTest Integration Tests

class FavoritesViewModelXCTests: XCTestCase {

    private var mockPersistence: MockFavoritesPersistenceManager!

    override func setUp() {
        super.setUp()
        mockPersistence = MockFavoritesPersistenceManager()
    }

    override func tearDown() {
        mockPersistence = nil
        super.tearDown()
    }

    @MainActor
    private func createService() -> FavoritesService {
        return FavoritesService(persistenceManager: mockPersistence)
    }

    @MainActor
    private func createViewModel() -> FavoritesViewModel {
        let service = createService()
        return FavoritesViewModel(favoritesService: service)
    }

    @MainActor
    func testInitialState() {
        let viewModel = createViewModel()

        XCTAssertTrue(viewModel.favoriteCharacters.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.sortOption, .dateAdded)
        XCTAssertTrue(viewModel.selectedCharacters.isEmpty)
        XCTAssertFalse(viewModel.isSelectionMode)
    }

    @MainActor
    func testComputedPropertiesInitial() {
        let viewModel = createViewModel()

        XCTAssertTrue(viewModel.filteredCharacters.isEmpty)
        XCTAssertFalse(viewModel.hasFavorites)
        XCTAssertEqual(viewModel.selectedCount, 0)
        XCTAssertFalse(viewModel.isAllSelected)
    }

    @MainActor
    func testToggleSelectionMode() {
        let viewModel = createViewModel()

        XCTAssertFalse(viewModel.isSelectionMode)

        viewModel.toggleSelectionMode()
        XCTAssertTrue(viewModel.isSelectionMode)

        viewModel.toggleSelectionMode()
        XCTAssertFalse(viewModel.isSelectionMode)
    }

    @MainActor
    func testToggleSelectionModeClearsSelections() {
        let viewModel = createViewModel()

        viewModel.isSelectionMode = true
        viewModel.selectedCharacters = Set([1, 2, 3])

        viewModel.toggleSelectionMode()

        XCTAssertFalse(viewModel.isSelectionMode)
        XCTAssertTrue(viewModel.selectedCharacters.isEmpty)
    }

    @MainActor
    func testToggleSelection() {
        let viewModel = createViewModel()
        let character = Character.favoritesFixture(id: 42)

        // Add
        viewModel.toggleSelection(for: character)
        XCTAssertTrue(viewModel.selectedCharacters.contains(42))

        // Remove
        viewModel.toggleSelection(for: character)
        XCTAssertFalse(viewModel.selectedCharacters.contains(42))
    }

    @MainActor
    func testDeselectAll() {
        let viewModel = createViewModel()
        viewModel.selectedCharacters = Set([1, 2, 3, 4, 5])

        viewModel.deselectAll()

        XCTAssertTrue(viewModel.selectedCharacters.isEmpty)
        XCTAssertEqual(viewModel.selectedCount, 0)
    }

    @MainActor
    func testUpdateSortOption() {
        let viewModel = createViewModel()

        XCTAssertEqual(viewModel.sortOption, .dateAdded)

        viewModel.updateSortOption(.name)
        XCTAssertEqual(viewModel.sortOption, .name)

        viewModel.updateSortOption(.mostComics)
        XCTAssertEqual(viewModel.sortOption, .mostComics)
    }

    @MainActor
    func testExportFavoritesEmpty() {
        let viewModel = createViewModel()
        let exported = viewModel.exportFavorites()

        XCTAssertTrue(exported.contains("My Comics Favorites:"))
    }

    @MainActor
    func testLoadFavorites() async throws {
        // Arrange - Configure mock with favorites
        let characters: [Character] = [
            .favoritesFixture(id: 1, name: "Spider-Man"),
            .favoritesFixture(id: 2, name: "Batman")
        ]

        await mockPersistence.setCharacters(characters)
        await mockPersistence.setFavorites(Set([1, 2]))

        // Recreate service and viewModel to pick up the new data
        let newService = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = await FavoritesViewModel(favoritesService: newService)

        // Wait for loading to complete
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
        }
    }

    @MainActor
    func testSearchTextBinding() {
        let viewModel = createViewModel()

        XCTAssertTrue(viewModel.searchText.isEmpty)

        viewModel.searchText = "Batman"
        XCTAssertEqual(viewModel.searchText, "Batman")

        viewModel.searchText = ""
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }

    @MainActor
    func testSelectedCountProperty() {
        let viewModel = createViewModel()

        XCTAssertEqual(viewModel.selectedCount, 0)

        viewModel.selectedCharacters = Set([1])
        XCTAssertEqual(viewModel.selectedCount, 1)

        viewModel.selectedCharacters = Set([1, 2, 3, 4, 5])
        XCTAssertEqual(viewModel.selectedCount, 5)
    }

    @MainActor
    func testSortOptionAllCases() {
        let viewModel = createViewModel()

        for option in FavoritesSortOption.allCases {
            viewModel.updateSortOption(option)
            XCTAssertEqual(viewModel.sortOption, option)
        }
    }
}
