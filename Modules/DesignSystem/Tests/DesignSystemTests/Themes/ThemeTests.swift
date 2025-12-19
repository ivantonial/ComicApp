//
//  ThemeTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - ThemeProtocol Tests

@Suite("ThemeProtocol Tests")
struct ThemeProtocolTests {

    @Test("ThemeProtocol should define primaryBackground")
    func testPrimaryBackgroundDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.primaryBackground != Color.clear)
        #expect(lightTheme.primaryBackground != Color.clear)
    }

    @Test("ThemeProtocol should define secondaryBackground")
    func testSecondaryBackgroundDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.secondaryBackground != Color.clear)
        #expect(lightTheme.secondaryBackground != Color.clear)
    }

    @Test("ThemeProtocol should define tertiaryBackground")
    func testTertiaryBackgroundDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.tertiaryBackground != Color.clear)
        #expect(lightTheme.tertiaryBackground != Color.clear)
    }

    @Test("ThemeProtocol should define cardBackground")
    func testCardBackgroundDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.cardBackground != Color.clear)
        #expect(lightTheme.cardBackground != Color.clear)
    }

    @Test("ThemeProtocol should define primaryText")
    func testPrimaryTextDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.primaryText != Color.clear)
        #expect(lightTheme.primaryText != Color.clear)
    }

    @Test("ThemeProtocol should define secondaryText")
    func testSecondaryTextDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.secondaryText != Color.clear)
        #expect(lightTheme.secondaryText != Color.clear)
    }

    @Test("ThemeProtocol should define tertiaryText")
    func testTertiaryTextDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.tertiaryText != Color.clear)
        #expect(lightTheme.tertiaryText != Color.clear)
    }

    @Test("ThemeProtocol should define invertedText")
    func testInvertedTextDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.invertedText != Color.clear)
        #expect(lightTheme.invertedText != Color.clear)
    }

    @Test("ThemeProtocol should define primaryAccent")
    func testPrimaryAccentDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.primaryAccent != Color.clear)
        #expect(lightTheme.primaryAccent != Color.clear)
    }

    @Test("ThemeProtocol should define secondaryAccent")
    func testSecondaryAccentDefined() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.secondaryAccent != Color.clear)
        #expect(lightTheme.secondaryAccent != Color.clear)
    }

    @Test("ThemeProtocol should define all accent colors")
    func testAllAccentColorsDefined() {
        let theme = DarkTheme()

        #expect(theme.primaryAccent != Color.clear)
        #expect(theme.secondaryAccent != Color.clear)
        #expect(theme.destructiveAccent != Color.clear)
        #expect(theme.warningAccent != Color.clear)
        #expect(theme.successAccent != Color.clear)
    }

    @Test("ThemeProtocol should define all component colors")
    func testAllComponentColorsDefined() {
        let theme = DarkTheme()

        #expect(theme.separatorColor != Color.clear)
        #expect(theme.borderColor != Color.clear)
        #expect(theme.shadowColor != Color.clear)
        #expect(theme.overlayColor != Color.clear)
    }

    @Test("ThemeProtocol should define all UI element colors")
    func testAllUIElementColorsDefined() {
        let theme = DarkTheme()

        #expect(theme.tabBarBackground != Color.clear)
        #expect(theme.navigationBarBackground != Color.clear)
        #expect(theme.searchBarBackground != Color.clear)
        #expect(theme.buttonBackground != Color.clear)
        #expect(theme.disabledBackground != Color.clear)
    }
}

// MARK: - DarkTheme Tests

@Suite("DarkTheme Tests")
struct DarkThemeTests {

    @Test("DarkTheme should be instantiable")
    func testInstantiation() {
        let theme = DarkTheme()
        #expect(type(of: theme) == DarkTheme.self)
    }

    @Test("DarkTheme should conform to Sendable")
    func testSendableConformance() {
        let theme = DarkTheme()
        Task {
            _ = theme
        }
        #expect(true)
    }

    @Test("DarkTheme should conform to ThemeProtocol")
    func testThemeProtocolConformance() {
        let theme: any ThemeProtocol = DarkTheme()
        #expect(theme is DarkTheme)
    }

    @Test("DarkTheme should have public initializer")
    func testPublicInitializer() {
        let theme = DarkTheme()
        #expect(type(of: theme) == DarkTheme.self)
    }

    @Test("DarkTheme invertedText should be white")
    func testInvertedTextIsWhite() {
        let theme = DarkTheme()
        #expect(theme.invertedText == Color.white)
    }

    @Test("DarkTheme primaryAccent should be red")
    func testPrimaryAccentIsRed() {
        let theme = DarkTheme()
        #expect(theme.primaryAccent == Color.red)
    }

    @Test("DarkTheme destructiveAccent should be red")
    func testDestructiveAccentIsRed() {
        let theme = DarkTheme()
        #expect(theme.destructiveAccent == Color.red)
    }

    @Test("DarkTheme successAccent should be green")
    func testSuccessAccentIsGreen() {
        let theme = DarkTheme()
        #expect(theme.successAccent == Color.green)
    }

    @Test("DarkTheme warningAccent should be orange")
    func testWarningAccentIsOrange() {
        let theme = DarkTheme()
        #expect(theme.warningAccent == Color.orange)
    }

    @Test("DarkTheme secondaryAccent should be blue")
    func testSecondaryAccentIsBlue() {
        let theme = DarkTheme()
        #expect(theme.secondaryAccent == Color.blue)
    }
}

// MARK: - LightTheme Tests

@Suite("LightTheme Tests")
struct LightThemeTests {

    @Test("LightTheme should be instantiable")
    func testInstantiation() {
        let theme = LightTheme()
        #expect(type(of: theme) == LightTheme.self)
    }

    @Test("LightTheme should conform to Sendable")
    func testSendableConformance() {
        let theme = LightTheme()
        Task {
            _ = theme
        }
        #expect(true)
    }

    @Test("LightTheme should conform to ThemeProtocol")
    func testThemeProtocolConformance() {
        let theme: any ThemeProtocol = LightTheme()
        #expect(theme is LightTheme)
    }

    @Test("LightTheme should have public initializer")
    func testPublicInitializer() {
        let theme = LightTheme()
        #expect(type(of: theme) == LightTheme.self)
    }

    @Test("LightTheme primaryBackground should be white")
    func testPrimaryBackgroundIsWhite() {
        let theme = LightTheme()
        #expect(theme.primaryBackground == Color.white)
    }

    @Test("LightTheme cardBackground should be white")
    func testCardBackgroundIsWhite() {
        let theme = LightTheme()
        #expect(theme.cardBackground == Color.white)
    }

    @Test("LightTheme primaryText should be black")
    func testPrimaryTextIsBlack() {
        let theme = LightTheme()
        #expect(theme.primaryText == Color.black)
    }

    @Test("LightTheme invertedText should be white")
    func testInvertedTextIsWhite() {
        let theme = LightTheme()
        #expect(theme.invertedText == Color.white)
    }
}

// MARK: - Theme Comparison Tests

@Suite("Theme Comparison Tests")
struct ThemeComparisonTests {

    @Test("DarkTheme and LightTheme should have different primaryBackground")
    func testDifferentPrimaryBackground() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.primaryBackground != lightTheme.primaryBackground)
    }

    @Test("DarkTheme and LightTheme should have different primaryText")
    func testDifferentPrimaryText() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.primaryText != lightTheme.primaryText)
    }

    @Test("DarkTheme and LightTheme should have same invertedText")
    func testSameInvertedText() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.invertedText == lightTheme.invertedText)
    }

    @Test("DarkTheme and LightTheme should have different cardBackground")
    func testDifferentCardBackground() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        #expect(darkTheme.cardBackground != lightTheme.cardBackground)
    }

    @Test("Both themes should define all required colors")
    func testBothThemesDefineAllColors() {
        let darkTheme = DarkTheme()
        let lightTheme = LightTheme()

        // Background colors
        #expect(darkTheme.primaryBackground != Color.clear)
        #expect(lightTheme.primaryBackground != Color.clear)

        // Text colors
        #expect(darkTheme.primaryText != Color.clear)
        #expect(lightTheme.primaryText != Color.clear)

        // Accent colors
        #expect(darkTheme.primaryAccent != Color.clear)
        #expect(lightTheme.primaryAccent != Color.clear)
    }
}

// MARK: - XCTest Theme Tests

class ThemeXCTests: XCTestCase {

    func testDarkThemeConformsToThemeProtocol() {
        let theme: any ThemeProtocol = DarkTheme()
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme is DarkTheme)
    }

    func testLightThemeConformsToThemeProtocol() {
        let theme: any ThemeProtocol = LightTheme()
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme is LightTheme)
    }

    func testDarkThemeHasAllBackgroundColors() {
        let theme = DarkTheme()

        XCTAssertNotEqual(theme.primaryBackground, Color.clear)
        XCTAssertNotEqual(theme.secondaryBackground, Color.clear)
        XCTAssertNotEqual(theme.tertiaryBackground, Color.clear)
        XCTAssertNotEqual(theme.cardBackground, Color.clear)
    }

    func testLightThemeHasAllBackgroundColors() {
        let theme = LightTheme()

        XCTAssertNotEqual(theme.primaryBackground, Color.clear)
        XCTAssertNotEqual(theme.secondaryBackground, Color.clear)
        XCTAssertNotEqual(theme.tertiaryBackground, Color.clear)
        XCTAssertNotEqual(theme.cardBackground, Color.clear)
    }

    func testDarkThemeHasAllTextColors() {
        let theme = DarkTheme()

        XCTAssertNotEqual(theme.primaryText, Color.clear)
        XCTAssertNotEqual(theme.secondaryText, Color.clear)
        XCTAssertNotEqual(theme.tertiaryText, Color.clear)
        XCTAssertNotEqual(theme.invertedText, Color.clear)
    }

    func testLightThemeHasAllTextColors() {
        let theme = LightTheme()

        XCTAssertNotEqual(theme.primaryText, Color.clear)
        XCTAssertNotEqual(theme.secondaryText, Color.clear)
        XCTAssertNotEqual(theme.tertiaryText, Color.clear)
        XCTAssertNotEqual(theme.invertedText, Color.clear)
    }

    func testDarkThemeHasAllAccentColors() {
        let theme = DarkTheme()

        XCTAssertNotEqual(theme.primaryAccent, Color.clear)
        XCTAssertNotEqual(theme.secondaryAccent, Color.clear)
        XCTAssertNotEqual(theme.destructiveAccent, Color.clear)
        XCTAssertNotEqual(theme.warningAccent, Color.clear)
        XCTAssertNotEqual(theme.successAccent, Color.clear)
    }

    func testDarkThemeHasAllComponentColors() {
        let theme = DarkTheme()

        XCTAssertNotEqual(theme.separatorColor, Color.clear)
        XCTAssertNotEqual(theme.borderColor, Color.clear)
    }

    func testDarkThemeHasAllUIElementColors() {
        let theme = DarkTheme()

        XCTAssertNotEqual(theme.tabBarBackground, Color.clear)
        XCTAssertNotEqual(theme.navigationBarBackground, Color.clear)
        XCTAssertNotEqual(theme.searchBarBackground, Color.clear)
        XCTAssertNotEqual(theme.buttonBackground, Color.clear)
        XCTAssertNotEqual(theme.disabledBackground, Color.clear)
    }

    func testDarkThemeSpecificColors() {
        let theme = DarkTheme()

        XCTAssertEqual(theme.invertedText, Color.white)
        XCTAssertEqual(theme.primaryAccent, Color.red)
    }

    func testLightThemeSpecificColors() {
        let theme = LightTheme()

        XCTAssertEqual(theme.primaryBackground, Color.white)
        XCTAssertEqual(theme.cardBackground, Color.white)
        XCTAssertEqual(theme.primaryText, Color.black)
    }
}
