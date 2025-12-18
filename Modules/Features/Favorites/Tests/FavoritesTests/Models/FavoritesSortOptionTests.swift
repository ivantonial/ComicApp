//
//  FavoritesSortOptionTests.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import Favorites
import Foundation
import Testing
import XCTest

// MARK: - FavoritesSortOption Initialization Tests

@Suite("FavoritesSortOption Initialization Tests")
struct FavoritesSortOptionInitializationTests {

    @Test("Should initialize dateAdded case")
    func testDateAddedInitialization() {
        // Act
        let sortOption = FavoritesSortOption.dateAdded

        // Assert
        #expect(sortOption == .dateAdded)
        #expect(sortOption.rawValue == "Date Added")
    }

    @Test("Should initialize name case")
    func testNameInitialization() {
        // Act
        let sortOption = FavoritesSortOption.name

        // Assert
        #expect(sortOption == .name)
        #expect(sortOption.rawValue == "Name")
    }

    @Test("Should initialize mostComics case")
    func testMostComicsInitialization() {
        // Act
        let sortOption = FavoritesSortOption.mostComics

        // Assert
        #expect(sortOption == .mostComics)
        #expect(sortOption.rawValue == "Most Comics")
    }
}

// MARK: - FavoritesSortOption CaseIterable Tests

@Suite("FavoritesSortOption CaseIterable Tests")
struct FavoritesSortOptionCaseIterableTests {

    @Test("Should conform to CaseIterable")
    func testCaseIterableConformance() {
        // Act
        let allCases = FavoritesSortOption.allCases

        // Assert
        #expect(allCases.count == 3)
    }

    @Test("Should contain all expected cases")
    func testAllCasesContent() {
        // Act
        let allCases = FavoritesSortOption.allCases

        // Assert
        #expect(allCases.contains(.dateAdded))
        #expect(allCases.contains(.name))
        #expect(allCases.contains(.mostComics))
    }

    @Test("Cases should be in expected order")
    func testCasesOrder() {
        // Act
        let allCases = FavoritesSortOption.allCases

        // Assert
        #expect(allCases[0] == .dateAdded)
        #expect(allCases[1] == .name)
        #expect(allCases[2] == .mostComics)
    }
}

// MARK: - FavoritesSortOption RawValue Tests

@Suite("FavoritesSortOption RawValue Tests")
struct FavoritesSortOptionRawValueTests {

    @Test("dateAdded should have correct rawValue")
    func testDateAddedRawValue() {
        // Assert
        #expect(FavoritesSortOption.dateAdded.rawValue == "Date Added")
    }

    @Test("name should have correct rawValue")
    func testNameRawValue() {
        // Assert
        #expect(FavoritesSortOption.name.rawValue == "Name")
    }

    @Test("mostComics should have correct rawValue")
    func testMostComicsRawValue() {
        // Assert
        #expect(FavoritesSortOption.mostComics.rawValue == "Most Comics")
    }

    @Test("Should initialize from valid rawValue")
    func testInitFromRawValue() {
        // Act & Assert
        #expect(FavoritesSortOption(rawValue: "Date Added") == .dateAdded)
        #expect(FavoritesSortOption(rawValue: "Name") == .name)
        #expect(FavoritesSortOption(rawValue: "Most Comics") == .mostComics)
    }

    @Test("Should return nil for invalid rawValue")
    func testInitFromInvalidRawValue() {
        // Act & Assert
        #expect(FavoritesSortOption(rawValue: "Invalid") == nil)
        #expect(FavoritesSortOption(rawValue: "") == nil)
        #expect(FavoritesSortOption(rawValue: "date added") == nil) // Case sensitive
    }
}

// MARK: - FavoritesSortOption Title Tests

@Suite("FavoritesSortOption Title Tests")
struct FavoritesSortOptionTitleTests {

    @Test("dateAdded should have correct title")
    func testDateAddedTitle() {
        // Assert
        #expect(FavoritesSortOption.dateAdded.title == "Date Added")
    }

    @Test("name should have correct title")
    func testNameTitle() {
        // Assert
        #expect(FavoritesSortOption.name.title == "Name")
    }

    @Test("mostComics should have correct title")
    func testMostComicsTitle() {
        // Assert
        #expect(FavoritesSortOption.mostComics.title == "Most Comics")
    }

    @Test("title should match rawValue for all cases")
    func testTitleMatchesRawValue() {
        // Act & Assert
        for option in FavoritesSortOption.allCases {
            #expect(option.title == option.rawValue)
        }
    }
}

// MARK: - FavoritesSortOption Icon Tests

@Suite("FavoritesSortOption Icon Tests")
struct FavoritesSortOptionIconTests {

    @Test("dateAdded should have calendar icon")
    func testDateAddedIcon() {
        // Assert
        #expect(FavoritesSortOption.dateAdded.icon == "calendar")
    }

    @Test("name should have textformat.abc icon")
    func testNameIcon() {
        // Assert
        #expect(FavoritesSortOption.name.icon == "textformat.abc")
    }

    @Test("mostComics should have book.fill icon")
    func testMostComicsIcon() {
        // Assert
        #expect(FavoritesSortOption.mostComics.icon == "book.fill")
    }

    @Test("All cases should have unique icons")
    func testUniqueIcons() {
        // Act
        let icons = FavoritesSortOption.allCases.map { $0.icon }
        let uniqueIcons = Set(icons)

        // Assert
        #expect(icons.count == uniqueIcons.count)
    }

    @Test("All cases should have non-empty icons")
    func testNonEmptyIcons() {
        // Act & Assert
        for option in FavoritesSortOption.allCases {
            #expect(!option.icon.isEmpty)
        }
    }
}

// MARK: - FavoritesSortOption Equatable Tests

@Suite("FavoritesSortOption Equatable Tests")
struct FavoritesSortOptionEquatableTests {

    @Test("Same cases should be equal")
    func testSameCasesEqual() {
        // Assert
        #expect(FavoritesSortOption.dateAdded == FavoritesSortOption.dateAdded)
        #expect(FavoritesSortOption.name == FavoritesSortOption.name)
        #expect(FavoritesSortOption.mostComics == FavoritesSortOption.mostComics)
    }

    @Test("Different cases should not be equal")
    func testDifferentCasesNotEqual() {
        // Assert
        #expect(FavoritesSortOption.dateAdded != FavoritesSortOption.name)
        #expect(FavoritesSortOption.dateAdded != FavoritesSortOption.mostComics)
        #expect(FavoritesSortOption.name != FavoritesSortOption.mostComics)
    }
}

// MARK: - FavoritesSortOption Hashable Tests

@Suite("FavoritesSortOption Hashable Tests")
struct FavoritesSortOptionHashableTests {

    @Test("Same cases should have same hash")
    func testSameHashForSameCases() {
        // Arrange
        let option1 = FavoritesSortOption.dateAdded
        let option2 = FavoritesSortOption.dateAdded

        // Assert
        #expect(option1.hashValue == option2.hashValue)
    }

    @Test("Can be used in Set")
    func testCanBeUsedInSet() {
        // Act
        var set = Set<FavoritesSortOption>()
        set.insert(.dateAdded)
        set.insert(.name)
        set.insert(.dateAdded) // Duplicate

        // Assert
        #expect(set.count == 2)
        #expect(set.contains(.dateAdded))
        #expect(set.contains(.name))
    }

    @Test("Can be used as Dictionary key")
    func testCanBeUsedAsDictionaryKey() {
        // Act
        var dict = [FavoritesSortOption: String]()
        dict[.dateAdded] = "First"
        dict[.name] = "Second"
        dict[.mostComics] = "Third"

        // Assert
        #expect(dict[.dateAdded] == "First")
        #expect(dict[.name] == "Second")
        #expect(dict[.mostComics] == "Third")
    }
}

// MARK: - XCTest Integration Tests

class FavoritesSortOptionXCTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(FavoritesSortOption.allCases.count, 3)
    }

    func testRawValues() {
        XCTAssertEqual(FavoritesSortOption.dateAdded.rawValue, "Date Added")
        XCTAssertEqual(FavoritesSortOption.name.rawValue, "Name")
        XCTAssertEqual(FavoritesSortOption.mostComics.rawValue, "Most Comics")
    }

    func testTitles() {
        XCTAssertEqual(FavoritesSortOption.dateAdded.title, "Date Added")
        XCTAssertEqual(FavoritesSortOption.name.title, "Name")
        XCTAssertEqual(FavoritesSortOption.mostComics.title, "Most Comics")
    }

    func testIcons() {
        XCTAssertEqual(FavoritesSortOption.dateAdded.icon, "calendar")
        XCTAssertEqual(FavoritesSortOption.name.icon, "textformat.abc")
        XCTAssertEqual(FavoritesSortOption.mostComics.icon, "book.fill")
    }

    func testInitFromRawValue() {
        XCTAssertEqual(FavoritesSortOption(rawValue: "Date Added"), .dateAdded)
        XCTAssertEqual(FavoritesSortOption(rawValue: "Name"), .name)
        XCTAssertEqual(FavoritesSortOption(rawValue: "Most Comics"), .mostComics)
        XCTAssertNil(FavoritesSortOption(rawValue: "Invalid"))
    }

    func testEquality() {
        XCTAssertEqual(FavoritesSortOption.dateAdded, FavoritesSortOption.dateAdded)
        XCTAssertNotEqual(FavoritesSortOption.dateAdded, FavoritesSortOption.name)
    }

    func testHashable() {
        let set: Set<FavoritesSortOption> = [.dateAdded, .name, .mostComics, .dateAdded]
        XCTAssertEqual(set.count, 3)
    }

    func testTitleMatchesRawValue() {
        for option in FavoritesSortOption.allCases {
            XCTAssertEqual(option.title, option.rawValue)
        }
    }

    func testUniqueIcons() {
        let icons = FavoritesSortOption.allCases.map { $0.icon }
        let uniqueIcons = Set(icons)
        XCTAssertEqual(icons.count, uniqueIcons.count)
    }
}
