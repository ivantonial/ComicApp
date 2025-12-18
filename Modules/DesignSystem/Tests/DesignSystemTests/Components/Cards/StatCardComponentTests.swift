//
//  StatCardComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - StatCardComponent Initialization Tests

@Suite("StatCardComponent Initialization Tests")
@MainActor
struct StatCardComponentInitializationTests {

    @Test("StatCardComponent should be instantiable with all parameters")
    func testFullInitialization() {
        let card = StatCardComponent(
            icon: "book.fill",
            title: "Comics",
            value: "42",
            color: .red
        )

        #expect(type(of: card) == StatCardComponent.self)
    }

    @Test("StatCardComponent should accept various icons")
    func testVariousIcons() {
        let icons = ["star.fill", "heart.fill", "person.fill", "bolt.fill"]

        for icon in icons {
            let card = StatCardComponent(
                icon: icon,
                title: "Test",
                value: "0",
                color: .blue
            )
            #expect(type(of: card) == StatCardComponent.self)
        }
    }

    @Test("StatCardComponent should accept various colors")
    func testVariousColors() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]

        for color in colors {
            let card = StatCardComponent(
                icon: "star",
                title: "Test",
                value: "0",
                color: color
            )
            #expect(type(of: card) == StatCardComponent.self)
        }
    }
}

// MARK: - StatCardComponent Properties Tests

@Suite("StatCardComponent Properties Tests")
@MainActor
struct StatCardComponentPropertiesTests {

    @Test("icon property should be accessible")
    func testIconProperty() {
        let card = StatCardComponent(icon: "book.fill", title: "Comics", value: "42", color: .red)
        #expect(card.icon == "book.fill")
    }

    @Test("title property should be accessible")
    func testTitleProperty() {
        let card = StatCardComponent(icon: "book.fill", title: "Comics", value: "42", color: .red)
        #expect(card.title == "Comics")
    }

    @Test("value property should be accessible")
    func testValueProperty() {
        let card = StatCardComponent(icon: "book.fill", title: "Comics", value: "42", color: .red)
        #expect(card.value == "42")
    }

    @Test("color property should be accessible")
    func testColorProperty() {
        let card = StatCardComponent(icon: "book.fill", title: "Comics", value: "42", color: .red)
        #expect(card.color == .red)
    }
}

// MARK: - StatCardComponent Value Formats Tests

@Suite("StatCardComponent Value Formats Tests")
@MainActor
struct StatCardComponentValueFormatsTests {

    @Test("value should accept numeric strings")
    func testNumericValue() {
        let card = StatCardComponent(icon: "star", title: "Count", value: "123", color: .blue)
        #expect(card.value == "123")
    }

    @Test("value should accept formatted numbers")
    func testFormattedValue() {
        let values = ["1,000", "10.5K", "1M", "2.5B"]

        for value in values {
            let card = StatCardComponent(icon: "star", title: "Test", value: value, color: .blue)
            #expect(card.value == value)
        }
    }

    @Test("value should accept text values")
    func testTextValue() {
        let card = StatCardComponent(icon: "star", title: "Status", value: "Active", color: .green)
        #expect(card.value == "Active")
    }

    @Test("value should accept empty string")
    func testEmptyValue() {
        let card = StatCardComponent(icon: "star", title: "Test", value: "", color: .blue)
        #expect(card.value == "")
    }
}

// MARK: - StatCardComponent View Tests

@Suite("StatCardComponent View Tests")
@MainActor
struct StatCardComponentViewTests {

    @Test("StatCardComponent should conform to View")
    func testViewConformance() {
        let card = StatCardComponent(icon: "star", title: "Test", value: "0", color: .blue)
        let _: any View = card
        #expect(true)
    }

    @Test("StatCardComponent body should be accessible")
    func testBodyAccessibility() {
        let card = StatCardComponent(icon: "star", title: "Test", value: "0", color: .blue)
        let body = card.body
        #expect(type(of: body) != type(of: card))
        _ = body
    }
}

// MARK: - StatCardComponent Common Use Cases Tests

@Suite("StatCardComponent Common Use Cases Tests")
@MainActor
struct StatCardComponentCommonUseCasesTests {

    @Test("Comics stat card")
    func testComicsStatCard() {
        let card = StatCardComponent(
            icon: "book.fill",
            title: "Comics",
            value: "156",
            color: .red
        )

        #expect(card.icon == "book.fill")
        #expect(card.title == "Comics")
        #expect(card.color == .red)
    }

    @Test("Friends stat card")
    func testFriendsStatCard() {
        let card = StatCardComponent(
            icon: "person.2.fill",
            title: "Friends",
            value: "23",
            color: .blue
        )

        #expect(card.icon == "person.2.fill")
        #expect(card.title == "Friends")
        #expect(card.color == .blue)
    }

    @Test("Powers stat card")
    func testPowersStatCard() {
        let card = StatCardComponent(
            icon: "bolt.fill",
            title: "Powers",
            value: "8",
            color: .yellow
        )

        #expect(card.icon == "bolt.fill")
        #expect(card.title == "Powers")
        #expect(card.color == .yellow)
    }

    @Test("Enemies stat card")
    func testEnemiesStatCard() {
        let card = StatCardComponent(
            icon: "exclamationmark.triangle.fill",
            title: "Enemies",
            value: "12",
            color: .green
        )

        #expect(card.icon == "exclamationmark.triangle.fill")
        #expect(card.title == "Enemies")
    }
}

// MARK: - XCTest StatCardComponent Tests

@MainActor
class StatCardComponentXCTests: XCTestCase {

    func testBasicInitialization() {
        let card = StatCardComponent(
            icon: "star.fill",
            title: "Test",
            value: "100",
            color: .blue
        )

        XCTAssertEqual(card.icon, "star.fill")
        XCTAssertEqual(card.title, "Test")
        XCTAssertEqual(card.value, "100")
        XCTAssertEqual(card.color, .blue)
    }

    func testDifferentColorTypes() {
        let colorCases: [(Color, String)] = [
            (.red, "red"),
            (.blue, "blue"),
            (.green, "green"),
            (.yellow, "yellow"),
            (.orange, "orange"),
            (.purple, "purple")
        ]

        for (color, _) in colorCases {
            let card = StatCardComponent(icon: "star", title: "Test", value: "0", color: color)
            XCTAssertEqual(card.color, color)
        }
    }

    func testSpecialCharactersInTitle() {
        let titles = ["Comics & Series", "100% Complete", "Rating: 5★"]

        for title in titles {
            let card = StatCardComponent(icon: "star", title: title, value: "0", color: .blue)
            XCTAssertEqual(card.title, title)
        }
    }

    func testNumericFormats() {
        let formats = ["0", "1", "100", "1,000", "1.5K", "1M"]

        for format in formats {
            let card = StatCardComponent(icon: "star", title: "Test", value: format, color: .blue)
            XCTAssertEqual(card.value, format)
        }
    }

    func testViewBodyCreation() {
        let card = StatCardComponent(icon: "star", title: "Test", value: "0", color: .blue)
        let body = card.body

        XCTAssertNotNil(body)
    }

    func testEmptyValues() {
        let card = StatCardComponent(icon: "", title: "", value: "", color: .blue)

        XCTAssertEqual(card.icon, "")
        XCTAssertEqual(card.title, "")
        XCTAssertEqual(card.value, "")
    }

    func testMultipleCardsIndependent() {
        let card1 = StatCardComponent(icon: "star", title: "Card 1", value: "1", color: .red)
        let card2 = StatCardComponent(icon: "heart", title: "Card 2", value: "2", color: .blue)

        XCTAssertNotEqual(card1.icon, card2.icon)
        XCTAssertNotEqual(card1.title, card2.title)
        XCTAssertNotEqual(card1.value, card2.value)
        XCTAssertNotEqual(card1.color, card2.color)
    }
}
