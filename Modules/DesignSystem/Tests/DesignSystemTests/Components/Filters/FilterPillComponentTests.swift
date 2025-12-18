//
//  FilterPillComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - FilterPillStyle Tests

@Suite("FilterPillStyle Tests")
@MainActor
struct FilterPillStyleTests {

    @Test("FilterPillStyle should have primary case")
    func testPrimaryCase() {
        let style = FilterPillStyle.primary
        #expect(style == .primary)
    }

    @Test("FilterPillStyle should have outlined case")
    func testOutlinedCase() {
        let style = FilterPillStyle.outlined
        #expect(style == .outlined)
    }

    @Test("FilterPillStyle should have minimal case")
    func testMinimalCase() {
        let style = FilterPillStyle.minimal
        #expect(style == .minimal)
    }

    @Test("FilterPillStyle should have exactly 3 cases")
    func testCaseCount() {
        let styles: [FilterPillStyle] = [.primary, .outlined, .minimal]
        #expect(styles.count == 3)
    }

    @Test("FilterPillStyle cases should be distinct")
    func testStylesDistinct() {
        #expect(FilterPillStyle.primary != FilterPillStyle.outlined)
        #expect(FilterPillStyle.outlined != FilterPillStyle.minimal)
        #expect(FilterPillStyle.primary != FilterPillStyle.minimal)
    }
}

// MARK: - FilterPillComponent Initialization Tests

@Suite("FilterPillComponent Initialization Tests")
@MainActor
struct FilterPillComponentInitializationTests {

    @Test("FilterPillComponent should be instantiable with basic parameters")
    func testBasicInitialization() {
        var actionCalled = false
        let pill = FilterPillComponent(
            title: "All",
            isSelected: false,
            action: { actionCalled = true }
        )

        #expect(type(of: pill) == FilterPillComponent.self)
        #expect(actionCalled == false)
    }

    @Test("FilterPillComponent should be instantiable with icon")
    func testInitializationWithIcon() {
        let pill = FilterPillComponent(
            title: "Heroes",
            icon: "person.fill",
            isSelected: true,
            action: {}
        )

        #expect(type(of: pill) == FilterPillComponent.self)
        #expect(pill.icon == "person.fill")
    }

    @Test("FilterPillComponent should be instantiable with explicit theme colors")
    func testExplicitThemeColorsInitialization() {
        let pill = FilterPillComponent(
            title: "Villains",
            icon: "person.fill.xmark",
            isSelected: false,
            style: .outlined,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )

        #expect(type(of: pill) == FilterPillComponent.self)
        #expect(pill.useThemeColors == true)
        #expect(pill.customSelectedColor == nil)
    }

    @Test("FilterPillComponent should be instantiable with legacy initializer")
    func testLegacyInitialization() {
        let pill = FilterPillComponent(
            title: "Teams",
            icon: "person.3.fill",
            isSelected: true,
            style: .primary,
            selectedColor: .blue,
            action: {}
        )

        #expect(type(of: pill) == FilterPillComponent.self)
        #expect(pill.useThemeColors == false)
        #expect(pill.customSelectedColor == .blue)
    }

    @Test("FilterPillComponent should default style to primary")
    func testDefaultStyle() {
        let pill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            action: {}
        )

        #expect(pill.style == .primary)
    }

    @Test("FilterPillComponent should default icon to nil")
    func testDefaultIcon() {
        let pill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            action: {}
        )

        #expect(pill.icon == nil)
    }

    @Test("FilterPillComponent with useThemeColors true should have nil customSelectedColor")
    func testThemeColorsHasNilCustomColor() {
        let pill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )

        #expect(pill.useThemeColors == true)
        #expect(pill.customSelectedColor == nil)
    }
}

// MARK: - FilterPillComponent Properties Tests

@Suite("FilterPillComponent Properties Tests")
@MainActor
struct FilterPillComponentPropertiesTests {

    @Test("title property should be accessible")
    func testTitleProperty() {
        let pill = FilterPillComponent(title: "Heroes", isSelected: false, action: {})
        #expect(pill.title == "Heroes")
    }

    @Test("icon property should be accessible when set")
    func testIconProperty() {
        let pill = FilterPillComponent(title: "Test", icon: "star.fill", isSelected: false, action: {})
        #expect(pill.icon == "star.fill")
    }

    @Test("icon property should be nil when not set")
    func testIconPropertyNil() {
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})
        #expect(pill.icon == nil)
    }

    @Test("isSelected property should be accessible")
    func testIsSelectedProperty() {
        let selectedPill = FilterPillComponent(title: "Test", isSelected: true, action: {})
        let unselectedPill = FilterPillComponent(title: "Test", isSelected: false, action: {})

        #expect(selectedPill.isSelected == true)
        #expect(unselectedPill.isSelected == false)
    }

    @Test("style property should be accessible")
    func testStyleProperty() {
        let primaryPill = FilterPillComponent(title: "Test", isSelected: false, style: .primary, action: {})
        let outlinedPill = FilterPillComponent(title: "Test", isSelected: false, style: .outlined, action: {})
        let minimalPill = FilterPillComponent(title: "Test", isSelected: false, style: .minimal, action: {})

        #expect(primaryPill.style == .primary)
        #expect(outlinedPill.style == .outlined)
        #expect(minimalPill.style == .minimal)
    }

    @Test("useThemeColors property reflects initializer used")
    func testUseThemeColorsProperty() {
        // Explicit theme colors initializer
        let themeColorsPill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )
        // Legacy initializer with custom color
        let customColorsPill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            selectedColor: .blue,
            action: {}
        )

        #expect(themeColorsPill.useThemeColors == true)
        #expect(customColorsPill.useThemeColors == false)
    }

    @Test("customSelectedColor property should be accessible")
    func testCustomSelectedColorProperty() {
        let pillWithColor = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            selectedColor: .purple,
            action: {}
        )

        #expect(pillWithColor.customSelectedColor == .purple)
    }
}

// MARK: - FilterPillComponent View Tests

@Suite("FilterPillComponent View Tests")
@MainActor
struct FilterPillComponentViewTests {

    @Test("FilterPillComponent should conform to View")
    func testViewConformance() {
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})
        let _: any View = pill
        #expect(true)
    }

    @Test("FilterPillComponent body should be accessible")
    func testBodyAccessibility() {
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})
        let body = pill.body
        #expect(type(of: body) != type(of: pill))
        _ = body
    }
}

// MARK: - FilterPillComponent Style Variations Tests

@Suite("FilterPillComponent Style Variations Tests")
@MainActor
struct FilterPillComponentStyleVariationsTests {

    @Test("Primary style selected should look different from unselected")
    func testPrimaryStyleDifference() {
        let selected = FilterPillComponent(title: "Test", isSelected: true, style: .primary, action: {})
        let unselected = FilterPillComponent(title: "Test", isSelected: false, style: .primary, action: {})

        #expect(selected.isSelected != unselected.isSelected)
    }

    @Test("Outlined style selected should look different from unselected")
    func testOutlinedStyleDifference() {
        let selected = FilterPillComponent(title: "Test", isSelected: true, style: .outlined, action: {})
        let unselected = FilterPillComponent(title: "Test", isSelected: false, style: .outlined, action: {})

        #expect(selected.isSelected != unselected.isSelected)
    }

    @Test("Minimal style selected should look different from unselected")
    func testMinimalStyleDifference() {
        let selected = FilterPillComponent(title: "Test", isSelected: true, style: .minimal, action: {})
        let unselected = FilterPillComponent(title: "Test", isSelected: false, style: .minimal, action: {})

        #expect(selected.isSelected != unselected.isSelected)
    }

    @Test("All styles should be creatable")
    func testAllStylesCreatable() {
        let styles: [FilterPillStyle] = [.primary, .outlined, .minimal]

        for style in styles {
            let pill = FilterPillComponent(title: "Test", isSelected: false, style: style, action: {})
            #expect(pill.style == style)
        }
    }
}

// MARK: - FilterPillComponent Action Tests

@Suite("FilterPillComponent Action Tests")
@MainActor
struct FilterPillComponentActionTests {

    @Test("action should not be called on initialization")
    func testActionNotCalledOnInit() {
        var wasCalled = false
        _ = FilterPillComponent(title: "Test", isSelected: false) {
            wasCalled = true
        }

        #expect(wasCalled == false)
    }

    @Test("action closure should be stored")
    func testActionStored() {
        var counter = 0
        let pill = FilterPillComponent(title: "Test", isSelected: false) {
            counter += 1
        }

        #expect(type(of: pill) == FilterPillComponent.self)
        #expect(counter == 0)
    }
}

// MARK: - FilterPillComponent Common Use Cases Tests

@Suite("FilterPillComponent Common Use Cases Tests")
@MainActor
struct FilterPillComponentCommonUseCasesTests {

    @Test("Filter chips for character types")
    func testCharacterTypeFilters() {
        let filters = [
            ("All", nil as String?, true),
            ("Heroes", "person.fill", false),
            ("Villains", "person.fill.xmark", false),
            ("Teams", "person.3.fill", false)
        ]

        for (title, icon, isSelected) in filters {
            let pill = FilterPillComponent(
                title: title,
                icon: icon,
                isSelected: isSelected,
                action: {}
            )
            #expect(pill.title == title)
            #expect(pill.icon == icon)
            #expect(pill.isSelected == isSelected)
        }
    }

    @Test("Filter chips for comic filters")
    func testComicFilters() {
        let filters = ["All", "Recent", "Popular", "Classic"]

        for (index, title) in filters.enumerated() {
            let pill = FilterPillComponent(
                title: title,
                isSelected: index == 0,
                action: {}
            )
            #expect(pill.title == title)
        }
    }

    @Test("Multiple independent pills")
    func testMultiplePillsIndependent() {
        let pill1 = FilterPillComponent(title: "Pill 1", isSelected: true, action: {})
        let pill2 = FilterPillComponent(title: "Pill 2", isSelected: false, action: {})

        #expect(pill1.title != pill2.title)
        #expect(pill1.isSelected != pill2.isSelected)
    }
}

// MARK: - FilterPillComponent Edge Cases Tests

@Suite("FilterPillComponent Edge Cases Tests")
@MainActor
struct FilterPillComponentEdgeCasesTests {

    @Test("should handle empty title")
    func testEmptyTitle() {
        let pill = FilterPillComponent(title: "", isSelected: false, action: {})
        #expect(pill.title == "")
    }

    @Test("should handle very long title")
    func testVeryLongTitle() {
        let longTitle = String(repeating: "A", count: 100)
        let pill = FilterPillComponent(title: longTitle, isSelected: false, action: {})
        #expect(pill.title.count == 100)
    }

    @Test("should handle special characters in title")
    func testSpecialCharactersTitle() {
        let pill = FilterPillComponent(title: "Filter → All", isSelected: false, action: {})
        #expect(pill.title == "Filter → All")
    }

    @Test("should handle unicode in title")
    func testUnicodeTitle() {
        let pill = FilterPillComponent(title: "筛选 🔍", isSelected: false, action: {})
        #expect(pill.title == "筛选 🔍")
    }
}

// MARK: - FilterPillComponent Initializer Resolution Tests

@Suite("FilterPillComponent Initializer Resolution Tests")
@MainActor
struct FilterPillComponentInitializerResolutionTests {

    @Test("Basic initializer uses legacy defaults")
    func testBasicInitializerUsesLegacyDefaults() {
        // NOTE: Due to Swift's initializer resolution, the basic call
        // FilterPillComponent(title:isSelected:action:) resolves to the legacy initializer
        // which sets useThemeColors = false and customSelectedColor = .red
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})

        #expect(pill.style == .primary)
        #expect(pill.icon == nil)
        // These are the ACTUAL defaults from the legacy initializer
        #expect(pill.useThemeColors == false)
        #expect(pill.customSelectedColor == .red)
    }

    @Test("Explicit useThemeColors initializer works correctly")
    func testExplicitUseThemeColorsInitializer() {
        let pill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )

        #expect(pill.useThemeColors == true)
        #expect(pill.customSelectedColor == nil)
    }

    @Test("Explicit selectedColor initializer sets legacy mode")
    func testExplicitSelectedColorInitializer() {
        let pill = FilterPillComponent(
            title: "Test",
            isSelected: false,
            style: .primary,
            selectedColor: .blue,
            action: {}
        )

        #expect(pill.useThemeColors == false)
        #expect(pill.customSelectedColor == .blue)
    }
}

// MARK: - XCTest FilterPillComponent Tests

@MainActor
class FilterPillComponentXCTests: XCTestCase {

    // MARK: - Basic Initialization Tests

    func testBasicInitialization() {
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})

        XCTAssertEqual(pill.title, "Test")
        XCTAssertFalse(pill.isSelected)
        XCTAssertNil(pill.icon)
        XCTAssertEqual(pill.style, .primary)
        // NOTE: Basic initializer resolves to legacy initializer
        // which sets useThemeColors = false and customSelectedColor = .red
        XCTAssertFalse(pill.useThemeColors)
        XCTAssertEqual(pill.customSelectedColor, .red)
    }

    func testInitializationWithIcon() {
        let pill = FilterPillComponent(
            title: "Heroes",
            icon: "person.fill",
            isSelected: true,
            action: {}
        )

        XCTAssertEqual(pill.title, "Heroes")
        XCTAssertEqual(pill.icon, "person.fill")
        XCTAssertTrue(pill.isSelected)
    }

    // MARK: - Style Tests

    func testAllStyles() {
        let styles: [FilterPillStyle] = [.primary, .outlined, .minimal]

        for style in styles {
            let pill = FilterPillComponent(title: "Test", isSelected: false, style: style, action: {})
            XCTAssertEqual(pill.style, style)
        }
    }

    // MARK: - Initializer Variants Tests

    func testLegacyInitializerWithCustomColor() {
        let pill = FilterPillComponent(
            title: "Custom",
            isSelected: true,
            style: .primary,
            selectedColor: .purple,
            action: {}
        )

        XCTAssertEqual(pill.title, "Custom")
        XCTAssertTrue(pill.isSelected)
        XCTAssertFalse(pill.useThemeColors)
        XCTAssertEqual(pill.customSelectedColor, .purple)
    }

    func testThemeColorsInitializer() {
        let pill = FilterPillComponent(
            title: "Theme",
            isSelected: true,
            style: .outlined,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )

        XCTAssertTrue(pill.useThemeColors)
        XCTAssertNil(pill.customSelectedColor)
    }

    // MARK: - View Tests

    func testViewBodyCreation() {
        let pill = FilterPillComponent(title: "Test", isSelected: false, action: {})

        let body = pill.body
        XCTAssertNotNil(body)
    }

    // MARK: - Action Tests

    func testActionNotCalledOnInit() {
        var actionCalled = false

        _ = FilterPillComponent(title: "Test", isSelected: false) {
            actionCalled = true
        }

        XCTAssertFalse(actionCalled)
    }

    // MARK: - Independence Tests

    func testMultiplePillsIndependent() {
        let pill1 = FilterPillComponent(title: "Pill 1", isSelected: true, action: {})
        let pill2 = FilterPillComponent(title: "Pill 2", isSelected: false, action: {})

        XCTAssertNotEqual(pill1.title, pill2.title)
        XCTAssertNotEqual(pill1.isSelected, pill2.isSelected)
    }

    // MARK: - Equality Tests

    func testStyleEquality() {
        XCTAssertEqual(FilterPillStyle.primary, FilterPillStyle.primary)
        XCTAssertNotEqual(FilterPillStyle.primary, FilterPillStyle.outlined)
        XCTAssertNotEqual(FilterPillStyle.outlined, FilterPillStyle.minimal)
    }

    // MARK: - Default Values Tests

    func testDefaultValuesWithBasicInitializer() {
        // Basic initializer resolves to legacy initializer
        let pill = FilterPillComponent(title: "Default", isSelected: false, action: {})

        XCTAssertEqual(pill.style, .primary)
        XCTAssertNil(pill.icon)
        // Legacy initializer defaults
        XCTAssertFalse(pill.useThemeColors)
        XCTAssertEqual(pill.customSelectedColor, .red)
    }

    func testDefaultValuesWithExplicitThemeColors() {
        // Explicit theme colors initializer
        let pill = FilterPillComponent(
            title: "Default",
            isSelected: false,
            style: .primary,
            useThemeColors: true,
            customSelectedColor: nil,
            action: {}
        )

        XCTAssertEqual(pill.style, .primary)
        XCTAssertNil(pill.icon)
        XCTAssertTrue(pill.useThemeColors)
        XCTAssertNil(pill.customSelectedColor)
    }

    // MARK: - Selection State Tests

    func testSelectedAndUnselectedStates() {
        let selected = FilterPillComponent(title: "Test", isSelected: true, action: {})
        let unselected = FilterPillComponent(title: "Test", isSelected: false, action: {})

        XCTAssertTrue(selected.isSelected)
        XCTAssertFalse(unselected.isSelected)
    }

    // MARK: - Custom Color Tests

    func testVariousCustomColors() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]

        for color in colors {
            let pill = FilterPillComponent(
                title: "Test",
                isSelected: false,
                style: .primary,
                selectedColor: color,
                action: {}
            )
            XCTAssertEqual(pill.customSelectedColor, color)
            XCTAssertFalse(pill.useThemeColors)
        }
    }
}
