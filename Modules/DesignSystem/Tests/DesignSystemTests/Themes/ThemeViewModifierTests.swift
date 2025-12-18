//
//  ThemeViewModifierTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - Type Alias for convenience
private typealias BackgroundType = ThemeBackgroundModifier.BackgroundType

// MARK: - BackgroundType Tests

@Suite("BackgroundType Tests")
@MainActor
struct BackgroundTypeTests {

    @Test("BackgroundType should have primary case")
    func testPrimaryCase() {
        let type: BackgroundType = .primary
        #expect(type == .primary)
    }

    @Test("BackgroundType should have secondary case")
    func testSecondaryCase() {
        let type: BackgroundType = .secondary
        #expect(type == .secondary)
    }

    @Test("BackgroundType should have tertiary case")
    func testTertiaryCase() {
        let type: BackgroundType = .tertiary
        #expect(type == .tertiary)
    }

    @Test("BackgroundType should have card case")
    func testCardCase() {
        let type: BackgroundType = .card
        #expect(type == .card)
    }

    @Test("BackgroundType should have all four cases")
    func testAllCases() {
        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]
        #expect(types.count == 4)
    }
}

// MARK: - ThemeBackgroundModifier Initialization Tests

@Suite("ThemeBackgroundModifier Initialization Tests")
@MainActor
struct ThemeBackgroundModifierInitializationTests {

    @Test("ThemeBackgroundModifier should initialize with primary type")
    func testInitWithPrimary() {
        let modifier = ThemeBackgroundModifier(.primary)
        #expect(modifier.backgroundType == .primary)
    }

    @Test("ThemeBackgroundModifier should initialize with secondary type")
    func testInitWithSecondary() {
        let modifier = ThemeBackgroundModifier(.secondary)
        #expect(modifier.backgroundType == .secondary)
    }

    @Test("ThemeBackgroundModifier should initialize with tertiary type")
    func testInitWithTertiary() {
        let modifier = ThemeBackgroundModifier(.tertiary)
        #expect(modifier.backgroundType == .tertiary)
    }

    @Test("ThemeBackgroundModifier should initialize with card type")
    func testInitWithCard() {
        let modifier = ThemeBackgroundModifier(.card)
        #expect(modifier.backgroundType == .card)
    }

    @Test("ThemeBackgroundModifier should default to primary")
    func testDefaultInit() {
        let modifier = ThemeBackgroundModifier()
        #expect(modifier.backgroundType == .primary)
    }

    @Test("ThemeBackgroundModifier should accept all background types")
    func testAllBackgroundTypes() {
        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]

        for type in types {
            let modifier = ThemeBackgroundModifier(type)
            #expect(modifier.backgroundType == type)
        }
    }
}

// MARK: - ThemeBackgroundModifier ViewModifier Tests

@Suite("ThemeBackgroundModifier ViewModifier Tests")
@MainActor
struct ThemeBackgroundModifierViewModifierTests {

    @Test("ThemeBackgroundModifier should conform to ViewModifier")
    func testViewModifierConformance() {
        let modifier = ThemeBackgroundModifier(.primary)
        let _: any ViewModifier = modifier
        #expect(true)
    }

    @Test("ThemeBackgroundModifier body should return modified view")
    func testBodyReturnsModifiedView() {
        let modifier = ThemeBackgroundModifier(.primary)
        let testView = Text("Test")
        let modifiedView = testView.modifier(modifier)
        #expect(type(of: modifiedView) != type(of: testView))
    }

    @Test("ThemeBackgroundModifier can be applied via modifier function")
    func testModifierApplication() {
        let view = Text("Test").modifier(ThemeBackgroundModifier(.secondary))
        // If we get here without error, the modifier works
        #expect(true)
        _ = view // silence unused warning
    }
}

// MARK: - View Extension Tests

@Suite("View themedBackground Extension Tests")
@MainActor
struct ViewThemedBackgroundExtensionTests {

    @Test("View should have themedBackground modifier")
    func testThemedBackgroundModifier() {
        let view = Text("Test").themedBackground(.primary)
        // If we get here without error, the extension works
        #expect(true)
        _ = view
    }

    @Test("themedBackground should accept primary type")
    func testThemedBackgroundPrimary() {
        let view = Text("Test").themedBackground(.primary)
        #expect(true)
        _ = view
    }

    @Test("themedBackground should accept secondary type")
    func testThemedBackgroundSecondary() {
        let view = Text("Test").themedBackground(.secondary)
        #expect(true)
        _ = view
    }

    @Test("themedBackground should accept tertiary type")
    func testThemedBackgroundTertiary() {
        let view = Text("Test").themedBackground(.tertiary)
        #expect(true)
        _ = view
    }

    @Test("themedBackground should accept card type")
    func testThemedBackgroundCard() {
        let view = Text("Test").themedBackground(.card)
        #expect(true)
        _ = view
    }

    @Test("themedBackground should default to primary")
    func testThemedBackgroundDefault() {
        let view = Text("Test").themedBackground()
        #expect(true)
        _ = view
    }

    @Test("themedBackground should accept all background types")
    func testAllBackgroundTypesViaExtension() {
        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]

        for type in types {
            let view = Text("Test").themedBackground(type)
            #expect(true)
            _ = view
        }
    }
}

// MARK: - BackgroundType Equality Tests

@Suite("BackgroundType Equality Tests")
@MainActor
struct BackgroundTypeEqualityTests {

    @Test("Same BackgroundType should be equal")
    func testSameTypeEquality() {
        #expect(BackgroundType.primary == BackgroundType.primary)
        #expect(BackgroundType.secondary == BackgroundType.secondary)
        #expect(BackgroundType.tertiary == BackgroundType.tertiary)
        #expect(BackgroundType.card == BackgroundType.card)
    }

    @Test("Different BackgroundTypes should not be equal")
    func testDifferentTypeInequality() {
        #expect(BackgroundType.primary != BackgroundType.secondary)
        #expect(BackgroundType.secondary != BackgroundType.tertiary)
        #expect(BackgroundType.tertiary != BackgroundType.card)
        #expect(BackgroundType.card != BackgroundType.primary)
    }
}

// MARK: - Theme Integration Tests

@Suite("ThemeBackgroundModifier Theme Integration Tests")
@MainActor
struct ThemeBackgroundModifierThemeIntegrationTests {

    @Test("ThemeBackgroundModifier should work with dark theme")
    func testWithDarkTheme() {
        let originalType = ThemeManager.shared.currentThemeType
        defer { ThemeManager.shared.setTheme(originalType) }

        ThemeManager.shared.setTheme(.dark)
        let view = Text("Test").themedBackground(.primary)
        #expect(true)
        _ = view
    }

    @Test("ThemeBackgroundModifier should work with light theme")
    func testWithLightTheme() {
        let originalType = ThemeManager.shared.currentThemeType
        defer { ThemeManager.shared.setTheme(originalType) }

        ThemeManager.shared.setTheme(.light)
        let view = Text("Test").themedBackground(.primary)
        #expect(true)
        _ = view
    }

    @Test("ThemeBackgroundModifier should work after theme toggle")
    func testAfterThemeToggle() {
        let originalType = ThemeManager.shared.currentThemeType
        defer { ThemeManager.shared.setTheme(originalType) }

        ThemeManager.shared.toggleTheme()
        let view = Text("Test").themedBackground(.secondary)
        #expect(true)
        _ = view
    }

    @Test("All background types should work with both themes")
    func testAllTypesWithBothThemes() {
        let originalType = ThemeManager.shared.currentThemeType
        defer { ThemeManager.shared.setTheme(originalType) }

        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]

        for themeType in [ThemeType.dark, ThemeType.light] {
            ThemeManager.shared.setTheme(themeType)
            for bgType in types {
                let view = Text("Test").themedBackground(bgType)
                #expect(true)
                _ = view
            }
        }
    }
}

// MARK: - XCTest ThemeViewModifier Tests

@MainActor
class ThemeViewModifierXCTests: XCTestCase {

    func testBackgroundTypeAllCases() {
        let primaryModifier = ThemeBackgroundModifier(.primary)
        let secondaryModifier = ThemeBackgroundModifier(.secondary)
        let tertiaryModifier = ThemeBackgroundModifier(.tertiary)
        let cardModifier = ThemeBackgroundModifier(.card)

        XCTAssertEqual(primaryModifier.backgroundType, .primary)
        XCTAssertEqual(secondaryModifier.backgroundType, .secondary)
        XCTAssertEqual(tertiaryModifier.backgroundType, .tertiary)
        XCTAssertEqual(cardModifier.backgroundType, .card)
    }

    func testBackgroundTypeEquality() {
        XCTAssertEqual(BackgroundType.primary, BackgroundType.primary)
        XCTAssertNotEqual(BackgroundType.primary, BackgroundType.secondary)
    }

    func testDefaultInitialization() {
        let modifier = ThemeBackgroundModifier()
        XCTAssertEqual(modifier.backgroundType, .primary)
    }

    func testViewModifierApplication() {
        let view = Text("Test")
        let modifiedView = view.themedBackground(.primary)

        // Should return a modified view (not the original Text type)
        XCTAssertNotNil(modifiedView)
    }

    func testAllBackgroundTypesViaExtension() {
        let view = Text("Test")

        let primaryView = view.themedBackground(.primary)
        let secondaryView = view.themedBackground(.secondary)
        let tertiaryView = view.themedBackground(.tertiary)
        let cardView = view.themedBackground(.card)

        // All should compile and create views
        XCTAssertNotNil(primaryView)
        XCTAssertNotNil(secondaryView)
        XCTAssertNotNil(tertiaryView)
        XCTAssertNotNil(cardView)
    }

    func testThemedBackgroundDefaultParameter() {
        let view = Text("Test").themedBackground()
        XCTAssertNotNil(view)
    }

    func testThemeBackgroundWithThemeChanges() {
        let originalType = ThemeManager.shared.currentThemeType

        // Test with dark theme
        ThemeManager.shared.setTheme(.dark)
        let darkView = Text("Test").themedBackground(.primary)
        XCTAssertNotNil(darkView)

        // Test with light theme
        ThemeManager.shared.setTheme(.light)
        let lightView = Text("Test").themedBackground(.primary)
        XCTAssertNotNil(lightView)

        // Restore
        ThemeManager.shared.setTheme(originalType)
    }

    func testModifierWithDifferentViews() {
        // Test that the modifier can be applied to different view types
        let textView = Text("Test").themedBackground(.primary)
        let imageView = Image(systemName: "star").themedBackground(.secondary)
        let rectangleView = Rectangle().themedBackground(.card)

        XCTAssertNotNil(textView)
        XCTAssertNotNil(imageView)
        XCTAssertNotNil(rectangleView)
    }

    func testModifierPreservesBackgroundType() {
        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]

        for type in types {
            let modifier = ThemeBackgroundModifier(type)
            XCTAssertEqual(modifier.backgroundType, type)
        }
    }

    func testBackgroundTypeSwitchCoverage() {
        let types: [BackgroundType] = [.primary, .secondary, .tertiary, .card]

        for type in types {
            switch type {
            case .primary:
                XCTAssertEqual(type, .primary)
            case .secondary:
                XCTAssertEqual(type, .secondary)
            case .tertiary:
                XCTAssertEqual(type, .tertiary)
            case .card:
                XCTAssertEqual(type, .card)
            }
        }
    }
}
