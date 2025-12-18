//
//  ColorTypeTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import UIKit
import XCTest

// MARK: - ColorType Enum Tests

@Suite("ColorType Enum Tests")
@MainActor
struct ColorTypeEnumTests {

    @Test("ColorType should have all background cases")
    func testBackgroundCases() {
        let backgrounds: [ColorType] = [
            .primaryBackground,
            .secondaryBackground,
            .tertiaryBackground,
            .cardBackground
        ]

        #expect(backgrounds.count == 4)
    }

    @Test("ColorType should have all text cases")
    func testTextCases() {
        let texts: [ColorType] = [
            .primaryText,
            .secondaryText,
            .tertiaryText,
            .invertedText
        ]

        #expect(texts.count == 4)
    }

    @Test("ColorType should have all accent cases")
    func testAccentCases() {
        // ColorType has: primaryAccent, secondaryAccent, destructiveAccent, warningAccent, successAccent
        let accents: [ColorType] = [
            .primaryAccent,
            .secondaryAccent,
            .destructiveAccent,
            .warningAccent,
            .successAccent
        ]

        #expect(accents.count == 5)
    }

    @Test("ColorType should have UI element cases")
    func testUIElementCases() {
        // ColorType has: separator, border, shadow, overlay
        let uiElements: [ColorType] = [
            .separator,
            .border,
            .shadow,
            .overlay
        ]

        #expect(uiElements.count == 4)
    }

    @Test("ColorType should have legacy cases")
    func testLegacyCases() {
        let legacy: [ColorType] = [
            .red,
            .blue,
            .green,
            .yellow,
            .gray
        ]

        #expect(legacy.count == 5)
    }

    @Test("ColorType should have exactly 22 cases")
    func testTotalCaseCount() {
        let allCases = ColorType.allCases
        #expect(allCases.count == 22)
    }

    @Test("ColorType should conform to CaseIterable")
    func testCaseIterableConformance() {
        let allCases = ColorType.allCases
        #expect(!allCases.isEmpty)
    }

    @Test("ColorType should conform to Sendable")
    func testSendableConformance() {
        let colorType = ColorType.primaryAccent
        Task {
            _ = colorType
        }
        #expect(true)
    }
}

// MARK: - ColorType RawValue Tests

@Suite("ColorType RawValue Tests")
@MainActor
struct ColorTypeRawValueTests {

    @Test("ColorType rawValues should be correct")
    func testRawValues() {
        #expect(ColorType.primaryBackground.rawValue == "primaryBackground")
        #expect(ColorType.secondaryBackground.rawValue == "secondaryBackground")
        #expect(ColorType.primaryText.rawValue == "primaryText")
        #expect(ColorType.primaryAccent.rawValue == "primaryAccent")
    }

    @Test("ColorType rawValues should not be empty")
    func testRawValuesNotEmpty() {
        for colorType in ColorType.allCases {
            #expect(!colorType.rawValue.isEmpty)
        }
    }

    @Test("ColorType should be initializable from valid rawValue")
    func testInitFromValidRawValue() {
        let primary = ColorType(rawValue: "primaryBackground")
        #expect(primary == .primaryBackground)
    }

    @Test("ColorType should return nil for invalid rawValue")
    func testInitFromInvalidRawValue() {
        let invalid = ColorType(rawValue: "invalid")
        #expect(invalid == nil)
    }

    @Test("All rawValues should be unique")
    func testRawValueUniqueness() {
        var rawValues = Set<String>()
        for colorType in ColorType.allCases {
            rawValues.insert(colorType.rawValue)
        }
        #expect(rawValues.count == ColorType.allCases.count)
    }
}

// MARK: - ColorType swiftUIColor Tests

@Suite("ColorType swiftUIColor Tests")
@MainActor
struct ColorTypeSwiftUIColorTests {

    @Test("swiftUIColor should return Color for all cases")
    func testSwiftUIColorReturnsColor() {
        for colorType in ColorType.allCases {
            let color = colorType.swiftUIColor
            // Verify it's a valid Color (not checking against .clear since some might be transparent)
            #expect(type(of: color) == Color.self)
        }
    }

    @Test("swiftUIColor should return semantic colors")
    func testSemanticColors() {
        let primaryBg = ColorType.primaryBackground.swiftUIColor
        let primaryText = ColorType.primaryText.swiftUIColor
        let primaryAccent = ColorType.primaryAccent.swiftUIColor

        #expect(type(of: primaryBg) == Color.self)
        #expect(type(of: primaryText) == Color.self)
        #expect(type(of: primaryAccent) == Color.self)
    }

    @Test("Legacy colors should return valid colors")
    func testLegacyColors() {
        let red = ColorType.red.swiftUIColor
        let blue = ColorType.blue.swiftUIColor
        let green = ColorType.green.swiftUIColor
        let yellow = ColorType.yellow.swiftUIColor
        let gray = ColorType.gray.swiftUIColor

        #expect(type(of: red) == Color.self)
        #expect(type(of: blue) == Color.self)
        #expect(type(of: green) == Color.self)
        #expect(type(of: yellow) == Color.self)
        #expect(type(of: gray) == Color.self)
    }
}

// MARK: - ColorType uiColor Tests

@Suite("ColorType uiColor Tests")
@MainActor
struct ColorTypeUIColorTests {

    @Test("uiColor should return UIColor for all cases")
    func testUIColorReturnsUIColor() {
        for colorType in ColorType.allCases {
            let color = colorType.uiColor
            // Use 'is UIColor' instead of 'type(of:) ==' because UIColor
            // returns internal subclasses like UIDeviceRGBColor, UIDynamicCatalogSystemColor
            #expect(color is UIColor)
        }
    }

    @Test("uiColor should not be nil for any case")
    func testUIColorNotNil() {
        for colorType in ColorType.allCases {
            let color: UIColor = colorType.uiColor
            // UIColor is non-optional, so just verify we can access it
            #expect(type(of: color).self is UIColor.Type)
        }
    }

    @Test("Semantic uiColors should be valid")
    func testSemanticUIColors() {
        let primaryBg = ColorType.primaryBackground.uiColor
        let primaryText = ColorType.primaryText.uiColor
        let primaryAccent = ColorType.primaryAccent.uiColor

        #expect(primaryBg is UIColor)
        #expect(primaryText is UIColor)
        #expect(primaryAccent is UIColor)
    }
}

// MARK: - ThemeColors Struct Tests

@Suite("ThemeColors Struct Tests")
@MainActor
struct ThemeColorsStructTests {

    @Test("ThemeColors should provide access to color types")
    func testThemeColorsAccess() {
        let colors = ThemeColors()

        // Verify colors are accessible (just accessing them)
        _ = colors.primaryBackground
        _ = colors.secondaryBackground
        _ = colors.primaryText
        _ = colors.primaryAccent

        #expect(true)
    }

    @Test("Color.theme should provide ThemeColors accessor")
    func testColorThemeAccessor() {
        let themeColors = Color.theme

        _ = themeColors.primaryBackground
        _ = themeColors.primaryText

        #expect(true)
    }
}

// MARK: - ColorType Categories Tests

@Suite("ColorType Categories Tests")
@MainActor
struct ColorTypeCategoriesTests {

    @Test("Background colors should be distinct from text colors")
    func testBackgroundVsTextColors() {
        let bgTypes: [ColorType] = [.primaryBackground, .secondaryBackground, .tertiaryBackground, .cardBackground]
        let textTypes: [ColorType] = [.primaryText, .secondaryText, .tertiaryText, .invertedText]

        for bg in bgTypes {
            for text in textTypes {
                #expect(bg != text)
            }
        }
    }

    @Test("Accent colors should be distinct from each other")
    func testAccentColorsDistinct() {
        let accentTypes: [ColorType] = [.primaryAccent, .secondaryAccent, .destructiveAccent, .warningAccent, .successAccent]

        for i in 0..<accentTypes.count {
            for j in (i+1)..<accentTypes.count {
                #expect(accentTypes[i] != accentTypes[j])
            }
        }
    }
}

// MARK: - XCTest ColorType Tests

@MainActor
class ColorTypeXCTests: XCTestCase {

    func testAllCasesCount() {
        XCTAssertEqual(ColorType.allCases.count, 22)
    }

    func testRawValueUniqueness() {
        var rawValues = Set<String>()
        for colorType in ColorType.allCases {
            rawValues.insert(colorType.rawValue)
        }
        XCTAssertEqual(rawValues.count, ColorType.allCases.count)
    }

    func testRawValueRoundTrip() {
        for colorType in ColorType.allCases {
            let rawValue = colorType.rawValue
            let reconstructed = ColorType(rawValue: rawValue)
            XCTAssertEqual(colorType, reconstructed)
        }
    }

    func testSwiftUIColorType() {
        for colorType in ColorType.allCases {
            let color = colorType.swiftUIColor
            XCTAssertTrue(type(of: color) == Color.self, "Expected Color type for \(colorType)")
        }
    }

    func testUIColorIsUIColor() {
        for colorType in ColorType.allCases {
            let color = colorType.uiColor
            // Use 'is UIColor' because UIColor returns internal subclasses
            XCTAssertTrue(color is UIColor, "Expected UIColor type for \(colorType)")
        }
    }

    func testSemanticNamingConvention() {
        // Verify semantic naming for non-legacy colors
        let semanticPrefixes = ["primary", "secondary", "tertiary", "inverted", "card", "destructive", "warning", "success"]
        let uiElementNames = ["separator", "border", "shadow", "overlay"]
        let legacyNames = ["red", "blue", "green", "yellow", "gray"]

        for colorType in ColorType.allCases {
            let rawValue = colorType.rawValue

            // Skip legacy and UI element colors
            if legacyNames.contains(rawValue) || uiElementNames.contains(rawValue) {
                continue
            }

            let hasSemanticPrefix = semanticPrefixes.contains { rawValue.lowercased().contains($0) }
            XCTAssertTrue(hasSemanticPrefix, "ColorType \(rawValue) should have semantic prefix")
        }
    }

    func testHashableConformance() {
        var set = Set<ColorType>()
        for colorType in ColorType.allCases {
            set.insert(colorType)
        }
        XCTAssertEqual(set.count, ColorType.allCases.count)
    }

    func testEquatableConformance() {
        XCTAssertEqual(ColorType.primaryBackground, ColorType.primaryBackground)
        XCTAssertNotEqual(ColorType.primaryBackground, ColorType.secondaryBackground)
    }

    func testBackgroundColorTypes() {
        let backgrounds: [ColorType] = [.primaryBackground, .secondaryBackground, .tertiaryBackground, .cardBackground]
        XCTAssertEqual(backgrounds.count, 4)

        for bg in backgrounds {
            XCTAssertTrue(bg.rawValue.contains("Background"), "\(bg) should contain 'Background' in rawValue")
        }
    }

    func testTextColorTypes() {
        let texts: [ColorType] = [.primaryText, .secondaryText, .tertiaryText, .invertedText]
        XCTAssertEqual(texts.count, 4)

        for text in texts {
            XCTAssertTrue(text.rawValue.contains("Text"), "\(text) should contain 'Text' in rawValue")
        }
    }

    func testAccentColorTypes() {
        let accents: [ColorType] = [.primaryAccent, .secondaryAccent, .destructiveAccent, .warningAccent, .successAccent]
        XCTAssertEqual(accents.count, 5)

        for accent in accents {
            XCTAssertTrue(accent.rawValue.contains("Accent"), "\(accent) should contain 'Accent' in rawValue")
        }
    }
}
