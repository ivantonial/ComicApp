//
//  SortOptionTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import Search
import Foundation
import Testing
import XCTest

// MARK: - SortOption Initialization Tests

@Suite("SortOption Initialization Tests")
struct SortOptionInitializationTests {

    @Test("SortOption should initialize with .name case")
    func testNameCase() {
        // Act
        let option = SortOption.name

        // Assert
        #expect(option == .name)
        #expect(option.rawValue == "Name")
    }

    @Test("SortOption should initialize with .popularity case")
    func testPopularityCase() {
        // Act
        let option = SortOption.popularity

        // Assert
        #expect(option == .popularity)
        #expect(option.rawValue == "Popularity")
    }

    @Test("SortOption should initialize with .recent case")
    func testRecentCase() {
        // Act
        let option = SortOption.recent

        // Assert
        #expect(option == .recent)
        #expect(option.rawValue == "Recent")
    }
}

// MARK: - SortOption CaseIterable Tests

@Suite("SortOption CaseIterable Tests")
struct SortOptionCaseIterableTests {

    @Test("SortOption should have exactly 3 cases")
    func testCaseCount() {
        // Act
        let allCases = SortOption.allCases

        // Assert
        #expect(allCases.count == 3)
    }

    @Test("SortOption allCases should contain all expected cases")
    func testAllCasesContent() {
        // Act
        let allCases = SortOption.allCases

        // Assert
        #expect(allCases.contains(.name))
        #expect(allCases.contains(.popularity))
        #expect(allCases.contains(.recent))
    }

    @Test("SortOption allCases should be in expected order")
    func testAllCasesOrder() {
        // Act
        let allCases = SortOption.allCases

        // Assert
        #expect(allCases[0] == .name)
        #expect(allCases[1] == .popularity)
        #expect(allCases[2] == .recent)
    }
}

// MARK: - SortOption RawValue Tests

@Suite("SortOption RawValue Tests")
struct SortOptionRawValueTests {

    @Test("SortOption rawValue should return correct strings")
    func testRawValues() {
        // Assert
        #expect(SortOption.name.rawValue == "Name")
        #expect(SortOption.popularity.rawValue == "Popularity")
        #expect(SortOption.recent.rawValue == "Recent")
    }

    @Test("SortOption should initialize from rawValue")
    func testInitFromRawValue() {
        // Act & Assert
        #expect(SortOption(rawValue: "Name") == .name)
        #expect(SortOption(rawValue: "Popularity") == .popularity)
        #expect(SortOption(rawValue: "Recent") == .recent)
    }

    @Test("SortOption should return nil for invalid rawValue")
    func testInvalidRawValue() {
        // Act & Assert
        #expect(SortOption(rawValue: "Invalid") == nil)
        #expect(SortOption(rawValue: "") == nil)
        #expect(SortOption(rawValue: "name") == nil) // Case sensitive
        #expect(SortOption(rawValue: "POPULARITY") == nil)
    }
}

// MARK: - SortOption Title Tests

@Suite("SortOption Title Tests")
struct SortOptionTitleTests {

    @Test("SortOption title should match rawValue")
    func testTitleMatchesRawValue() {
        // Assert
        for option in SortOption.allCases {
            #expect(option.title == option.rawValue)
        }
    }

    @Test("SortOption title should return correct values")
    func testTitleValues() {
        // Assert
        #expect(SortOption.name.title == "Name")
        #expect(SortOption.popularity.title == "Popularity")
        #expect(SortOption.recent.title == "Recent")
    }
}

// MARK: - SortOption Icon Tests

@Suite("SortOption Icon Tests")
struct SortOptionIconTests {

    @Test("SortOption icons should be unique")
    func testUniqueIcons() {
        // Act
        let icons = SortOption.allCases.map { $0.icon }
        let uniqueIcons = Set(icons)

        // Assert
        #expect(icons.count == uniqueIcons.count)
    }

    @Test("SortOption icons should not be empty")
    func testNonEmptyIcons() {
        // Assert
        for option in SortOption.allCases {
            #expect(!option.icon.isEmpty)
        }
    }

    @Test("SortOption icons should return correct SF Symbols")
    func testCorrectIcons() {
        // Assert
        #expect(SortOption.name.icon == "textformat.abc")
        #expect(SortOption.popularity.icon == "star.fill")
        #expect(SortOption.recent.icon == "clock.fill")
    }

    @Test("SortOption name icon should represent text/alphabetical")
    func testNameIconSemantic() {
        // Act
        let icon = SortOption.name.icon

        // Assert
        #expect(icon.contains("text"))
    }

    @Test("SortOption popularity icon should represent star/rating")
    func testPopularityIconSemantic() {
        // Act
        let icon = SortOption.popularity.icon

        // Assert
        #expect(icon.contains("star"))
    }

    @Test("SortOption recent icon should represent time/clock")
    func testRecentIconSemantic() {
        // Act
        let icon = SortOption.recent.icon

        // Assert
        #expect(icon.contains("clock"))
    }
}

// MARK: - SortOption Identifiable Tests

@Suite("SortOption Identifiable Tests")
struct SortOptionIdentifiableTests {

    @Test("SortOption id should equal rawValue")
    func testIdEqualsRawValue() {
        // Assert
        for option in SortOption.allCases {
            #expect(option.id == option.rawValue)
        }
    }

    @Test("SortOption ids should be unique")
    func testUniqueIds() {
        // Act
        let ids = SortOption.allCases.map { $0.id }
        let uniqueIds = Set(ids)

        // Assert
        #expect(ids.count == uniqueIds.count)
    }

    @Test("SortOption name id should be Name")
    func testNameId() {
        // Act
        let id = SortOption.name.id

        // Assert
        #expect(id == "Name")
    }

    @Test("SortOption popularity id should be Popularity")
    func testPopularityId() {
        // Act
        let id = SortOption.popularity.id

        // Assert
        #expect(id == "Popularity")
    }

    @Test("SortOption recent id should be Recent")
    func testRecentId() {
        // Act
        let id = SortOption.recent.id

        // Assert
        #expect(id == "Recent")
    }
}

// MARK: - SortOption Equatable Tests

@Suite("SortOption Equatable Tests")
struct SortOptionEquatableTests {

    @Test("Same options should be equal")
    func testSameOptionsEqual() {
        // Act & Assert
        #expect(SortOption.name == SortOption.name)
        #expect(SortOption.popularity == SortOption.popularity)
        #expect(SortOption.recent == SortOption.recent)
    }

    @Test("Different options should not be equal")
    func testDifferentOptionsNotEqual() {
        // Act & Assert
        #expect(SortOption.name != SortOption.popularity)
        #expect(SortOption.popularity != SortOption.recent)
        #expect(SortOption.name != SortOption.recent)
    }
}

// MARK: - SortOption Hashable Tests

@Suite("SortOption Hashable Tests")
struct SortOptionHashableTests {

    @Test("SortOption should work in Set")
    func testSetUsage() {
        // Act
        var optionSet: Set<SortOption> = []
        optionSet.insert(.name)
        optionSet.insert(.popularity)
        optionSet.insert(.name) // Duplicate

        // Assert
        #expect(optionSet.count == 2)
        #expect(optionSet.contains(.name))
        #expect(optionSet.contains(.popularity))
    }

    @Test("SortOption should work as Dictionary key")
    func testDictionaryKeyUsage() {
        // Act
        var optionDict: [SortOption: String] = [:]
        optionDict[.name] = "Sort by Name"
        optionDict[.popularity] = "Sort by Popularity"
        optionDict[.recent] = "Sort by Recent"

        // Assert
        #expect(optionDict[.name] == "Sort by Name")
        #expect(optionDict[.popularity] == "Sort by Popularity")
        #expect(optionDict[.recent] == "Sort by Recent")
    }
}

// MARK: - SortOption UI-Related Tests

@Suite("SortOption UI-Related Tests")
struct SortOptionUITests {

    @Test("SortOption should work in ForEach")
    func testForEachUsage() {
        // Act
        var count = 0
        for _ in SortOption.allCases {
            count += 1
        }

        // Assert
        #expect(count == 3)
    }

    @Test("SortOption should have distinct visual identifiers")
    func testDistinctVisualIdentifiers() {
        // Arrange
        let options = SortOption.allCases

        // Act
        for i in 0..<options.count {
            for j in (i+1)..<options.count {
                let option1 = options[i]
                let option2 = options[j]

                // Assert - All identifiers should be different
                #expect(option1.rawValue != option2.rawValue)
                #expect(option1.icon != option2.icon)
                #expect(option1.id != option2.id)
                #expect(option1.title != option2.title)
            }
        }
    }

    @Test("SortOption icons should be semantically appropriate")
    func testIconSemantics() {
        // Assert - Name sort uses text icon
        #expect(SortOption.name.icon.contains("text") || SortOption.name.icon.contains("abc"))

        // Assert - Popularity sort uses star icon
        #expect(SortOption.popularity.icon.contains("star"))

        // Assert - Recent sort uses clock icon
        #expect(SortOption.recent.icon.contains("clock"))
    }
}

// MARK: - XCTest Integration Tests

class SortOptionXCTests: XCTestCase {

    func testAllCasesCount() {
        // Arrange & Act
        let allCases = SortOption.allCases

        // Assert
        XCTAssertEqual(allCases.count, 3)
    }

    func testRawValues() {
        // Assert
        XCTAssertEqual(SortOption.name.rawValue, "Name")
        XCTAssertEqual(SortOption.popularity.rawValue, "Popularity")
        XCTAssertEqual(SortOption.recent.rawValue, "Recent")
    }

    func testInitFromRawValue() {
        // Assert
        XCTAssertEqual(SortOption(rawValue: "Name"), .name)
        XCTAssertEqual(SortOption(rawValue: "Popularity"), .popularity)
        XCTAssertEqual(SortOption(rawValue: "Recent"), .recent)
        XCTAssertNil(SortOption(rawValue: "Invalid"))
    }

    func testTitles() {
        // Assert
        XCTAssertEqual(SortOption.name.title, "Name")
        XCTAssertEqual(SortOption.popularity.title, "Popularity")
        XCTAssertEqual(SortOption.recent.title, "Recent")
    }

    func testIcons() {
        // Assert
        XCTAssertEqual(SortOption.name.icon, "textformat.abc")
        XCTAssertEqual(SortOption.popularity.icon, "star.fill")
        XCTAssertEqual(SortOption.recent.icon, "clock.fill")
    }

    func testIds() {
        // Assert
        XCTAssertEqual(SortOption.name.id, "Name")
        XCTAssertEqual(SortOption.popularity.id, "Popularity")
        XCTAssertEqual(SortOption.recent.id, "Recent")
    }

    func testEquality() {
        // Assert
        XCTAssertEqual(SortOption.name, SortOption.name)
        XCTAssertEqual(SortOption.popularity, SortOption.popularity)
        XCTAssertEqual(SortOption.recent, SortOption.recent)
        XCTAssertNotEqual(SortOption.name, SortOption.popularity)
    }

    func testHashableInSet() {
        // Arrange
        var set: Set<SortOption> = []

        // Act
        set.insert(.name)
        set.insert(.popularity)
        set.insert(.recent)
        set.insert(.name) // Duplicate

        // Assert
        XCTAssertEqual(set.count, 3)
    }

    func testTitleMatchesRawValue() {
        // Assert
        for option in SortOption.allCases {
            XCTAssertEqual(option.title, option.rawValue)
        }
    }

    func testIdMatchesRawValue() {
        // Assert
        for option in SortOption.allCases {
            XCTAssertEqual(option.id, option.rawValue)
        }
    }
}
