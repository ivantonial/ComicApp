//
//  PrimaryButtonComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - PrimaryButtonComponent Initialization Tests

@Suite("PrimaryButtonComponent Initialization Tests")
@MainActor
struct PrimaryButtonComponentInitializationTests {

    @Test("PrimaryButtonComponent should be instantiable with basic parameters")
    func testBasicInitialization() {
        var actionCalled = false
        let button = PrimaryButtonComponent(
            title: "Test Button",
            action: { actionCalled = true }
        )

        #expect(type(of: button) == PrimaryButtonComponent.self)
        #expect(actionCalled == false)
    }

    @Test("PrimaryButtonComponent should be instantiable with all parameters")
    func testFullInitialization() {
        let button = PrimaryButtonComponent(
            title: "Test Button",
            isEnabled: true,
            action: {}
        )

        #expect(type(of: button) == PrimaryButtonComponent.self)
    }

    @Test("PrimaryButtonComponent should default isEnabled to true")
    func testDefaultIsEnabled() {
        let button = PrimaryButtonComponent(title: "Test", action: {})
        #expect(button.isEnabled == true)
    }

    @Test("PrimaryButtonComponent should accept disabled state")
    func testDisabledState() {
        let button = PrimaryButtonComponent(title: "Test", isEnabled: false, action: {})
        #expect(button.isEnabled == false)
    }
}

// MARK: - PrimaryButtonComponent Properties Tests

@Suite("PrimaryButtonComponent Properties Tests")
@MainActor
struct PrimaryButtonComponentPropertiesTests {

    @Test("title property should be accessible")
    func testTitleProperty() {
        let button = PrimaryButtonComponent(title: "My Button", action: {})
        #expect(button.title == "My Button")
    }

    @Test("isEnabled property should be accessible")
    func testIsEnabledProperty() {
        let enabledButton = PrimaryButtonComponent(title: "Test", isEnabled: true, action: {})
        let disabledButton = PrimaryButtonComponent(title: "Test", isEnabled: false, action: {})

        #expect(enabledButton.isEnabled == true)
        #expect(disabledButton.isEnabled == false)
    }

    @Test("title should accept empty string")
    func testEmptyTitle() {
        let button = PrimaryButtonComponent(title: "", action: {})
        #expect(button.title == "")
    }

    @Test("title should accept special characters")
    func testSpecialCharactersTitle() {
        let button = PrimaryButtonComponent(title: "Save & Continue →", action: {})
        #expect(button.title == "Save & Continue →")
    }

    @Test("title should accept unicode characters")
    func testUnicodeTitle() {
        let button = PrimaryButtonComponent(title: "保存 🚀", action: {})
        #expect(button.title == "保存 🚀")
    }
}

// MARK: - PrimaryButtonComponent Action Tests

@Suite("PrimaryButtonComponent Action Tests")
@MainActor
struct PrimaryButtonComponentActionTests {

    @Test("action closure should be stored")
    func testActionStored() {
        var counter = 0
        let button = PrimaryButtonComponent(title: "Test") {
            counter += 1
        }

        #expect(type(of: button) == PrimaryButtonComponent.self)
        #expect(counter == 0)
    }

    @Test("action should not be called on initialization")
    func testActionNotCalledOnInit() {
        var wasCalled = false
        _ = PrimaryButtonComponent(title: "Test") {
            wasCalled = true
        }

        #expect(wasCalled == false)
    }
}

// MARK: - PrimaryButtonComponent View Tests

@Suite("PrimaryButtonComponent View Tests")
@MainActor
struct PrimaryButtonComponentViewTests {

    @Test("PrimaryButtonComponent should conform to View")
    func testViewConformance() {
        let button = PrimaryButtonComponent(title: "Test", action: {})
        let _: any View = button
        #expect(true)
    }

    @Test("PrimaryButtonComponent body should be accessible")
    func testBodyAccessibility() {
        let button = PrimaryButtonComponent(title: "Test", action: {})
        let body = button.body
        #expect(type(of: body) != type(of: button))
        _ = body
    }
}

// MARK: - PrimaryButtonComponent Edge Cases Tests

@Suite("PrimaryButtonComponent Edge Cases Tests")
@MainActor
struct PrimaryButtonComponentEdgeCasesTests {

    @Test("should handle very long title")
    func testVeryLongTitle() {
        let longTitle = String(repeating: "A", count: 1000)
        let button = PrimaryButtonComponent(title: longTitle, action: {})
        #expect(button.title.count == 1000)
    }

    @Test("should handle whitespace-only title")
    func testWhitespaceTitle() {
        let button = PrimaryButtonComponent(title: "   ", action: {})
        #expect(button.title == "   ")
    }

    @Test("should handle newline in title")
    func testNewlineTitle() {
        let button = PrimaryButtonComponent(title: "Line1\nLine2", action: {})
        #expect(button.title.contains("\n"))
    }

    @Test("should handle various title formats")
    func testVariousTitleFormats() {
        let titles = ["", "A", "Button", "Very Long Button Title That Might Wrap"]

        for title in titles {
            let button = PrimaryButtonComponent(title: title, action: {})
            #expect(button.title == title)
        }
    }
}

// MARK: - PrimaryButtonComponent State Tests

@Suite("PrimaryButtonComponent State Tests")
@MainActor
struct PrimaryButtonComponentStateTests {

    @Test("enabled and disabled buttons should have different isEnabled values")
    func testEnabledDisabledDifference() {
        let enabled = PrimaryButtonComponent(title: "Test", isEnabled: true, action: {})
        let disabled = PrimaryButtonComponent(title: "Test", isEnabled: false, action: {})

        #expect(enabled.isEnabled != disabled.isEnabled)
    }

    @Test("multiple buttons should be independent")
    func testMultipleButtonsIndependent() {
        var counter1 = 0
        var counter2 = 0

        let button1 = PrimaryButtonComponent(title: "Button 1") {
            counter1 += 1
        }
        let button2 = PrimaryButtonComponent(title: "Button 2") {
            counter2 += 1
        }

        #expect(button1.title != button2.title)
        #expect(counter1 == 0)
        #expect(counter2 == 0)
    }
}

// MARK: - XCTest PrimaryButtonComponent Tests

@MainActor
class PrimaryButtonComponentXCTests: XCTestCase {

    func testBasicInitialization() {
        let button = PrimaryButtonComponent(title: "Test", action: {})

        XCTAssertEqual(button.title, "Test")
        XCTAssertTrue(button.isEnabled)
    }

    func testDisabledButton() {
        let button = PrimaryButtonComponent(title: "Test", isEnabled: false, action: {})

        XCTAssertFalse(button.isEnabled)
    }

    func testTitleVariations() {
        let titles = ["", "A", "Button", "Very Long Button Title That Might Wrap"]

        for title in titles {
            let button = PrimaryButtonComponent(title: title, action: {})
            XCTAssertEqual(button.title, title)
        }
    }

    func testActionNotCalledOnInit() {
        var callCount = 0

        _ = PrimaryButtonComponent(title: "Test") {
            callCount += 1
        }

        XCTAssertEqual(callCount, 0)
    }

    func testViewBodyCreation() {
        let button = PrimaryButtonComponent(title: "Test", action: {})
        let body = button.body

        XCTAssertNotNil(body)
    }

    func testMultipleButtonsIndependent() {
        var counter1 = 0
        var counter2 = 0

        let button1 = PrimaryButtonComponent(title: "Button 1") {
            counter1 += 1
        }
        let button2 = PrimaryButtonComponent(title: "Button 2") {
            counter2 += 1
        }

        XCTAssertNotEqual(button1.title, button2.title)
        XCTAssertEqual(counter1, 0)
        XCTAssertEqual(counter2, 0)
    }

    func testIsEnabledStates() {
        let enabled = PrimaryButtonComponent(title: "Test", isEnabled: true, action: {})
        let disabled = PrimaryButtonComponent(title: "Test", isEnabled: false, action: {})

        XCTAssertTrue(enabled.isEnabled)
        XCTAssertFalse(disabled.isEnabled)
    }

    func testSpecialCharactersInTitle() {
        let specialTitles = ["Save & Continue", "100% Complete", "→ Next", "保存"]

        for title in specialTitles {
            let button = PrimaryButtonComponent(title: title, action: {})
            XCTAssertEqual(button.title, title)
        }
    }

    func testEmptyTitle() {
        let button = PrimaryButtonComponent(title: "", action: {})
        XCTAssertEqual(button.title, "")
    }

    func testWhitespaceTitle() {
        let button = PrimaryButtonComponent(title: "   ", action: {})
        XCTAssertEqual(button.title, "   ")
    }
}
