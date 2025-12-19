//
//  ContentCardConvertibleTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - Mock Implementations

struct MockCardModel: ContentCardConvertible {
    let id: Int
    let name: String
    let imageURL: URL?

    func toContentCardModel() -> ContentCardModel {
        ContentCardModel(
            id: id,
            title: name,
            imageURL: imageURL
        )
    }
}

struct MockCardModelWithBadge: ContentCardConvertible {
    let id: Int
    let name: String
    let isFavorite: Bool

    func toContentCardModel() -> ContentCardModel {
        ContentCardModel(
            id: id,
            title: name,
            imageURL: nil,
            badge: isFavorite ? defaultBadge(icon: "star.fill", text: "Favorite", color: .red) : nil
        )
    }
}

// MARK: - ContentCardConvertible Protocol Tests

@Suite("ContentCardConvertible Protocol Tests")
@MainActor
struct ContentCardConvertibleProtocolTests {

    @Test("toContentCardModel should return valid ContentCardModel")
    func testToContentCardModelReturnsValidModel() {
        let mock = MockCardModel(id: 1, name: "Test", imageURL: nil)
        let cardModel = mock.toContentCardModel()

        #expect(cardModel.id == 1)
        #expect(cardModel.title == "Test")
    }

    @Test("toContentCardModel should preserve data")
    func testToContentCardModelPreservesData() {
        let url = URL(string: "https://example.com/image.jpg")
        let mock = MockCardModel(id: 42, name: "Spider-Man", imageURL: url)
        let cardModel = mock.toContentCardModel()

        #expect(cardModel.id == 42)
        #expect(cardModel.title == "Spider-Man")
        #expect(cardModel.imageURL == url)
    }

    @Test("toContentCardModel method should exist")
    func testMethodExists() {
        let mock = MockCardModel(id: 1, name: "Test", imageURL: nil)
        let _ = mock.toContentCardModel()
        #expect(true)
    }
}

// MARK: - Default Badge Tests

@Suite("ContentCardConvertible Default Badge Tests")
@MainActor
struct ContentCardConvertibleDefaultBadgeTests {

    @Test("defaultBadge should create BadgeModel")
    func testDefaultBadgeCreatesBadgeModel() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: true)
        let cardModel = mock.toContentCardModel()

        #expect(cardModel.badge != nil)
    }

    @Test("defaultBadge should use specified color")
    func testDefaultBadgeColor() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: true)
        let cardModel = mock.toContentCardModel()

        #expect(cardModel.badge?.color == .red)
    }

    @Test("defaultBadge should use specified icon")
    func testDefaultBadgeIcon() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: true)
        let cardModel = mock.toContentCardModel()

        #expect(cardModel.badge?.icon == "star.fill")
    }

    @Test("defaultBadge should accept custom color")
    func testDefaultBadgeCustomColor() {
        struct CustomBadgeModel: ContentCardConvertible {
            func toContentCardModel() -> ContentCardModel {
                ContentCardModel(
                    id: 1,
                    title: "Test",
                    imageURL: nil,
                    badge: defaultBadge(icon: "heart.fill", text: "Custom", color: .blue)
                )
            }
        }

        let model = CustomBadgeModel()
        let cardModel = model.toContentCardModel()

        #expect(cardModel.badge?.color == .blue)
        #expect(cardModel.badge?.icon == "heart.fill")
    }

    @Test("defaultBadge should use default red color when not specified")
    func testDefaultBadgeDefaultRedColor() {
        struct DefaultColorBadgeModel: ContentCardConvertible {
            func toContentCardModel() -> ContentCardModel {
                ContentCardModel(
                    id: 1,
                    title: "Test",
                    imageURL: nil,
                    badge: defaultBadge(icon: "star", text: "Default")
                )
            }
        }

        let model = DefaultColorBadgeModel()
        let cardModel = model.toContentCardModel()

        #expect(cardModel.badge?.color == .red)
    }
}

// MARK: - Multiple Implementations Tests

@Suite("ContentCardConvertible Multiple Implementations Tests")
@MainActor
struct ContentCardConvertibleMultipleImplementationsTests {

    @Test("Different types can implement ContentCardConvertible")
    func testDifferentTypesImplementProtocol() {
        let mock1 = MockCardModel(id: 1, name: "Model 1", imageURL: nil)
        let mock2 = MockCardModelWithBadge(id: 2, name: "Model 2", isFavorite: false)

        let card1 = mock1.toContentCardModel()
        let card2 = mock2.toContentCardModel()

        #expect(card1.id != card2.id)
    }

    @Test("Collection of convertibles should work")
    func testCollectionOfConvertibles() {
        let items: [any ContentCardConvertible] = [
            MockCardModel(id: 1, name: "Item 1", imageURL: nil),
            MockCardModel(id: 2, name: "Item 2", imageURL: nil),
            MockCardModel(id: 3, name: "Item 3", imageURL: nil)
        ]

        let cards = items.map { $0.toContentCardModel() }

        #expect(cards.count == 3)
        #expect(cards[0].id == 1)
        #expect(cards[1].id == 2)
        #expect(cards[2].id == 3)
    }
}

// MARK: - XCTest ContentCardConvertible Tests

@MainActor
class ContentCardConvertibleXCTests: XCTestCase {

    func testBasicConversion() {
        let mock = MockCardModel(id: 1, name: "Test", imageURL: nil)
        let cardModel = mock.toContentCardModel()

        XCTAssertEqual(cardModel.id, 1)
        XCTAssertEqual(cardModel.title, "Test")
        XCTAssertNil(cardModel.imageURL)
    }

    func testConversionWithURL() {
        let url = URL(string: "https://example.com/image.jpg")
        let mock = MockCardModel(id: 1, name: "Test", imageURL: url)
        let cardModel = mock.toContentCardModel()

        XCTAssertEqual(cardModel.imageURL, url)
    }

    func testConversionWithBadge() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: true)
        let cardModel = mock.toContentCardModel()

        XCTAssertNotNil(cardModel.badge)
        XCTAssertEqual(cardModel.badge?.text, "Favorite")
    }

    func testConversionWithoutBadge() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: false)
        let cardModel = mock.toContentCardModel()

        XCTAssertNil(cardModel.badge)
    }

    func testDefaultBadgeMethod() {
        let mock = MockCardModelWithBadge(id: 1, name: "Test", isFavorite: true)
        let cardModel = mock.toContentCardModel()

        XCTAssertEqual(cardModel.badge?.icon, "star.fill")
        XCTAssertEqual(cardModel.badge?.color, .red)
    }

    func testMultipleConversions() {
        let mocks = (1...10).map { MockCardModel(id: $0, name: "Item \($0)", imageURL: nil) }
        let cards = mocks.map { $0.toContentCardModel() }

        XCTAssertEqual(cards.count, 10)

        for (index, card) in cards.enumerated() {
            XCTAssertEqual(card.id, index + 1)
        }
    }

    func testIdentityPreservation() {
        let originalId = 999
        let originalName = "Original Name"

        let mock = MockCardModel(id: originalId, name: originalName, imageURL: nil)
        let cardModel = mock.toContentCardModel()

        XCTAssertEqual(cardModel.id, originalId)
        XCTAssertEqual(cardModel.title, originalName)
    }
}
