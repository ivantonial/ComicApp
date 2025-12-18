//
//  SettingsSectionHeaderViewTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import SwiftUI
import Testing

// MARK: - SettingsSectionHeaderView Initialization Tests

@Suite("SettingsSectionHeaderView Initialization Tests")
@MainActor
struct SettingsSectionHeaderViewInitializationTests {

    @Test("Should initialize with all parameters")
    func testFullInitialization() {
        // Act
        let header = SettingsSectionHeaderView(
            title: "Test Title",
            systemImage: "gear",
            color: .blue
        )

        // Assert
        #expect(header.title == "Test Title")
        #expect(header.systemImage == "gear")
        #expect(header.color == .blue)
    }

    @Test("Should initialize with title only")
    func testTitleOnlyInitialization() {
        // Act
        let header = SettingsSectionHeaderView(title: "Test Title")

        // Assert
        #expect(header.title == "Test Title")
        #expect(header.systemImage == nil)
        #expect(header.color == .gray)
    }

    @Test("Should initialize with title and systemImage")
    func testTitleAndImageInitialization() {
        // Act
        let header = SettingsSectionHeaderView(
            title: "Test Title",
            systemImage: "star"
        )

        // Assert
        #expect(header.title == "Test Title")
        #expect(header.systemImage == "star")
        #expect(header.color == .gray)
    }

    @Test("Should initialize with title and color")
    func testTitleAndColorInitialization() {
        // Act
        let header = SettingsSectionHeaderView(
            title: "Test Title",
            color: .red
        )

        // Assert
        #expect(header.title == "Test Title")
        #expect(header.systemImage == nil)
        #expect(header.color == .red)
    }
}

// MARK: - SettingsSectionHeaderView Title Tests

@Suite("SettingsSectionHeaderView Title Tests")
@MainActor
struct SettingsSectionHeaderViewTitleTests {

    @Test("Should store title correctly")
    func testTitleStorage() {
        // Arrange
        let expectedTitle = "General Settings"

        // Act
        let header = SettingsSectionHeaderView(title: expectedTitle)

        // Assert
        #expect(header.title == expectedTitle)
    }

    @Test("Should handle empty title")
    func testEmptyTitle() {
        // Act
        let header = SettingsSectionHeaderView(title: "")

        // Assert
        #expect(header.title == "")
    }

    @Test("Should handle long title")
    func testLongTitle() {
        // Arrange
        let longTitle = "This is a very long section title that might wrap to multiple lines"

        // Act
        let header = SettingsSectionHeaderView(title: longTitle)

        // Assert
        #expect(header.title == longTitle)
    }

    @Test("Should handle special characters in title")
    func testSpecialCharactersInTitle() {
        // Arrange
        let specialTitle = "Settings & Options - v1.0"

        // Act
        let header = SettingsSectionHeaderView(title: specialTitle)

        // Assert
        #expect(header.title == specialTitle)
    }
}

// MARK: - SettingsSectionHeaderView SystemImage Tests

@Suite("SettingsSectionHeaderView SystemImage Tests")
@MainActor
struct SettingsSectionHeaderViewSystemImageTests {

    @Test("Should store systemImage correctly")
    func testSystemImageStorage() {
        // Arrange
        let expectedImage = "gearshape.fill"

        // Act
        let header = SettingsSectionHeaderView(
            title: "Test",
            systemImage: expectedImage
        )

        // Assert
        #expect(header.systemImage == expectedImage)
    }

    @Test("Should handle nil systemImage")
    func testNilSystemImage() {
        // Act
        let header = SettingsSectionHeaderView(title: "Test")

        // Assert
        #expect(header.systemImage == nil)
    }

    @Test("Should accept various SF Symbol names")
    func testVariousSFSymbols() {
        // Arrange
        let symbols = ["star", "heart.fill", "person.circle", "bell.badge"]

        // Act & Assert
        for symbol in symbols {
            let header = SettingsSectionHeaderView(title: "Test", systemImage: symbol)
            #expect(header.systemImage == symbol)
        }
    }
}

// MARK: - SettingsSectionHeaderView Color Tests

@Suite("SettingsSectionHeaderView Color Tests")
@MainActor
struct SettingsSectionHeaderViewColorTests {

    @Test("Default color should be gray")
    func testDefaultColor() {
        // Act
        let header = SettingsSectionHeaderView(title: "Test")

        // Assert
        #expect(header.color == .gray)
    }

    @Test("Should accept custom color")
    func testCustomColor() {
        // Act
        let header = SettingsSectionHeaderView(
            title: "Test",
            color: .purple
        )

        // Assert
        #expect(header.color == .purple)
    }

    @Test("Should accept various colors")
    func testVariousColors() {
        // Arrange
        let colors: [Color] = [.red, .blue, .green, .orange, .pink, .yellow]

        // Act & Assert
        for color in colors {
            let header = SettingsSectionHeaderView(title: "Test", color: color)
            #expect(header.color == color)
        }
    }

    @Test("Should accept secondary color")
    func testSecondaryColor() {
        // Act
        let header = SettingsSectionHeaderView(
            title: "Test",
            color: .secondary
        )

        // Assert
        #expect(header.color == .secondary)
    }
}

// MARK: - SettingsSectionHeaderView View Body Tests

@Suite("SettingsSectionHeaderView View Body Tests")
@MainActor
struct SettingsSectionHeaderViewBodyTests {

    @Test("Body should be accessible")
    func testBodyAccessible() {
        // Arrange
        let header = SettingsSectionHeaderView(
            title: "Test",
            systemImage: "gear",
            color: .blue
        )

        // Act & Assert - O body deve ser acessível sem crash
        _ = header.body
        #expect(true)
    }

    @Test("Body should render without systemImage")
    func testBodyWithoutImage() {
        // Arrange
        let header = SettingsSectionHeaderView(title: "Test")

        // Act & Assert - O body deve ser acessível sem crash
        _ = header.body
        #expect(true)
    }
}

// MARK: - SettingsSectionHeaderView Usage Pattern Tests

@Suite("SettingsSectionHeaderView Usage Pattern Tests")
@MainActor
struct SettingsSectionHeaderViewUsageTests {

    @Test("Should work as Section header")
    func testAsSectionHeader() {
        // Arrange - Simula uso típico no SettingsView
        let generalHeader = SettingsSectionHeaderView(
            title: "General",
            systemImage: "gearshape.fill",
            color: .secondary
        )

        // Assert
        #expect(generalHeader.title == "General")
        #expect(generalHeader.systemImage == "gearshape.fill")
    }

    @Test("Should match SettingsView usage patterns")
    func testSettingsViewPatterns() {
        // Arrange - Headers típicos do SettingsView
        let headers = [
            SettingsSectionHeaderView(title: "General", systemImage: "gearshape.fill", color: .secondary),
            SettingsSectionHeaderView(title: "Display", systemImage: "display", color: .secondary),
            SettingsSectionHeaderView(title: "Data & Storage", systemImage: "externaldrive", color: .secondary),
            SettingsSectionHeaderView(title: "About", systemImage: "info.circle", color: .secondary),
            SettingsSectionHeaderView(title: "Support", systemImage: "questionmark.circle", color: .secondary),
            SettingsSectionHeaderView(title: "Legal", systemImage: "doc.text", color: .secondary)
        ]

        // Assert
        #expect(headers.count == 6)
        for header in headers {
            #expect(!header.title.isEmpty)
            #expect(header.systemImage != nil)
            #expect(header.color == .secondary)
        }
    }
}

// MARK: - SettingsSectionHeaderView Property Tests

@Suite("SettingsSectionHeaderView Property Tests")
@MainActor
struct SettingsSectionHeaderViewPropertyTests {

    @Test("Two headers with same properties should have same values")
    func testSameProperties() {
        // Arrange
        let header1 = SettingsSectionHeaderView(
            title: "Test",
            systemImage: "gear",
            color: .blue
        )
        let header2 = SettingsSectionHeaderView(
            title: "Test",
            systemImage: "gear",
            color: .blue
        )

        // Assert
        #expect(header1.title == header2.title)
        #expect(header1.systemImage == header2.systemImage)
        #expect(header1.color == header2.color)
    }

    @Test("Two headers with different properties should have different values")
    func testDifferentProperties() {
        // Arrange
        let header1 = SettingsSectionHeaderView(
            title: "General",
            systemImage: "gear",
            color: .blue
        )
        let header2 = SettingsSectionHeaderView(
            title: "Display",
            systemImage: "display",
            color: .red
        )

        // Assert
        #expect(header1.title != header2.title)
        #expect(header1.systemImage != header2.systemImage)
        #expect(header1.color != header2.color)
    }
}
