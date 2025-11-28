//
//  AppTabTests.swift
//  AppCoordinator
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import AppCoordinator
import Testing

// MARK: - AppTab Tests

@Suite("AppTab Tests")
struct AppTabTests {

    // MARK: - Raw Value Tests

    @Test("AppTab should have correct raw values")
    func testRawValues() {
        // Assert
        #expect(AppTab.characters.rawValue == "Characters")
        #expect(AppTab.search.rawValue == "Search")
        #expect(AppTab.favorites.rawValue == "Favorites")
        #expect(AppTab.settings.rawValue == "Settings")
    }

    // MARK: - Icon Tests

    @Test("AppTab should have correct icons")
    func testIcons() {
        // Assert
        #expect(AppTab.characters.icon == "person.3.fill")
        #expect(AppTab.search.icon == "magnifyingglass")
        #expect(AppTab.favorites.icon == "star.fill")
        #expect(AppTab.settings.icon == "gearshape.fill")
    }

    @Test("AppTab icons should be SF Symbols compatible")
    func testIconsAreSFSymbols() {
        // Arrange
        let validSFSymbolPatterns = ["person", "magnifyingglass", "star", "gearshape"]

        // Act & Assert
        for tab in AppTab.allCases {
            let iconContainsValidPattern = validSFSymbolPatterns.contains { tab.icon.contains($0) }
            #expect(iconContainsValidPattern, "Icon '\(tab.icon)' should be a valid SF Symbol")
        }
    }

    // MARK: - CaseIterable Tests

    @Test("AppTab.allCases should contain all tabs")
    func testAllCases() {
        // Arrange
        let allCases = AppTab.allCases

        // Assert
        #expect(allCases.count == 4)
        #expect(allCases.contains(.characters))
        #expect(allCases.contains(.search))
        #expect(allCases.contains(.favorites))
        #expect(allCases.contains(.settings))
    }

    @Test("AppTab.allCases should have correct order")
    func testAllCasesOrder() {
        // Arrange
        let allCases = Array(AppTab.allCases)

        // Assert
        #expect(allCases[0] == .characters)
        #expect(allCases[1] == .search)
        #expect(allCases[2] == .favorites)
        #expect(allCases[3] == .settings)
    }

    // MARK: - Equality Tests

    @Test("AppTab equality should work correctly")
    func testEquality() {
        // Assert
        #expect(AppTab.characters == AppTab.characters)
        #expect(AppTab.search == AppTab.search)
        #expect(AppTab.characters != AppTab.search)
        #expect(AppTab.favorites != AppTab.settings)
    }

    // MARK: - Hashable Tests

    @Test("AppTab should be hashable")
    func testHashable() {
        // Arrange
        var tabSet: Set<AppTab> = []

        // Act
        tabSet.insert(.characters)
        tabSet.insert(.search)
        tabSet.insert(.favorites)
        tabSet.insert(.settings)
        tabSet.insert(.characters) // Duplicata

        // Assert
        #expect(tabSet.count == 4)
    }

    @Test("Same AppTab should have same hash value")
    func testHashConsistency() {
        // Assert
        #expect(AppTab.characters.hashValue == AppTab.characters.hashValue)
        #expect(AppTab.search.hashValue == AppTab.search.hashValue)
    }

    // MARK: - Switch Coverage Tests

    @Test("AppTab switch should cover all cases")
    func testSwitchCoverage() {
        // Arrange
        var iconNames: [String] = []

        // Act
        for tab in AppTab.allCases {
            switch tab {
            case .characters:
                iconNames.append("characters")
            case .search:
                iconNames.append("search")
            case .favorites:
                iconNames.append("favorites")
            case .settings:
                iconNames.append("settings")
            }
        }

        // Assert
        #expect(iconNames.count == 4)
        #expect(iconNames.contains("characters"))
        #expect(iconNames.contains("search"))
        #expect(iconNames.contains("favorites"))
        #expect(iconNames.contains("settings"))
    }
}

// MARK: - AppTab Default Value Tests

@Suite("AppTab Default Value Tests")
struct AppTabDefaultValueTests {

    @Test("Characters should be the first tab")
    func testCharactersIsFirst() {
        // Arrange
        let firstTab = AppTab.allCases.first

        // Assert
        #expect(firstTab == .characters)
    }

    @Test("Settings should be the last tab")
    func testSettingsIsLast() {
        // Arrange
        let lastTab = AppTab.allCases.last

        // Assert
        #expect(lastTab == .settings)
    }
}
