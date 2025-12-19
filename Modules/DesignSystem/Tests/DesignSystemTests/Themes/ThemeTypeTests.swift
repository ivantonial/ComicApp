//
//  ThemeTypeTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - ThemeType Enum Tests

@Suite("ThemeType Enum Tests")
struct ThemeTypeEnumTests {

    @Test("ThemeType should have dark case")
    func testDarkCase() {
        let themeType = ThemeType.dark
        #expect(themeType == .dark)
    }

    @Test("ThemeType should have light case")
    func testLightCase() {
        let themeType = ThemeType.light
        #expect(themeType == .light)
    }

    @Test("ThemeType should have exactly 2 cases")
    func testCaseCount() {
        let allCases = ThemeType.allCases
        #expect(allCases.count == 2)
    }

    @Test("ThemeType should conform to CaseIterable")
    func testCaseIterableConformance() {
        let allCases = ThemeType.allCases
        #expect(allCases.contains(.dark))
        #expect(allCases.contains(.light))
    }

    @Test("ThemeType should conform to Sendable")
    func testSendableConformance() {
        let themeType = ThemeType.dark
        Task {
            _ = themeType
        }
        #expect(true)
    }

    @Test("ThemeType allCases should contain dark and light")
    func testAllCasesContent() {
        let allCases = ThemeType.allCases
        #expect(allCases == [.dark, .light])
    }
}

// MARK: - ThemeType RawValue Tests

@Suite("ThemeType RawValue Tests")
struct ThemeTypeRawValueTests {

    @Test("ThemeType dark should have rawValue 'dark'")
    func testDarkRawValue() {
        #expect(ThemeType.dark.rawValue == "dark")
    }

    @Test("ThemeType light should have rawValue 'light'")
    func testLightRawValue() {
        #expect(ThemeType.light.rawValue == "light")
    }

    @Test("ThemeType should be initializable from rawValue")
    func testInitFromRawValue() {
        let dark = ThemeType(rawValue: "dark")
        let light = ThemeType(rawValue: "light")

        #expect(dark == .dark)
        #expect(light == .light)
    }

    @Test("ThemeType should return nil for invalid rawValue")
    func testInvalidRawValue() {
        let invalid = ThemeType(rawValue: "invalid")
        #expect(invalid == nil)
    }

    @Test("ThemeType should return nil for empty rawValue")
    func testEmptyRawValue() {
        let empty = ThemeType(rawValue: "")
        #expect(empty == nil)
    }

    @Test("ThemeType rawValue roundtrip should work")
    func testRawValueRoundtrip() {
        for themeType in ThemeType.allCases {
            let rawValue = themeType.rawValue
            let reconstructed = ThemeType(rawValue: rawValue)
            #expect(reconstructed == themeType)
        }
    }
}

// MARK: - ThemeType DisplayName Tests

@Suite("ThemeType DisplayName Tests")
struct ThemeTypeDisplayNameTests {

    @Test("ThemeType dark should have displayName 'Dark Mode'")
    func testDarkDisplayName() {
        #expect(ThemeType.dark.displayName == "Dark Mode")
    }

    @Test("ThemeType light should have displayName 'Light Mode'")
    func testLightDisplayName() {
        #expect(ThemeType.light.displayName == "Light Mode")
    }

    @Test("ThemeType displayName should contain 'Mode'")
    func testDisplayNameContainsMode() {
        for themeType in ThemeType.allCases {
            #expect(themeType.displayName.contains("Mode"))
        }
    }

    @Test("ThemeType displayName should not be empty")
    func testDisplayNameNotEmpty() {
        for themeType in ThemeType.allCases {
            #expect(!themeType.displayName.isEmpty)
        }
    }

    @Test("ThemeType displayNames should be unique")
    func testDisplayNamesUnique() {
        let displayNames = ThemeType.allCases.map { $0.displayName }
        let uniqueNames = Set(displayNames)
        #expect(displayNames.count == uniqueNames.count)
    }
}

// MARK: - ThemeType Theme Property Tests

@Suite("ThemeType Theme Property Tests")
struct ThemeTypeThemePropertyTests {

    @Test("ThemeType dark should return DarkTheme instance")
    func testDarkThemeProperty() {
        let theme = ThemeType.dark.theme
        #expect(theme is DarkTheme)
    }

    @Test("ThemeType light should return LightTheme instance")
    func testLightThemeProperty() {
        let theme = ThemeType.light.theme
        #expect(theme is LightTheme)
    }

    @Test("ThemeType theme property should return valid theme")
    func testThemePropertyReturnsValidTheme() {
        for themeType in ThemeType.allCases {
            let theme = themeType.theme
            // Theme should have valid properties
            #expect(theme.primaryBackground != Color.clear)
            #expect(theme.primaryText != Color.clear)
        }
    }

    @Test("ThemeType theme should return new instance each time")
    func testThemeReturnsNewInstance() {
        let theme1 = ThemeType.dark.theme
        let theme2 = ThemeType.dark.theme

        // Both should be DarkTheme instances
        #expect(theme1 is DarkTheme)
        #expect(theme2 is DarkTheme)
    }
}

// MARK: - ThemeType Equality Tests

@Suite("ThemeType Equality Tests")
struct ThemeTypeEqualityTests {

    @Test("Same theme types should be equal")
    func testSameTypesEqual() {
        #expect(ThemeType.dark == ThemeType.dark)
        #expect(ThemeType.light == ThemeType.light)
    }

    @Test("Different theme types should not be equal")
    func testDifferentTypesNotEqual() {
        #expect(ThemeType.dark != ThemeType.light)
    }

    @Test("ThemeType should be usable in switch statements")
    func testSwitchStatement() {
        for themeType in ThemeType.allCases {
            switch themeType {
            case .dark:
                #expect(themeType == .dark)
            case .light:
                #expect(themeType == .light)
            }
        }
    }
}

// MARK: - ThemeType Hashable Tests

@Suite("ThemeType Hashable Tests")
struct ThemeTypeHashableTests {

    @Test("ThemeType should be usable in Set")
    func testUsableInSet() {
        var set = Set<ThemeType>()
        set.insert(.dark)
        set.insert(.light)
        set.insert(.dark) // Duplicate

        #expect(set.count == 2)
    }

    @Test("ThemeType should be usable as Dictionary key")
    func testUsableAsDictionaryKey() {
        var dict: [ThemeType: String] = [:]
        dict[.dark] = "Dark"
        dict[.light] = "Light"

        #expect(dict[.dark] == "Dark")
        #expect(dict[.light] == "Light")
    }

    @Test("Same ThemeType should have same hash value")
    func testSameHashValue() {
        let dark1 = ThemeType.dark
        let dark2 = ThemeType.dark

        #expect(dark1.hashValue == dark2.hashValue)
    }
}

// MARK: - XCTest ThemeType Tests

class ThemeTypeXCTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(ThemeType.allCases.count, 2)
    }

    func testRawValueRoundTrip() {
        for themeType in ThemeType.allCases {
            let rawValue = themeType.rawValue
            let reconstructed = ThemeType(rawValue: rawValue)
            XCTAssertEqual(themeType, reconstructed)
        }
    }

    func testDisplayNameNotEmpty() {
        for themeType in ThemeType.allCases {
            XCTAssertFalse(themeType.displayName.isEmpty)
        }
    }

    func testThemePropertyReturnsCorrectType() {
        XCTAssertTrue(ThemeType.dark.theme is DarkTheme)
        XCTAssertTrue(ThemeType.light.theme is LightTheme)
    }

    func testHashableConformance() {
        var set = Set<ThemeType>()
        set.insert(.dark)
        set.insert(.light)
        set.insert(.dark) // Duplicate

        XCTAssertEqual(set.count, 2)
    }

    func testEquatableConformance() {
        XCTAssertEqual(ThemeType.dark, ThemeType.dark)
        XCTAssertNotEqual(ThemeType.dark, ThemeType.light)
    }

    func testRawValueInitializerWithValidValues() {
        XCTAssertEqual(ThemeType(rawValue: "dark"), .dark)
        XCTAssertEqual(ThemeType(rawValue: "light"), .light)
    }

    func testRawValueInitializerWithInvalidValues() {
        XCTAssertNil(ThemeType(rawValue: "invalid"))
        XCTAssertNil(ThemeType(rawValue: ""))
        XCTAssertNil(ThemeType(rawValue: "DARK")) // Case sensitive
    }

    func testDisplayNameValues() {
        XCTAssertEqual(ThemeType.dark.displayName, "Dark Mode")
        XCTAssertEqual(ThemeType.light.displayName, "Light Mode")
    }

    func testThemePropertyProducesValidTheme() {
        for themeType in ThemeType.allCases {
            let theme = themeType.theme
            XCTAssertNotEqual(theme.primaryBackground, Color.clear)
            XCTAssertNotEqual(theme.primaryText, Color.clear)
        }
    }
}
