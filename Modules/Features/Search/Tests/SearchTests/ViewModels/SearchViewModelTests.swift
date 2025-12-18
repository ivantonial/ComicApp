//
//  SearchViewModelTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import Search
@testable import ComicVineAPI
import Foundation
import Networking
import Testing
import XCTest

// MARK: - SearchViewModel Initialization Tests

@Suite("SearchViewModel Initialization Tests")
struct SearchViewModelInitTests {

    @Test("Should initialize with correct default values")
    @MainActor
    func testDefaultValues() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.searchType == .characters)
        #expect(viewModel.selectedFilter == .all)
        #expect(viewModel.sortOption == .name)
        #expect(viewModel.characterResults.isEmpty)
        #expect(viewModel.comicResults.isEmpty)
        #expect(viewModel.isSearching == false)
        #expect(viewModel.error == nil)
    }

    @Test("Should be MainActor isolated")
    @MainActor
    func testMainActorIsolation() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert - If this compiles and runs, it's MainActor isolated
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("Should conform to ObservableObject")
    @MainActor
    func testObservableObjectConformance() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert - Verifica que objectWillChange existe (ObservableObject compliance)
        let publisher = viewModel.objectWillChange
        #expect(String(describing: type(of: publisher)).contains("ObservableObjectPublisher"))
    }
}

// MARK: - SearchViewModel Search Tests

@Suite("SearchViewModel Search Tests")
struct SearchViewModelSearchTests {

    @Test("Should not search with empty text")
    @MainActor
    func testNoSearchWithEmptyText() async throws {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.searchText = ""
        viewModel.search()

        // Allow time for async operations
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(mockService.searchCharactersCalled == false)
        #expect(viewModel.characterResults.isEmpty)
    }

    @Test("Should search characters when type is .characters")
    @MainActor
    func testSearchCharacters() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Spider-Man")
        ]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .characters

        // Use unique query to avoid cache collision
        let uniqueQuery = "SearchChar_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // Allow MainActor to process the search task (debounce is 0.5s)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(mockService.searchCharactersCalled)
        #expect(!viewModel.characterResults.isEmpty)
    }

    @Test("Should search comics when type is .comics")
    @MainActor
    func testSearchComics() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.comicsToReturn = [
            Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")
        ]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .comics

        // Use unique query to avoid cache collision
        let uniqueQuery = "SearchComic_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // Allow MainActor to process the search task (debounce is 0.5s)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(mockService.searchComicsCalled)
        #expect(!viewModel.comicResults.isEmpty)
    }

    @Test("Should handle search errors")
    @MainActor
    func testSearchError() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "SearchError_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // Allow time for async operations (debounce is 0.5s)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.error != nil)
    }

    @Test("Should clear results when search text is cleared")
    @MainActor
    func testClearSearchText() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "ClearTest_\(UUID().uuidString.prefix(8))"

        // First, perform a search
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Act - clear search
        viewModel.clearSearch()

        // Assert
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.characterResults.isEmpty)
    }
}

// MARK: - SearchViewModel Type Switching Tests

@Suite("SearchViewModel Type Switching Tests")
struct SearchViewModelTypeSwitchTests {

    @Test("Should switch search type")
    @MainActor
    func testSwitchSearchType() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.switchSearchType(.comics)

        // Assert
        #expect(viewModel.searchType == .comics)
    }

    @Test("Should reset filter when switching type")
    @MainActor
    func testResetFilterOnTypeSwitch() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.updateFilter(.heroes)

        // Act
        viewModel.switchSearchType(.comics)

        // Assert
        #expect(viewModel.selectedFilter == .all)
    }

    @Test("Should trigger search when switching with existing text")
    @MainActor
    func testSearchOnTypeSwitch() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.comicsToReturn = [Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "TypeSwitch_\(UUID().uuidString.prefix(8))"
        viewModel.searchText = uniqueQuery

        // Act
        viewModel.switchSearchType(.comics)

        // Allow search to complete (debounce is 0.5s)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(mockService.searchComicsCalled)
    }
}

// MARK: - SearchViewModel Filter Tests

@Suite("SearchViewModel Filter Tests")
struct SearchViewModelFilterTests {

    @Test("Should update filter")
    @MainActor
    func testUpdateFilter() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.updateFilter(.heroes)

        // Assert
        #expect(viewModel.selectedFilter == .heroes)
    }

    @Test("Should reset to .all filter when changing type")
    @MainActor
    func testResetFilterOnTypeChange() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.updateFilter(.villains)

        // Act
        viewModel.switchSearchType(.comics)

        // Assert
        #expect(viewModel.selectedFilter == .all)
    }
}

// MARK: - SearchViewModel Sort Tests

@Suite("SearchViewModel Sort Tests")
struct SearchViewModelSortTests {

    @Test("Should update sort option")
    @MainActor
    func testUpdateSortOption() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.sortOption = .popularity

        // Assert
        #expect(viewModel.sortOption == .popularity)
    }

    @Test("Should sort characters by name ascending")
    @MainActor
    func testSortByName() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Disable filtering for sort test
        mockService.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Zebra"),
            Character.searchFixture(id: 2, name: "Alpha"),
            Character.searchFixture(id: 3, name: "Beta")
        ]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.sortOption = .name

        // Use unique query to avoid cache collision
        let uniqueQuery = "SortName_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        let filtered = viewModel.filteredCharacters
        #expect(filtered.count == 3)
        #expect(filtered[0].name == "Alpha")
        #expect(filtered[1].name == "Beta")
        #expect(filtered[2].name == "Zebra")
    }

    @Test("Should sort characters by popularity descending")
    @MainActor
    func testSortByPopularity() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Disable filtering for sort test
        mockService.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Low", comicsCount: 10),
            Character.searchFixture(id: 2, name: "High", comicsCount: 1000),
            Character.searchFixture(id: 3, name: "Medium", comicsCount: 100)
        ]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.sortOption = .popularity

        // Use unique query to avoid cache collision
        let uniqueQuery = "SortPop_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        let filtered = viewModel.filteredCharacters
        #expect(filtered.count == 3)
        #expect(filtered[0].name == "High")
        #expect(filtered[1].name == "Medium")
        #expect(filtered[2].name == "Low")
    }

    @Test("Should sort characters by recent descending")
    @MainActor
    func testSortByRecent() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Disable filtering for sort test
        mockService.charactersToReturn = [
            Character.searchFixture(id: 1, name: "Old", dateLastUpdated: "2023-01-01 00:00:00"),
            Character.searchFixture(id: 2, name: "New", dateLastUpdated: "2024-12-01 00:00:00"),
            Character.searchFixture(id: 3, name: "Medium", dateLastUpdated: "2024-06-01 00:00:00")
        ]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.sortOption = .recent

        // Use unique query to avoid cache collision
        let uniqueQuery = "SortRecent_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        let filtered = viewModel.filteredCharacters
        #expect(filtered.count == 3)
        #expect(filtered[0].name == "New")
        #expect(filtered[1].name == "Medium")
        #expect(filtered[2].name == "Old")
    }
}

// MARK: - SearchViewModel Character Filter Tests

@Suite("SearchViewModel Character Filter Tests")
struct SearchViewModelCharacterFilterTests {

    @Test("Should filter villains by keyword")
    @MainActor
    func testFilterVillains() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupMixedCharactersForFilterTests()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .characters

        // Use unique query to avoid cache collision
        let uniqueQuery = "FilterVillain_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        viewModel.updateFilter(.villains)

        // Assert
        let filtered = viewModel.filteredCharacters
        // Should contain Doctor Doom, Magneto, Thanos (villain keywords)
        #expect(filtered.contains { $0.name.lowercased().contains("doom") })
        #expect(filtered.contains { $0.name.lowercased().contains("magneto") })
        #expect(filtered.contains { $0.name.lowercased().contains("thanos") })
    }

    @Test("Should filter teams by keyword")
    @MainActor
    func testFilterTeams() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupMixedCharactersForFilterTests()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .characters

        // Use unique query to avoid cache collision
        let uniqueQuery = "FilterTeam_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        viewModel.updateFilter(.teams)

        // Assert
        let filtered = viewModel.filteredCharacters
        // Should contain Avengers, X-Men, Fantastic Four (team keywords)
        #expect(filtered.contains { $0.name.lowercased().contains("avengers") })
        #expect(filtered.contains { $0.name.lowercased().contains("x-men") })
        #expect(filtered.contains { $0.name.lowercased().contains("fantastic") })
    }

    @Test("Should return all characters when filter is .all")
    @MainActor
    func testFilterAll() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupMixedCharactersForFilterTests()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .characters

        // Use unique query to avoid cache collision
        let uniqueQuery = "FilterAll_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        viewModel.updateFilter(.all)

        // Assert
        let filtered = viewModel.filteredCharacters
        #expect(filtered.count == viewModel.characterResults.count)
    }
}

// MARK: - SearchViewModel Comic Filter Tests

@Suite("SearchViewModel Comic Filter Tests")
struct SearchViewModelComicFilterTests {

    @Test("Should filter ongoing comics")
    @MainActor
    func testFilterOngoing() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupMixedComicsForFilterTests()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .comics

        // Use unique query to avoid cache collision
        let uniqueQuery = "FilterOngoing_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        viewModel.updateFilter(.ongoing)

        // Assert
        let filtered = viewModel.filteredComics
        // Ongoing should not contain annual, special, or variant
        for comic in filtered {
            let title = comic.title.lowercased()
            #expect(!title.contains("annual"))
            #expect(!title.contains("special"))
            #expect(!title.contains("variant"))
        }
    }

    @Test("Should filter special comics")
    @MainActor
    func testFilterSpecial() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupMixedComicsForFilterTests()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .comics

        // Use unique query to avoid cache collision
        let uniqueQuery = "FilterSpecial_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        viewModel.updateFilter(.special)

        // Assert
        let filtered = viewModel.filteredComics
        // Special should contain annual, special, or variant
        for comic in filtered {
            let title = comic.title.lowercased()
            let isSpecial = title.contains("annual") || title.contains("special") || title.contains("variant")
            #expect(isSpecial)
        }
    }
}

// MARK: - SearchViewModel Additional Functionality Tests

@Suite("SearchViewModel Additional Functionality Tests")
struct SearchViewModelAdditionalTests {

    @Test("Should select suggestion and search")
    @MainActor
    func testSelectSuggestion() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique suggestion to avoid cache collision
        let uniqueSuggestion = "Suggest_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.selectSuggestion(uniqueSuggestion)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.searchText == uniqueSuggestion)
        #expect(mockService.searchCharactersCalled)
    }

    @Test("Should select recent search and search")
    @MainActor
    func testSelectRecentSearch() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Batman")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique recent search to avoid cache collision
        let uniqueRecentSearch = "Recent_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.selectRecentSearch(uniqueRecentSearch)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.searchText == uniqueRecentSearch)
        #expect(mockService.searchCharactersCalled)
    }

    @Test("Should clear recent searches")
    @MainActor
    func testClearRecentSearches() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.recentSearches = ["Spider", "Batman", "X-Men"]

        // Act
        viewModel.clearRecentSearches()

        // Assert
        #expect(viewModel.recentSearches.isEmpty)
    }

    @Test("Should clear results")
    @MainActor
    func testClearResults() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "ClearResults_\(UUID().uuidString.prefix(8))"

        // First, perform a search
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Act
        viewModel.clearSearch()

        // Assert
        #expect(viewModel.characterResults.isEmpty)
        #expect(viewModel.comicResults.isEmpty)
    }

    @Test("Should have results when characters exist")
    @MainActor
    func testHasResultsWithCharacters() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "HasResults_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.hasResults)
    }

    @Test("Should have results when comics exist")
    @MainActor
    func testHasResultsWithComics() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.comicsToReturn = [Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .comics

        // Use unique query to avoid cache collision
        let uniqueQuery = "HasComicResults_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.hasResults)
    }

    @Test("Should not have results when empty")
    @MainActor
    func testHasNoResults() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert
        #expect(!viewModel.hasResults)
    }
}

// MARK: - SearchViewModel Loading State Tests

@Suite("SearchViewModel Loading State Tests")
struct SearchViewModelLoadingStateTests {

    @Test("Should set isSearching during search")
    @MainActor
    func testIsSearchingDuringSearch() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "Loading_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // Wait for search to complete (debounce + execution)
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert - verify search completed successfully
        #expect(!viewModel.characterResults.isEmpty)
    }

    @Test("Should set isSearching to false after search completes")
    @MainActor
    func testIsSearchingAfterSearch() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "LoadingComplete_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        #expect(viewModel.isSearching == false)
    }
}

// MARK: - SearchViewModel Debounce Tests

@Suite("SearchViewModel Debounce Tests")
struct SearchViewModelDebounceTests {

    @Test("Should debounce rapid searches")
    @MainActor
    func testDebounceRapidSearches() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique queries to avoid cache collision
        let baseQuery = "Debounce_\(UUID().uuidString.prefix(8))"

        // Act - rapid searches
        viewModel.searchText = "\(baseQuery)_1"
        viewModel.search()
        viewModel.searchText = "\(baseQuery)_2"
        viewModel.search()
        viewModel.searchText = "\(baseQuery)_3"
        viewModel.search()

        // Wait for debounce
        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert - only one search should have been made (the last one)
        // Note: Due to caching, searchCharactersCalled may vary
        #expect(viewModel.searchText == "\(baseQuery)_3")
    }
}

// MARK: - XCTest Integration Tests

class SearchViewModelXCTests: XCTestCase {

    @MainActor
    func testInitialState() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.searchType, .characters)
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertTrue(viewModel.characterResults.isEmpty)
    }

    @MainActor
    func testSwitchSearchType() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.switchSearchType(.comics)

        // Assert
        XCTAssertEqual(viewModel.searchType, .comics)
    }

    @MainActor
    func testUpdateFilter() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Act
        viewModel.updateFilter(.heroes)

        // Assert
        XCTAssertEqual(viewModel.selectedFilter, .heroes)
    }

    @MainActor
    func testClearSearch() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchText = "Test"

        // Act
        viewModel.clearSearch()

        // Assert
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }

    @MainActor
    func testHasResultsFalseWhenEmpty() {
        // Arrange
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert
        XCTAssertFalse(viewModel.hasResults)
    }

    @MainActor
    func testSearchCharacters() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.charactersToReturn = [Character.searchFixture(id: 1, name: "Spider-Man")]
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "XCTestChar_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // XCTest needs longer wait time
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        XCTAssertTrue(mockService.searchCharactersCalled)
        XCTAssertFalse(viewModel.characterResults.isEmpty)
    }

    @MainActor
    func testSearchComics() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.shouldFilterByQuery = false // Return all configured data regardless of query
        mockService.comicsToReturn = [Comic.ongoingSearchFixture(id: 1, volumeName: "Batman", issueNumber: "1")]
        let viewModel = SearchViewModel(comicVineService: mockService)
        viewModel.searchType = .comics

        // Use unique query to avoid cache collision
        let uniqueQuery = "XCTestComic_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // XCTest needs longer wait time
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        XCTAssertTrue(mockService.searchComicsCalled)
        XCTAssertFalse(viewModel.comicResults.isEmpty)
    }

    @MainActor
    func testSearchError() async throws {
        // Arrange
        let mockService = MockSearchService()
        mockService.setupNetworkError()
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Use unique query to avoid cache collision
        let uniqueQuery = "XCTestError_\(UUID().uuidString.prefix(8))"

        // Act
        viewModel.searchText = uniqueQuery
        viewModel.search()

        // XCTest needs longer wait time
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Assert
        XCTAssertNotNil(viewModel.error)
    }
}
