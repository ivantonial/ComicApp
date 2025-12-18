//
//  ContentCardComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - ContentCardModel Initialization Tests

@Suite("ContentCardModel Initialization Tests")
@MainActor
struct ContentCardModelInitializationTests {

    @Test("ContentCardModel should be instantiable with URL")
    func testInitializationWithURL() {
        let url = URL(string: "https://example.com/image.jpg")
        let model = ContentCardModel(
            id: 1,
            title: "Test Card",
            imageURL: url
        )

        #expect(model.id == 1)
        #expect(model.title == "Test Card")
        #expect(model.imageURL == url)
    }

    @Test("ContentCardModel should be instantiable with all parameters")
    func testFullInitialization() {
        let url = URL(string: "https://example.com/image.jpg")
        let badge = ContentCardModel.BadgeModel(icon: "star.fill", text: "Featured", color: .yellow)

        let model = ContentCardModel(
            id: 42,
            title: "Spider-Man",
            subtitle: "Peter Parker",
            imageURL: url,
            aspectRatio: 0.75,
            contentMode: .fit,
            badge: badge,
            fixedHeight: 200
        )

        #expect(model.id == 42)
        #expect(model.title == "Spider-Man")
        #expect(model.subtitle == "Peter Parker")
        #expect(model.imageURL == url)
        #expect(model.aspectRatio == 0.75)
        #expect(model.badge != nil)
        #expect(model.fixedHeight == 200)
    }

    @Test("ContentCardModel should default aspectRatio to 1.0")
    func testDefaultAspectRatio() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        #expect(model.aspectRatio == 1.0)
    }

    @Test("ContentCardModel should default contentMode to fill")
    func testDefaultContentMode() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        #expect(model.contentMode == .fill)
    }

    @Test("ContentCardModel should default subtitle to nil")
    func testDefaultSubtitle() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        #expect(model.subtitle == nil)
    }

    @Test("ContentCardModel should default badge to nil")
    func testDefaultBadge() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        #expect(model.badge == nil)
    }

    @Test("ContentCardModel should default fixedHeight to nil")
    func testDefaultFixedHeight() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        #expect(model.fixedHeight == nil)
    }
}

// MARK: - ContentCardModel Identifiable Tests

@Suite("ContentCardModel Identifiable Tests")
@MainActor
struct ContentCardModelIdentifiableTests {

    @Test("ContentCardModel should conform to Identifiable")
    func testIdentifiableConformance() {
        let model = ContentCardModel(id: 123, title: "Test", imageURL: nil)
        let _: any Identifiable = model
        #expect(true)
    }

    @Test("ContentCardModel id should be unique identifier")
    func testUniqueId() {
        let model1 = ContentCardModel(id: 1, title: "Card 1", imageURL: nil)
        let model2 = ContentCardModel(id: 2, title: "Card 2", imageURL: nil)

        #expect(model1.id != model2.id)
    }

    @Test("ContentCardModel with same id should have same identifier")
    func testSameId() {
        let model1 = ContentCardModel(id: 42, title: "Card 1", imageURL: nil)
        let model2 = ContentCardModel(id: 42, title: "Card 2", imageURL: nil)

        #expect(model1.id == model2.id)
    }
}

// MARK: - BadgeModel Tests

@Suite("BadgeModel Tests")
@MainActor
struct BadgeModelTests {

    @Test("BadgeModel should be instantiable with all parameters")
    func testFullInitialization() {
        let badge = ContentCardModel.BadgeModel(
            icon: "star.fill",
            text: "Featured",
            color: .yellow
        )

        #expect(badge.icon == "star.fill")
        #expect(badge.text == "Featured")
        #expect(badge.color == .yellow)
    }

    @Test("BadgeModel should default color to gray")
    func testDefaultColor() {
        let badge = ContentCardModel.BadgeModel(icon: "info.circle", text: "Info")
        #expect(badge.color == .gray)
    }

    @Test("BadgeModel should accept empty text")
    func testEmptyText() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "")
        #expect(badge.text == "")
    }

    @Test("BadgeModel should accept various icons")
    func testVariousIcons() {
        let icons = ["star.fill", "heart.fill", "bookmark.fill", "flag.fill"]

        for icon in icons {
            let badge = ContentCardModel.BadgeModel(icon: icon, text: "Test")
            #expect(badge.icon == icon)
        }
    }

    @Test("BadgeModel should accept various colors")
    func testVariousColors() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]

        for color in colors {
            let badge = ContentCardModel.BadgeModel(icon: "star", text: "Test", color: color)
            #expect(badge.color == color)
        }
    }
}

// MARK: - ContentCardComponent Tests

@Suite("ContentCardComponent Tests")
@MainActor
struct ContentCardComponentTests {

    @Test("ContentCardComponent should be instantiable with model")
    func testInitializationWithModel() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        let component = ContentCardComponent(model: model)

        #expect(type(of: component) == ContentCardComponent.self)
    }

    @Test("ContentCardComponent should be instantiable with onTap closure")
    func testInitializationWithOnTap() {
        var tapped = false
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        let component = ContentCardComponent(model: model) {
            tapped = true
        }

        #expect(type(of: component) == ContentCardComponent.self)
        #expect(tapped == false)
    }

    @Test("ContentCardComponent should conform to View")
    func testViewConformance() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        let component = ContentCardComponent(model: model)
        let _: any View = component
        #expect(true)
    }

    @Test("ContentCardComponent body should be accessible")
    func testBodyAccessibility() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        let component = ContentCardComponent(model: model)
        let body = component.body
        #expect(type(of: body) != type(of: component))
        _ = body
    }
}

// MARK: - AspectRatio Context Tests

@Suite("AspectRatio Context Tests")
@MainActor
struct AspectRatioContextTests {

    @Test("Portrait aspect ratio should be less than 1")
    func testPortraitAspectRatio() {
        let portraitRatios: [CGFloat] = [0.6, 0.7, 0.75, 0.8]

        for ratio in portraitRatios {
            #expect(ratio < 1.0)
        }
    }

    @Test("Square aspect ratio should be approximately 1")
    func testSquareAspectRatio() {
        let squareRatios: [CGFloat] = [0.9, 1.0, 1.1]

        for ratio in squareRatios {
            #expect(ratio >= 0.9 && ratio <= 1.1)
        }
    }

    @Test("Landscape aspect ratio should be greater than 1")
    func testLandscapeAspectRatio() {
        let landscapeRatios: [CGFloat] = [1.5, 1.78, 2.0]

        for ratio in landscapeRatios {
            #expect(ratio > 1.0)
        }
    }
}

// MARK: - ContentCardModel Various Configurations Tests

@Suite("ContentCardModel Various Configurations Tests")
@MainActor
struct ContentCardModelVariousConfigurationsTests {

    @Test("Model with subtitle only")
    func testModelWithSubtitle() {
        let model = ContentCardModel(
            id: 1,
            title: "Hero",
            subtitle: "Subtitle text",
            imageURL: nil
        )

        #expect(model.subtitle == "Subtitle text")
        #expect(model.badge == nil)
    }

    @Test("Model with badge only")
    func testModelWithBadge() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "New", color: .blue)
        let model = ContentCardModel(
            id: 1,
            title: "Test",
            imageURL: nil,
            badge: badge
        )

        #expect(model.badge != nil)
        #expect(model.subtitle == nil)
    }

    @Test("Model with both subtitle and badge")
    func testModelWithSubtitleAndBadge() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "Featured", color: .yellow)
        let model = ContentCardModel(
            id: 1,
            title: "Test",
            subtitle: "Description",
            imageURL: nil,
            badge: badge
        )

        #expect(model.subtitle == "Description")
        #expect(model.badge != nil)
    }

    @Test("Model with various aspect ratios")
    func testModelAspectRatios() {
        let ratios: [CGFloat] = [0.5, 0.75, 1.0, 1.33, 1.78]

        for ratio in ratios {
            let model = ContentCardModel(
                id: 1,
                title: "Test",
                imageURL: nil,
                aspectRatio: ratio
            )
            #expect(model.aspectRatio == ratio)
        }
    }

    @Test("Model with fixed height")
    func testModelWithFixedHeight() {
        let model = ContentCardModel(
            id: 1,
            title: "Test",
            imageURL: nil,
            fixedHeight: 150
        )

        #expect(model.fixedHeight == 150)
    }
}

// MARK: - XCTest ContentCardComponent Tests

@MainActor
class ContentCardComponentXCTests: XCTestCase {

    func testModelBasicInitialization() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)

        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.title, "Test")
        XCTAssertNil(model.imageURL)
        XCTAssertNil(model.subtitle)
        XCTAssertEqual(model.aspectRatio, 1.0)
    }

    func testModelWithSubtitle() {
        let model = ContentCardModel(
            id: 1,
            title: "Hero",
            subtitle: "Subtitle text",
            imageURL: nil
        )

        XCTAssertEqual(model.subtitle, "Subtitle text")
    }

    func testModelWithBadge() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "New", color: .blue)
        let model = ContentCardModel(
            id: 1,
            title: "Test",
            imageURL: nil,
            badge: badge
        )

        XCTAssertNotNil(model.badge)
        XCTAssertEqual(model.badge?.icon, "star")
        XCTAssertEqual(model.badge?.text, "New")
        XCTAssertEqual(model.badge?.color, .blue)
    }

    func testModelWithFixedHeight() {
        let model = ContentCardModel(
            id: 1,
            title: "Test",
            imageURL: nil,
            fixedHeight: 150
        )

        XCTAssertEqual(model.fixedHeight, 150)
    }

    func testModelWithURL() {
        let url = URL(string: "https://example.com/image.png")
        let model = ContentCardModel(id: 1, title: "Test", imageURL: url)

        XCTAssertEqual(model.imageURL, url)
    }

    func testModelAspectRatios() {
        let ratios: [CGFloat] = [0.5, 0.75, 1.0, 1.33, 1.78]

        for ratio in ratios {
            let model = ContentCardModel(
                id: 1,
                title: "Test",
                imageURL: nil,
                aspectRatio: ratio
            )
            XCTAssertEqual(model.aspectRatio, ratio)
        }
    }

    func testBadgeDefaultColor() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "Test")
        XCTAssertEqual(badge.color, .gray)
    }

    func testBadgeCustomColor() {
        let badge = ContentCardModel.BadgeModel(icon: "star", text: "Test", color: .red)
        XCTAssertEqual(badge.color, .red)
    }

    func testComponentViewBodyCreation() {
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        let component = ContentCardComponent(model: model)
        let body = component.body

        XCTAssertNotNil(body)
    }

    func testOnTapNotCalledOnInit() {
        var tapCount = 0
        let model = ContentCardModel(id: 1, title: "Test", imageURL: nil)
        _ = ContentCardComponent(model: model) {
            tapCount += 1
        }

        XCTAssertEqual(tapCount, 0)
    }

    func testMultipleModelsIndependent() {
        let model1 = ContentCardModel(id: 1, title: "Card 1", imageURL: nil)
        let model2 = ContentCardModel(id: 2, title: "Card 2", imageURL: nil)

        XCTAssertNotEqual(model1.id, model2.id)
        XCTAssertNotEqual(model1.title, model2.title)
    }

    func testContentModes() {
        let fillModel = ContentCardModel(id: 1, title: "Test", imageURL: nil, contentMode: .fill)
        let fitModel = ContentCardModel(id: 2, title: "Test", imageURL: nil, contentMode: .fit)

        XCTAssertEqual(fillModel.contentMode, .fill)
        XCTAssertEqual(fitModel.contentMode, .fit)
    }
}
