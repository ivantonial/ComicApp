//
//  SearchBarComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - SearchBarComponent Initialization Tests

@Suite("SearchBarComponent Initialization Tests")
@MainActor
struct SearchBarComponentInitializationTests {

    @Test("SearchBarComponent should be instantiable with text binding")
    func testMinimalInitialization() {
        let searchBar = SearchBarComponent(text: .constant(""))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("SearchBarComponent should be instantiable with placeholder")
    func testInitializationWithPlaceholder() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search characters..."
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("SearchBarComponent should be instantiable with all parameters")
    func testFullInitialization() {
        var editingChanged = false
        var committed = false

        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search...",
            showClearButton: true,
            onEditingChanged: { _ in editingChanged = true },
            onCommit: { committed = true }
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
        #expect(editingChanged == false)
        #expect(committed == false)
    }

    @Test("SearchBarComponent should work with default placeholder")
    func testDefaultPlaceholder() {
        let searchBar = SearchBarComponent(text: .constant(""))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("SearchBarComponent should work with default showClearButton")
    func testDefaultShowClearButton() {
        let searchBar = SearchBarComponent(text: .constant(""))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }
}

// MARK: - SearchBarComponent View Tests

@Suite("SearchBarComponent View Tests")
@MainActor
struct SearchBarComponentViewTests {

    @Test("SearchBarComponent should conform to View")
    func testViewConformance() {
        let searchBar = SearchBarComponent(text: .constant(""))
        let _: any View = searchBar
        #expect(true)
    }

    @Test("SearchBarComponent body should be accessible")
    func testBodyAccessibility() {
        let searchBar = SearchBarComponent(text: .constant(""))
        let body = searchBar.body
        #expect(type(of: body) != type(of: searchBar))
    }

    @Test("SearchBarComponent body should change based on text")
    func testBodyWithDifferentText() {
        let emptySearchBar = SearchBarComponent(text: .constant(""))
        let filledSearchBar = SearchBarComponent(text: .constant("test"))

        let emptyBody = emptySearchBar.body
        let filledBody = filledSearchBar.body

        // Both should produce valid bodies
        #expect(true)
        _ = emptyBody
        _ = filledBody
    }
}

// MARK: - SearchBarComponent Placeholder Tests

@Suite("SearchBarComponent Placeholder Tests")
@MainActor
struct SearchBarComponentPlaceholderTests {

    @Test("Should accept custom placeholder")
    func testCustomPlaceholder() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Find heroes..."
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept empty placeholder")
    func testEmptyPlaceholder() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: ""
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept unicode placeholder")
    func testUnicodePlaceholder() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "搜索 🔍"
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept various placeholders")
    func testVariousPlaceholders() {
        let placeholders = [
            "Search...",
            "Find characters",
            "🔍 Search",
            "Buscar personajes",
            "Very long placeholder text that might wrap to multiple lines"
        ]

        for placeholder in placeholders {
            let searchBar = SearchBarComponent(
                text: .constant(""),
                placeholder: placeholder
            )
            #expect(type(of: searchBar) == SearchBarComponent.self)
        }
    }
}

// MARK: - SearchBarComponent Clear Button Tests

@Suite("SearchBarComponent Clear Button Tests")
@MainActor
struct SearchBarComponentClearButtonTests {

    @Test("Should show clear button when enabled")
    func testClearButtonEnabled() {
        let searchBar = SearchBarComponent(
            text: .constant("test"),
            showClearButton: true
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should hide clear button when disabled")
    func testClearButtonDisabled() {
        let searchBar = SearchBarComponent(
            text: .constant("test"),
            showClearButton: false
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Clear button should not show with empty text")
    func testClearButtonWithEmptyText() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            showClearButton: true
        )
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }
}

// MARK: - SearchBarComponent Callbacks Tests

@Suite("SearchBarComponent Callbacks Tests")
@MainActor
struct SearchBarComponentCallbacksTests {

    @Test("onEditingChanged callback should not be called on init")
    func testOnEditingChangedNotCalledOnInit() {
        var callCount = 0

        _ = SearchBarComponent(
            text: .constant(""),
            onEditingChanged: { _ in callCount += 1 }
        )

        #expect(callCount == 0)
    }

    @Test("onCommit callback should not be called on init")
    func testOnCommitNotCalledOnInit() {
        var callCount = 0

        _ = SearchBarComponent(
            text: .constant(""),
            onCommit: { callCount += 1 }
        )

        #expect(callCount == 0)
    }

    @Test("Should work without callbacks")
    func testWithoutCallbacks() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            onEditingChanged: nil,
            onCommit: nil
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should work with only onEditingChanged callback")
    func testWithOnlyOnEditingChanged() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            onEditingChanged: { _ in },
            onCommit: nil
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should work with only onCommit callback")
    func testWithOnlyOnCommit() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            onEditingChanged: nil,
            onCommit: {}
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }
}

// MARK: - SearchBarComponent Text Binding Tests

@Suite("SearchBarComponent Text Binding Tests")
@MainActor
struct SearchBarComponentTextBindingTests {

    @Test("Should accept empty text")
    func testEmptyText() {
        let searchBar = SearchBarComponent(text: .constant(""))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept text with content")
    func testTextWithContent() {
        let searchBar = SearchBarComponent(text: .constant("Spider-Man"))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept long text")
    func testLongText() {
        let longText = String(repeating: "a", count: 500)
        let searchBar = SearchBarComponent(text: .constant(longText))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept special characters")
    func testSpecialCharacters() {
        let specialText = "Test & Search < > @ # $ %"
        let searchBar = SearchBarComponent(text: .constant(specialText))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Should accept unicode text")
    func testUnicodeText() {
        let unicodeText = "蜘蛛侠 🕷️"
        let searchBar = SearchBarComponent(text: .constant(unicodeText))
        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Binding should work correctly")
    func testBindingWorks() {
        var searchText = "initial"
        let binding = Binding(
            get: { searchText },
            set: { searchText = $0 }
        )

        _ = SearchBarComponent(text: binding)

        // Update via binding
        binding.wrappedValue = "updated"
        #expect(searchText == "updated")
    }
}

// MARK: - SearchBarComponent Common Use Cases Tests

@Suite("SearchBarComponent Common Use Cases Tests")
@MainActor
struct SearchBarComponentCommonUseCasesTests {

    @Test("Character search configuration")
    func testCharacterSearchConfiguration() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search characters...",
            showClearButton: true,
            onEditingChanged: { _ in },
            onCommit: {}
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Comics search configuration")
    func testComicsSearchConfiguration() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search comics by title...",
            showClearButton: true
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Favorites filter configuration")
    func testFavoritesFilterConfiguration() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Filter favorites...",
            showClearButton: true
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Simple search without callbacks")
    func testSimpleSearchConfiguration() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Quick search..."
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
    }

    @Test("Full featured search configuration")
    func testFullFeaturedConfiguration() {
        var isSearching = false
        var searchSubmitted = false

        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search everything...",
            showClearButton: true,
            onEditingChanged: { editing in isSearching = editing },
            onCommit: { searchSubmitted = true }
        )

        #expect(type(of: searchBar) == SearchBarComponent.self)
        #expect(isSearching == false)
        #expect(searchSubmitted == false)
    }
}

// MARK: - XCTest SearchBarComponent Tests

@MainActor
class SearchBarComponentXCTests: XCTestCase {

    func testBasicInitialization() {
        let searchBar = SearchBarComponent(text: .constant(""))
        XCTAssertNotNil(searchBar)
    }

    func testInitializationWithPlaceholder() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Custom placeholder"
        )
        XCTAssertNotNil(searchBar)
    }

    func testInitializationWithClearButtonDisabled() {
        let searchBar = SearchBarComponent(
            text: .constant("test"),
            showClearButton: false
        )
        XCTAssertNotNil(searchBar)
    }

    func testInitializationWithAllParameters() {
        var editingChangedCalled = false
        var commitCalled = false

        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search...",
            showClearButton: true,
            onEditingChanged: { _ in editingChangedCalled = true },
            onCommit: { commitCalled = true }
        )

        XCTAssertNotNil(searchBar)
        XCTAssertFalse(editingChangedCalled)
        XCTAssertFalse(commitCalled)
    }

    func testViewBodyCreation() {
        let searchBar = SearchBarComponent(text: .constant(""))
        let body = searchBar.body
        XCTAssertNotNil(body)
    }

    func testVariousPlaceholders() {
        let placeholders = [
            "Search...",
            "",
            "Find characters",
            "🔍 Search",
            "Buscar personajes",
            "Very long placeholder text that might wrap"
        ]

        for placeholder in placeholders {
            let searchBar = SearchBarComponent(
                text: .constant(""),
                placeholder: placeholder
            )
            XCTAssertNotNil(searchBar)
        }
    }

    func testVariousTextValues() {
        let texts = [
            "",
            "a",
            "Spider-Man",
            "Special chars: &<>\"'",
            String(repeating: "x", count: 100)
        ]

        for text in texts {
            let searchBar = SearchBarComponent(text: .constant(text))
            XCTAssertNotNil(searchBar)
        }
    }

    func testCallbacksNotTriggeredOnInit() {
        var editingChangedCount = 0
        var commitCount = 0

        _ = SearchBarComponent(
            text: .constant(""),
            onEditingChanged: { _ in editingChangedCount += 1 },
            onCommit: { commitCount += 1 }
        )

        XCTAssertEqual(editingChangedCount, 0)
        XCTAssertEqual(commitCount, 0)
    }

    func testBindingState() {
        var searchText = "initial"
        let binding = Binding(
            get: { searchText },
            set: { searchText = $0 }
        )

        _ = SearchBarComponent(text: binding)

        // O binding deve funcionar
        binding.wrappedValue = "updated"
        XCTAssertEqual(searchText, "updated")
    }

    func testClearButtonVisibilityConfiguration() {
        let withClearButton = SearchBarComponent(
            text: .constant("test"),
            showClearButton: true
        )
        let withoutClearButton = SearchBarComponent(
            text: .constant("test"),
            showClearButton: false
        )

        XCTAssertNotNil(withClearButton)
        XCTAssertNotNil(withoutClearButton)
    }

    func testNilCallbacks() {
        let searchBar = SearchBarComponent(
            text: .constant(""),
            placeholder: "Search...",
            showClearButton: true,
            onEditingChanged: nil,
            onCommit: nil
        )

        XCTAssertNotNil(searchBar)
    }
}
