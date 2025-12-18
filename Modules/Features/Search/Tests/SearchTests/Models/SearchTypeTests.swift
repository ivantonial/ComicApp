//
//  SearchTypeTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import Search
import Foundation
import Testing
import XCTest

// MARK: - SearchType Initialization Tests

@Suite("SearchType Initialization Tests")
struct SearchTypeInitializationTests {

    @Test("SearchType should initialize with .characters case")
    func testCharactersCase() {
        // Act
        let type = SearchType.characters

        // Assert
        #expect(type == .characters)
        #expect(type.rawValue == "Characters")
    }

    @Test("SearchType should initialize with .comics case")
    func testComicsCase() {
        // Act
        let type = SearchType.comics

        // Assert
        #expect(type == .comics)
        #expect(type.rawValue == "Comics")
    }
}

// MARK: - SearchType CaseIterable Tests

@Suite("SearchType CaseIterable Tests")
struct SearchTypeCaseIterableTests {

    @Test("SearchType should have exactly 2 cases")
    func testCaseCount() {
        // Act
        let allCases = SearchType.allCases

        // Assert
        #expect(allCases.count == 2)
    }

    @Test("SearchType allCases should contain all expected cases")
    func testAllCasesContent() {
        // Act
        let allCases = SearchType.allCases

        // Assert
        #expect(allCases.contains(.characters))
        #expect(allCases.contains(.comics))
    }

    @Test("SearchType allCases should be in expected order")
    func testAllCasesOrder() {
        // Act
        let allCases = SearchType.allCases

        // Assert
        #expect(allCases[0] == .characters)
        #expect(allCases[1] == .comics)
    }
}

// MARK: - SearchType RawValue Tests

@Suite("SearchType RawValue Tests")
struct SearchTypeRawValueTests {

    @Test("SearchType rawValue should return correct strings")
    func testRawValues() {
        // Assert
        #expect(SearchType.characters.rawValue == "Characters")
        #expect(SearchType.comics.rawValue == "Comics")
    }

    @Test("SearchType should initialize from rawValue")
    func testInitFromRawValue() {
        // Act & Assert
        #expect(SearchType(rawValue: "Characters") == .characters)
        #expect(SearchType(rawValue: "Comics") == .comics)
    }

    @Test("SearchType should return nil for invalid rawValue")
    func testInvalidRawValue() {
        // Act & Assert
        #expect(SearchType(rawValue: "Invalid") == nil)
        #expect(SearchType(rawValue: "") == nil)
        #expect(SearchType(rawValue: "characters") == nil) // Case sensitive
        #expect(SearchType(rawValue: "COMICS") == nil)
    }
}

// MARK: - SearchType Icon Tests

@Suite("SearchType Icon Tests")
struct SearchTypeIconTests {

    @Test("SearchType icons should be unique")
    func testUniqueIcons() {
        // Act
        let icons = SearchType.allCases.map { $0.icon }
        let uniqueIcons = Set(icons)

        // Assert
        #expect(icons.count == uniqueIcons.count)
    }

    @Test("SearchType icons should not be empty")
    func testNonEmptyIcons() {
        // Assert
        for type in SearchType.allCases {
            #expect(!type.icon.isEmpty)
        }
    }

    @Test("SearchType icons should return correct SF Symbols")
    func testCorrectIcons() {
        // Assert
        #expect(SearchType.characters.icon == "person.3.fill")
        #expect(SearchType.comics.icon == "book.fill")
    }

    @Test("SearchType characters icon should represent people")
    func testCharactersIconSemantic() {
        // Act
        let icon = SearchType.characters.icon

        // Assert
        #expect(icon.contains("person"))
    }

    @Test("SearchType comics icon should represent books")
    func testComicsIconSemantic() {
        // Act
        let icon = SearchType.comics.icon

        // Assert
        #expect(icon.contains("book"))
    }
}

// MARK: - SearchType Identifiable Tests

@Suite("SearchType Identifiable Tests")
struct SearchTypeIdentifiableTests {

    @Test("SearchType id should equal rawValue")
    func testIdEqualsRawValue() {
        // Assert
        for type in SearchType.allCases {
            #expect(type.id == type.rawValue)
        }
    }

    @Test("SearchType ids should be unique")
    func testUniqueIds() {
        // Act
        let ids = SearchType.allCases.map { $0.id }
        let uniqueIds = Set(ids)

        // Assert
        #expect(ids.count == uniqueIds.count)
    }

    @Test("SearchType characters id should be Characters")
    func testCharactersId() {
        // Act
        let id = SearchType.characters.id

        // Assert
        #expect(id == "Characters")
    }

    @Test("SearchType comics id should be Comics")
    func testComicsId() {
        // Act
        let id = SearchType.comics.id

        // Assert
        #expect(id == "Comics")
    }
}

// MARK: - SearchType Equatable Tests

@Suite("SearchType Equatable Tests")
struct SearchTypeEquatableTests {

    @Test("Same types should be equal")
    func testSameTypesEqual() {
        // Act & Assert
        #expect(SearchType.characters == SearchType.characters)
        #expect(SearchType.comics == SearchType.comics)
    }

    @Test("Different types should not be equal")
    func testDifferentTypesNotEqual() {
        // Act & Assert
        #expect(SearchType.characters != SearchType.comics)
    }
}

// MARK: - SearchType Hashable Tests

@Suite("SearchType Hashable Tests")
struct SearchTypeHashableTests {

    @Test("SearchType should work in Set")
    func testSetUsage() {
        // Act
        var typeSet: Set<SearchType> = []
        typeSet.insert(.characters)
        typeSet.insert(.comics)
        typeSet.insert(.characters) // Duplicate

        // Assert
        #expect(typeSet.count == 2)
        #expect(typeSet.contains(.characters))
        #expect(typeSet.contains(.comics))
    }

    @Test("SearchType should work as Dictionary key")
    func testDictionaryKeyUsage() {
        // Act
        var typeDict: [SearchType: String] = [:]
        typeDict[.characters] = "Characters Tab"
        typeDict[.comics] = "Comics Tab"

        // Assert
        #expect(typeDict[.characters] == "Characters Tab")
        #expect(typeDict[.comics] == "Comics Tab")
    }
}

// MARK: - SearchType UI-Related Tests

@Suite("SearchType UI-Related Tests")
struct SearchTypeUITests {

    @Test("SearchType should work in ForEach")
    func testForEachUsage() {
        // Act
        var count = 0
        for _ in SearchType.allCases {
            count += 1
        }

        // Assert
        #expect(count == 2)
    }

    @Test("SearchType should have distinct visual identifiers")
    func testDistinctVisualIdentifiers() {
        // Act
        let characters = SearchType.characters
        let comics = SearchType.comics

        // Assert - Different rawValues
        #expect(characters.rawValue != comics.rawValue)

        // Assert - Different icons
        #expect(characters.icon != comics.icon)

        // Assert - Different ids
        #expect(characters.id != comics.id)
    }
}

// MARK: - XCTest Integration Tests

class SearchTypeXCTests: XCTestCase {

    func testAllCasesCount() {
        // Arrange & Act
        let allCases = SearchType.allCases

        // Assert
        XCTAssertEqual(allCases.count, 2)
    }

    func testRawValues() {
        // Assert
        XCTAssertEqual(SearchType.characters.rawValue, "Characters")
        XCTAssertEqual(SearchType.comics.rawValue, "Comics")
    }

    func testInitFromRawValue() {
        // Assert
        XCTAssertEqual(SearchType(rawValue: "Characters"), .characters)
        XCTAssertEqual(SearchType(rawValue: "Comics"), .comics)
        XCTAssertNil(SearchType(rawValue: "Invalid"))
    }

    func testIcons() {
        // Assert
        XCTAssertEqual(SearchType.characters.icon, "person.3.fill")
        XCTAssertEqual(SearchType.comics.icon, "book.fill")
    }

    func testIds() {
        // Assert
        XCTAssertEqual(SearchType.characters.id, "Characters")
        XCTAssertEqual(SearchType.comics.id, "Comics")
    }

    func testEquality() {
        // Assert
        XCTAssertEqual(SearchType.characters, SearchType.characters)
        XCTAssertEqual(SearchType.comics, SearchType.comics)
        XCTAssertNotEqual(SearchType.characters, SearchType.comics)
    }

    func testHashableInSet() {
        // Arrange
        var set: Set<SearchType> = []

        // Act
        set.insert(.characters)
        set.insert(.comics)
        set.insert(.characters) // Duplicate

        // Assert
        XCTAssertEqual(set.count, 2)
    }
}
