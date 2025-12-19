//
//  ComicFilterTests.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import ComicsList
import Foundation
import Testing
import XCTest

// MARK: - ComicFilter Raw Value Tests

@Suite("ComicFilter Raw Value Tests")
struct ComicFilterRawValueTests {

    @Test("All filter should have correct raw value")
    func testAllRawValue() {
        // Assert
        #expect(ComicFilter.all.rawValue == "All")
    }

    @Test("Recent filter should have correct raw value")
    func testRecentRawValue() {
        // Assert
        #expect(ComicFilter.recent.rawValue == "Recent")
    }

    @Test("Popular filter should have correct raw value")
    func testPopularRawValue() {
        // Assert
        #expect(ComicFilter.popular.rawValue == "Popular")
    }

    @Test("Classic filter should have correct raw value")
    func testClassicRawValue() {
        // Assert
        #expect(ComicFilter.classic.rawValue == "Classic")
    }
}

// MARK: - ComicFilter Identifiable Tests

@Suite("ComicFilter Identifiable Tests")
struct ComicFilterIdentifiableTests {

    @Test("Filter id should equal rawValue")
    func testIdEqualsRawValue() {
        // Assert
        for filter in ComicFilter.allCases {
            #expect(filter.id == filter.rawValue)
        }
    }

    @Test("All filters should have unique IDs")
    func testUniqueIds() {
        // Act
        let ids = Set(ComicFilter.allCases.map { $0.id })

        // Assert
        #expect(ids.count == ComicFilter.allCases.count)
    }

    @Test("All filter id should be 'All'")
    func testAllId() {
        // Assert
        #expect(ComicFilter.all.id == "All")
    }

    @Test("Recent filter id should be 'Recent'")
    func testRecentId() {
        // Assert
        #expect(ComicFilter.recent.id == "Recent")
    }

    @Test("Popular filter id should be 'Popular'")
    func testPopularId() {
        // Assert
        #expect(ComicFilter.popular.id == "Popular")
    }

    @Test("Classic filter id should be 'Classic'")
    func testClassicId() {
        // Assert
        #expect(ComicFilter.classic.id == "Classic")
    }
}

// MARK: - ComicFilter Title Tests

@Suite("ComicFilter Title Tests")
struct ComicFilterTitleTests {

    @Test("Title should equal rawValue")
    func testTitleEqualsRawValue() {
        // Assert
        for filter in ComicFilter.allCases {
            #expect(filter.title == filter.rawValue)
        }
    }

    @Test("All filter title should be 'All'")
    func testAllTitle() {
        // Assert
        #expect(ComicFilter.all.title == "All")
    }

    @Test("Recent filter title should be 'Recent'")
    func testRecentTitle() {
        // Assert
        #expect(ComicFilter.recent.title == "Recent")
    }

    @Test("Popular filter title should be 'Popular'")
    func testPopularTitle() {
        // Assert
        #expect(ComicFilter.popular.title == "Popular")
    }

    @Test("Classic filter title should be 'Classic'")
    func testClassicTitle() {
        // Assert
        #expect(ComicFilter.classic.title == "Classic")
    }
}

// MARK: - ComicFilter CaseIterable Tests

@Suite("ComicFilter CaseIterable Tests")
struct ComicFilterCaseIterableTests {

    @Test("Should have exactly 4 cases")
    func testCaseCount() {
        // Assert
        #expect(ComicFilter.allCases.count == 4)
    }

    @Test("Should contain all expected cases")
    func testContainsAllCases() {
        // Act
        let allCases = ComicFilter.allCases

        // Assert
        #expect(allCases.contains(.all))
        #expect(allCases.contains(.recent))
        #expect(allCases.contains(.popular))
        #expect(allCases.contains(.classic))
    }

    @Test("Cases should be in expected order")
    func testCaseOrder() {
        // Act
        let cases = ComicFilter.allCases

        // Assert
        #expect(cases[0] == .all)
        #expect(cases[1] == .recent)
        #expect(cases[2] == .popular)
        #expect(cases[3] == .classic)
    }

    @Test("Should be iterable in ForEach")
    func testIterability() {
        // Act
        var titles: [String] = []
        for filter in ComicFilter.allCases {
            titles.append(filter.title)
        }

        // Assert
        #expect(titles.count == 4)
        #expect(titles == ["All", "Recent", "Popular", "Classic"])
    }
}

// MARK: - ComicFilter Equality Tests

@Suite("ComicFilter Equality Tests")
struct ComicFilterEqualityTests {

    @Test("Same filters should be equal")
    func testSameFiltersEqual() {
        // Assert
        #expect(ComicFilter.all == ComicFilter.all)
        #expect(ComicFilter.recent == ComicFilter.recent)
        #expect(ComicFilter.popular == ComicFilter.popular)
        #expect(ComicFilter.classic == ComicFilter.classic)
    }

    @Test("Different filters should not be equal")
    func testDifferentFiltersNotEqual() {
        // Assert
        #expect(ComicFilter.all != ComicFilter.recent)
        #expect(ComicFilter.all != ComicFilter.popular)
        #expect(ComicFilter.all != ComicFilter.classic)
        #expect(ComicFilter.recent != ComicFilter.popular)
        #expect(ComicFilter.recent != ComicFilter.classic)
        #expect(ComicFilter.popular != ComicFilter.classic)
    }
}

// MARK: - ComicFilter Hashable Tests

@Suite("ComicFilter Hashable Tests")
struct ComicFilterHashableTests {

    @Test("Should be usable in Set")
    func testUsableInSet() {
        // Act
        var filterSet = Set<ComicFilter>()
        filterSet.insert(.all)
        filterSet.insert(.recent)
        filterSet.insert(.all) // Duplicado

        // Assert
        #expect(filterSet.count == 2)
    }

    @Test("Should be usable as Dictionary key")
    func testUsableAsDictionaryKey() {
        // Act
        var filterDict: [ComicFilter: String] = [:]
        filterDict[.all] = "Show all comics"
        filterDict[.recent] = "Show recent comics"
        filterDict[.popular] = "Show popular comics"
        filterDict[.classic] = "Show classic comics"

        // Assert
        #expect(filterDict.count == 4)
        #expect(filterDict[.all] == "Show all comics")
        #expect(filterDict[.recent] == "Show recent comics")
    }

    @Test("Same filters should have same hash")
    func testSameFiltersSameHash() {
        // Arrange
        let filter1 = ComicFilter.all
        let filter2 = ComicFilter.all

        // Assert
        #expect(filter1.hashValue == filter2.hashValue)
    }
}

// MARK: - ComicFilter String Convertible Tests

@Suite("ComicFilter String Convertible Tests")
struct ComicFilterStringConvertibleTests {

    @Test("Should be creatable from raw value")
    func testCreateFromRawValue() {
        // Act
        let all = ComicFilter(rawValue: "All")
        let recent = ComicFilter(rawValue: "Recent")
        let popular = ComicFilter(rawValue: "Popular")
        let classic = ComicFilter(rawValue: "Classic")

        // Assert
        #expect(all == .all)
        #expect(recent == .recent)
        #expect(popular == .popular)
        #expect(classic == .classic)
    }

    @Test("Should return nil for invalid raw value")
    func testInvalidRawValue() {
        // Act
        let invalid1 = ComicFilter(rawValue: "Invalid")
        let invalid2 = ComicFilter(rawValue: "all") // Case sensitive
        let invalid3 = ComicFilter(rawValue: "")

        // Assert
        #expect(invalid1 == nil)
        #expect(invalid2 == nil)
        #expect(invalid3 == nil)
    }
}

// MARK: - XCTest Integration Tests

class ComicFilterXCTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(ComicFilter.allCases.count, 4)
    }

    func testRawValues() {
        XCTAssertEqual(ComicFilter.all.rawValue, "All")
        XCTAssertEqual(ComicFilter.recent.rawValue, "Recent")
        XCTAssertEqual(ComicFilter.popular.rawValue, "Popular")
        XCTAssertEqual(ComicFilter.classic.rawValue, "Classic")
    }

    func testTitles() {
        XCTAssertEqual(ComicFilter.all.title, "All")
        XCTAssertEqual(ComicFilter.recent.title, "Recent")
        XCTAssertEqual(ComicFilter.popular.title, "Popular")
        XCTAssertEqual(ComicFilter.classic.title, "Classic")
    }

    func testIdentifiers() {
        XCTAssertEqual(ComicFilter.all.id, "All")
        XCTAssertEqual(ComicFilter.recent.id, "Recent")
        XCTAssertEqual(ComicFilter.popular.id, "Popular")
        XCTAssertEqual(ComicFilter.classic.id, "Classic")
    }

    func testEquality() {
        XCTAssertEqual(ComicFilter.all, ComicFilter.all)
        XCTAssertNotEqual(ComicFilter.all, ComicFilter.recent)
    }

    func testCreateFromRawValue() {
        XCTAssertEqual(ComicFilter(rawValue: "All"), .all)
        XCTAssertEqual(ComicFilter(rawValue: "Recent"), .recent)
        XCTAssertEqual(ComicFilter(rawValue: "Popular"), .popular)
        XCTAssertEqual(ComicFilter(rawValue: "Classic"), .classic)
        XCTAssertNil(ComicFilter(rawValue: "Invalid"))
    }

    func testSetOperations() {
        // Arrange
        var set = Set<ComicFilter>()

        // Act
        set.insert(.all)
        set.insert(.recent)
        set.insert(.all) // Duplicado

        // Assert
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(set.contains(.all))
        XCTAssertTrue(set.contains(.recent))
        XCTAssertFalse(set.contains(.popular))
    }

    func testDictionaryOperations() {
        // Arrange
        var dict: [ComicFilter: Int] = [:]

        // Act
        dict[.all] = 100
        dict[.recent] = 50
        dict[.popular] = 25
        dict[.classic] = 10

        // Assert
        XCTAssertEqual(dict[.all], 100)
        XCTAssertEqual(dict[.recent], 50)
        XCTAssertEqual(dict[.popular], 25)
        XCTAssertEqual(dict[.classic], 10)
    }
}
