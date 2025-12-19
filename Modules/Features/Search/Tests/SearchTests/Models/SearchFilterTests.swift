//
//  SearchFilterTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import Search
import Foundation
import Testing
import XCTest

// MARK: - SearchFilter Initialization Tests

@Suite("SearchFilter Initialization Tests")
struct SearchFilterInitializationTests {

    @Test("SearchFilter should initialize with .all case")
    func testAllCase() {
        // Act
        let filter = SearchFilter.all

        // Assert
        #expect(filter == .all)
        #expect(filter.rawValue == "All")
    }

    @Test("SearchFilter should initialize with .heroes case")
    func testHeroesCase() {
        // Act
        let filter = SearchFilter.heroes

        // Assert
        #expect(filter == .heroes)
        #expect(filter.rawValue == "Heroes")
    }

    @Test("SearchFilter should initialize with .villains case")
    func testVillainsCase() {
        // Act
        let filter = SearchFilter.villains

        // Assert
        #expect(filter == .villains)
        #expect(filter.rawValue == "Villains")
    }

    @Test("SearchFilter should initialize with .teams case")
    func testTeamsCase() {
        // Act
        let filter = SearchFilter.teams

        // Assert
        #expect(filter == .teams)
        #expect(filter.rawValue == "Teams")
    }

    @Test("SearchFilter should initialize with .ongoing case")
    func testOngoingCase() {
        // Act
        let filter = SearchFilter.ongoing

        // Assert
        #expect(filter == .ongoing)
        #expect(filter.rawValue == "Ongoing")
    }

    @Test("SearchFilter should initialize with .completed case")
    func testCompletedCase() {
        // Act
        let filter = SearchFilter.completed

        // Assert
        #expect(filter == .completed)
        #expect(filter.rawValue == "Completed")
    }

    @Test("SearchFilter should initialize with .special case")
    func testSpecialCase() {
        // Act
        let filter = SearchFilter.special

        // Assert
        #expect(filter == .special)
        #expect(filter.rawValue == "Special")
    }
}

// MARK: - SearchFilter CaseIterable Tests

@Suite("SearchFilter CaseIterable Tests")
struct SearchFilterCaseIterableTests {

    @Test("SearchFilter should have exactly 7 cases")
    func testCaseCount() {
        // Act
        let allCases = SearchFilter.allCases

        // Assert
        #expect(allCases.count == 7)
    }

    @Test("SearchFilter allCases should contain all expected cases")
    func testAllCasesContent() {
        // Act
        let allCases = SearchFilter.allCases

        // Assert
        #expect(allCases.contains(.all))
        #expect(allCases.contains(.heroes))
        #expect(allCases.contains(.villains))
        #expect(allCases.contains(.teams))
        #expect(allCases.contains(.ongoing))
        #expect(allCases.contains(.completed))
        #expect(allCases.contains(.special))
    }

    @Test("SearchFilter allCases should be in expected order")
    func testAllCasesOrder() {
        // Act
        let allCases = SearchFilter.allCases

        // Assert
        #expect(allCases[0] == .all)
        #expect(allCases[1] == .heroes)
        #expect(allCases[2] == .villains)
        #expect(allCases[3] == .teams)
        #expect(allCases[4] == .ongoing)
        #expect(allCases[5] == .completed)
        #expect(allCases[6] == .special)
    }
}

// MARK: - SearchFilter RawValue Tests

@Suite("SearchFilter RawValue Tests")
struct SearchFilterRawValueTests {

    @Test("SearchFilter rawValue should return correct strings")
    func testRawValues() {
        // Assert
        #expect(SearchFilter.all.rawValue == "All")
        #expect(SearchFilter.heroes.rawValue == "Heroes")
        #expect(SearchFilter.villains.rawValue == "Villains")
        #expect(SearchFilter.teams.rawValue == "Teams")
        #expect(SearchFilter.ongoing.rawValue == "Ongoing")
        #expect(SearchFilter.completed.rawValue == "Completed")
        #expect(SearchFilter.special.rawValue == "Special")
    }

    @Test("SearchFilter should initialize from rawValue")
    func testInitFromRawValue() {
        // Act & Assert
        #expect(SearchFilter(rawValue: "All") == .all)
        #expect(SearchFilter(rawValue: "Heroes") == .heroes)
        #expect(SearchFilter(rawValue: "Villains") == .villains)
        #expect(SearchFilter(rawValue: "Teams") == .teams)
        #expect(SearchFilter(rawValue: "Ongoing") == .ongoing)
        #expect(SearchFilter(rawValue: "Completed") == .completed)
        #expect(SearchFilter(rawValue: "Special") == .special)
    }

    @Test("SearchFilter should return nil for invalid rawValue")
    func testInvalidRawValue() {
        // Act & Assert
        #expect(SearchFilter(rawValue: "Invalid") == nil)
        #expect(SearchFilter(rawValue: "") == nil)
        #expect(SearchFilter(rawValue: "all") == nil) // Case sensitive
        #expect(SearchFilter(rawValue: "HEROES") == nil)
    }
}

// MARK: - SearchFilter Title Tests

@Suite("SearchFilter Title Tests")
struct SearchFilterTitleTests {

    @Test("SearchFilter title should match rawValue")
    func testTitleMatchesRawValue() {
        // Assert
        for filter in SearchFilter.allCases {
            #expect(filter.title == filter.rawValue)
        }
    }

    @Test("SearchFilter title should return correct values")
    func testTitleValues() {
        // Assert
        #expect(SearchFilter.all.title == "All")
        #expect(SearchFilter.heroes.title == "Heroes")
        #expect(SearchFilter.villains.title == "Villains")
        #expect(SearchFilter.teams.title == "Teams")
        #expect(SearchFilter.ongoing.title == "Ongoing")
        #expect(SearchFilter.completed.title == "Completed")
        #expect(SearchFilter.special.title == "Special")
    }
}

// MARK: - SearchFilter Icon Tests

@Suite("SearchFilter Icon Tests")
struct SearchFilterIconTests {

    @Test("SearchFilter icons should be unique")
    func testUniqueIcons() {
        // Act
        let icons = SearchFilter.allCases.map { $0.icon }
        let uniqueIcons = Set(icons)

        // Assert
        #expect(icons.count == uniqueIcons.count)
    }

    @Test("SearchFilter icons should not be empty")
    func testNonEmptyIcons() {
        // Assert
        for filter in SearchFilter.allCases {
            #expect(!filter.icon.isEmpty)
        }
    }

    @Test("SearchFilter icons should return correct SF Symbols")
    func testCorrectIcons() {
        // Assert
        #expect(SearchFilter.all.icon == "square.grid.2x2")
        #expect(SearchFilter.heroes.icon == "person.fill.badge.plus")
        #expect(SearchFilter.villains.icon == "person.fill.xmark")
        #expect(SearchFilter.teams.icon == "person.3.sequence.fill")
        #expect(SearchFilter.ongoing.icon == "arrow.right.circle")
        #expect(SearchFilter.completed.icon == "checkmark.circle")
        #expect(SearchFilter.special.icon == "star.circle")
    }
}

// MARK: - SearchFilter Identifiable Tests

@Suite("SearchFilter Identifiable Tests")
struct SearchFilterIdentifiableTests {

    @Test("SearchFilter id should equal rawValue")
    func testIdEqualsRawValue() {
        // Assert
        for filter in SearchFilter.allCases {
            #expect(filter.id == filter.rawValue)
        }
    }

    @Test("SearchFilter ids should be unique")
    func testUniqueIds() {
        // Act
        let ids = SearchFilter.allCases.map { $0.id }
        let uniqueIds = Set(ids)

        // Assert
        #expect(ids.count == uniqueIds.count)
    }
}

// MARK: - SearchFilter Sendable Tests

@Suite("SearchFilter Sendable Tests")
struct SearchFilterSendableTests {

    @Test("SearchFilter should conform to Sendable")
    func testSendableConformance() {
        // Act
        let filter: Sendable = SearchFilter.all

        // Assert
        #expect(filter is SearchFilter)
    }

    @Test("SearchFilter should be usable in concurrent context")
    func testConcurrentUsage() async {
        // Act
        let filter = await Task {
            SearchFilter.heroes
        }.value

        // Assert
        #expect(filter == .heroes)
    }
}

// MARK: - SearchFilter filters(for:) Tests

@Suite("SearchFilter filters(for:) Tests")
struct SearchFilterFiltersForTypeTests {

    @Test("filters(for: .characters) should return character filters")
    func testFiltersForCharacters() {
        // Act
        let filters = SearchFilter.filters(for: .characters)

        // Assert
        #expect(filters.count == 4)
        #expect(filters[0] == .all)
        #expect(filters[1] == .heroes)
        #expect(filters[2] == .villains)
        #expect(filters[3] == .teams)
    }

    @Test("filters(for: .comics) should return comic filters")
    func testFiltersForComics() {
        // Act
        let filters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(filters.count == 4)
        #expect(filters[0] == .all)
        #expect(filters[1] == .ongoing)
        #expect(filters[2] == .completed)
        #expect(filters[3] == .special)
    }

    @Test("filters(for: .characters) should not contain comic filters")
    func testCharacterFiltersExcludeComicFilters() {
        // Act
        let filters = SearchFilter.filters(for: .characters)

        // Assert
        #expect(!filters.contains(.ongoing))
        #expect(!filters.contains(.completed))
        #expect(!filters.contains(.special))
    }

    @Test("filters(for: .comics) should not contain character filters")
    func testComicFiltersExcludeCharacterFilters() {
        // Act
        let filters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(!filters.contains(.heroes))
        #expect(!filters.contains(.villains))
        #expect(!filters.contains(.teams))
    }

    @Test("Both filter sets should include .all filter")
    func testBothIncludeAllFilter() {
        // Act
        let characterFilters = SearchFilter.filters(for: .characters)
        let comicFilters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(characterFilters.contains(.all))
        #expect(comicFilters.contains(.all))
    }

    @Test(".all filter should be first in both sets")
    func testAllFilterIsFirst() {
        // Act
        let characterFilters = SearchFilter.filters(for: .characters)
        let comicFilters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(characterFilters.first == .all)
        #expect(comicFilters.first == .all)
    }
}

// MARK: - SearchFilter Equatable Tests

@Suite("SearchFilter Equatable Tests")
struct SearchFilterEquatableTests {

    @Test("Same filters should be equal")
    func testSameFiltersEqual() {
        // Act & Assert
        #expect(SearchFilter.all == SearchFilter.all)
        #expect(SearchFilter.heroes == SearchFilter.heroes)
        #expect(SearchFilter.villains == SearchFilter.villains)
    }

    @Test("Different filters should not be equal")
    func testDifferentFiltersNotEqual() {
        // Act & Assert
        #expect(SearchFilter.all != SearchFilter.heroes)
        #expect(SearchFilter.heroes != SearchFilter.villains)
        #expect(SearchFilter.ongoing != SearchFilter.special)
    }
}

// MARK: - SearchFilter Hashable Tests

@Suite("SearchFilter Hashable Tests")
struct SearchFilterHashableTests {

    @Test("SearchFilter should work in Set")
    func testSetUsage() {
        // Act
        var filterSet: Set<SearchFilter> = []
        filterSet.insert(.all)
        filterSet.insert(.heroes)
        filterSet.insert(.all) // Duplicate

        // Assert
        #expect(filterSet.count == 2)
        #expect(filterSet.contains(.all))
        #expect(filterSet.contains(.heroes))
    }

    @Test("SearchFilter should work as Dictionary key")
    func testDictionaryKeyUsage() {
        // Act
        var filterDict: [SearchFilter: String] = [:]
        filterDict[.all] = "All Items"
        filterDict[.heroes] = "Heroes Only"

        // Assert
        #expect(filterDict[.all] == "All Items")
        #expect(filterDict[.heroes] == "Heroes Only")
        #expect(filterDict[.villains] == nil)
    }
}

// MARK: - XCTest Integration Tests

class SearchFilterXCTests: XCTestCase {

    func testAllCasesCount() {
        // Arrange & Act
        let allCases = SearchFilter.allCases

        // Assert
        XCTAssertEqual(allCases.count, 7)
    }

    func testRawValues() {
        // Assert
        XCTAssertEqual(SearchFilter.all.rawValue, "All")
        XCTAssertEqual(SearchFilter.heroes.rawValue, "Heroes")
        XCTAssertEqual(SearchFilter.villains.rawValue, "Villains")
        XCTAssertEqual(SearchFilter.teams.rawValue, "Teams")
        XCTAssertEqual(SearchFilter.ongoing.rawValue, "Ongoing")
        XCTAssertEqual(SearchFilter.completed.rawValue, "Completed")
        XCTAssertEqual(SearchFilter.special.rawValue, "Special")
    }

    func testFiltersForCharacters() {
        // Act
        let filters = SearchFilter.filters(for: .characters)

        // Assert
        XCTAssertEqual(filters.count, 4)
        XCTAssertEqual(filters[0], .all)
        XCTAssertEqual(filters[1], .heroes)
        XCTAssertEqual(filters[2], .villains)
        XCTAssertEqual(filters[3], .teams)
    }

    func testFiltersForComics() {
        // Act
        let filters = SearchFilter.filters(for: .comics)

        // Assert
        XCTAssertEqual(filters.count, 4)
        XCTAssertEqual(filters[0], .all)
        XCTAssertEqual(filters[1], .ongoing)
        XCTAssertEqual(filters[2], .completed)
        XCTAssertEqual(filters[3], .special)
    }

    func testTitleMatchesRawValue() {
        // Assert
        for filter in SearchFilter.allCases {
            XCTAssertEqual(filter.title, filter.rawValue)
        }
    }

    func testIdMatchesRawValue() {
        // Assert
        for filter in SearchFilter.allCases {
            XCTAssertEqual(filter.id, filter.rawValue)
        }
    }

    func testIconsAreNotEmpty() {
        // Assert
        for filter in SearchFilter.allCases {
            XCTAssertFalse(filter.icon.isEmpty)
        }
    }
}
