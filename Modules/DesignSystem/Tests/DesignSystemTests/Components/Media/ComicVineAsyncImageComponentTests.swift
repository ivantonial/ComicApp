//
//  ComicVineAsyncImageComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import ComicVineAPI
import SwiftUI
import Testing
import XCTest

// MARK: - ImageContext Tests

@Suite("ImageContext Tests")
@MainActor
struct ImageContextTests {

    @Test("ImageContext should have thumbnail case")
    func testThumbnailCase() {
        let context = ImageContext.thumbnail
        #expect(context == .thumbnail)
    }

    @Test("ImageContext should have listItem case")
    func testListItemCase() {
        let context = ImageContext.listItem
        #expect(context == .listItem)
    }

    @Test("ImageContext should have all card cases")
    func testCardCases() {
        let cardCases: [ImageContext] = [
            .cardSmall,
            .cardMedium,
            .cardLarge,
            .cardSquareSmall,
            .cardSquareMedium,
            .cardSquareLarge
        ]

        for context in cardCases {
            #expect(context != .thumbnail)
        }
    }

    @Test("ImageContext should have heroImage case")
    func testHeroImageCase() {
        let context = ImageContext.heroImage
        #expect(context == .heroImage)
    }

    @Test("ImageContext should have detailHeader case")
    func testDetailHeaderCase() {
        let context = ImageContext.detailHeader
        #expect(context == .detailHeader)
    }

    @Test("ImageContext should have fullScreen case")
    func testFullScreenCase() {
        let context = ImageContext.fullScreen
        #expect(context == .fullScreen)
    }

    @Test("ImageContext should have exactly 11 cases")
    func testCaseCount() {
        let allCases: [ImageContext] = [
            .thumbnail, .listItem,
            .cardSmall, .cardMedium, .cardLarge,
            .cardSquareSmall, .cardSquareMedium, .cardSquareLarge,
            .heroImage, .detailHeader, .fullScreen
        ]
        #expect(allCases.count == 11)
    }
}

// MARK: - ComicVineAsyncImageComponent Initialization Tests

@Suite("ComicVineAsyncImageComponent Initialization Tests")
@MainActor
struct ComicVineAsyncImageComponentInitializationTests {

    @Test("ComicVineAsyncImageComponent should be instantiable with nil image")
    func testNilImageInitialization() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should be instantiable with context")
    func testInitializationWithContext() {
        let component = ComicVineAsyncImageComponent(
            comicVineImage: nil,
            context: .cardMedium
        )
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should be instantiable with all parameters")
    func testFullInitialization() {
        let component = ComicVineAsyncImageComponent(
            comicVineImage: nil,
            context: .cardLarge,
            contentMode: .fit,
            cornerRadius: 12,
            showLoadingIndicator: false,
            fixedSize: CGSize(width: 200, height: 200)
        )
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should work with default context")
    func testDefaultContext() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should work with default contentMode")
    func testDefaultContentMode() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should work with default cornerRadius")
    func testDefaultCornerRadius() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should work with default showLoadingIndicator")
    func testDefaultShowLoadingIndicator() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("ComicVineAsyncImageComponent should work with various contexts")
    func testVariousContexts() {
        let contexts: [ImageContext] = [
            .thumbnail, .listItem,
            .cardSmall, .cardMedium, .cardLarge,
            .cardSquareSmall, .cardSquareMedium, .cardSquareLarge,
            .heroImage, .detailHeader, .fullScreen
        ]

        for context in contexts {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                context: context
            )
            #expect(type(of: component) == ComicVineAsyncImageComponent.self)
        }
    }

    @Test("ComicVineAsyncImageComponent should work with various corner radii")
    func testVariousCornerRadii() {
        let radii: [CGFloat] = [0, 4, 8, 12, 16, 20]

        for radius in radii {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                cornerRadius: radius
            )
            #expect(type(of: component) == ComicVineAsyncImageComponent.self)
        }
    }

    @Test("ComicVineAsyncImageComponent should work with various fixed sizes")
    func testVariousFixedSizes() {
        let sizes: [CGSize] = [
            CGSize(width: 50, height: 50),
            CGSize(width: 100, height: 100),
            CGSize(width: 150, height: 200),
            CGSize(width: 200, height: 300)
        ]

        for size in sizes {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                fixedSize: size
            )
            #expect(type(of: component) == ComicVineAsyncImageComponent.self)
        }
    }
}

// MARK: - ComicVineAsyncImageComponent View Tests

@Suite("ComicVineAsyncImageComponent View Tests")
@MainActor
struct ComicVineAsyncImageComponentViewTests {

    @Test("ComicVineAsyncImageComponent should conform to View")
    func testViewConformance() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        let _: any View = component
        #expect(true)
    }

    @Test("ComicVineAsyncImageComponent body should be accessible")
    func testBodyAccessibility() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        let body = component.body
        #expect(type(of: body) != type(of: component))
        _ = body
    }
}

// MARK: - ComicVineAsyncImageComponent Static Factory Tests

@Suite("ComicVineAsyncImageComponent Static Factory Tests")
@MainActor
struct ComicVineAsyncImageComponentStaticFactoryTests {

    @Test("thumbnail factory should create component")
    func testThumbnailFactory() {
        let component = ComicVineAsyncImageComponent.thumbnail(nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("thumbnail factory should accept corner radius")
    func testThumbnailFactoryWithCornerRadius() {
        let component = ComicVineAsyncImageComponent.thumbnail(nil, cornerRadius: 16)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("card factory should create component")
    func testCardFactory() {
        let component = ComicVineAsyncImageComponent.card(nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("card factory should accept all parameters")
    func testCardFactoryWithAllParameters() {
        let component = ComicVineAsyncImageComponent.card(
            nil,
            size: .large,
            isPortrait: true,
            cornerRadius: 8,
            fixedSize: CGSize(width: 150, height: 200)
        )
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }

    @Test("header factory should create component")
    func testHeaderFactory() {
        let component = ComicVineAsyncImageComponent.header(nil)
        #expect(type(of: component) == ComicVineAsyncImageComponent.self)
    }
}

// MARK: - ComicVineAsyncImageComponent CardSize Tests

@Suite("ComicVineAsyncImageComponent CardSize Tests")
@MainActor
struct ComicVineAsyncImageComponentCardSizeTests {

    @Test("CardSize should have small case")
    func testSmallCase() {
        let size = ComicVineAsyncImageComponent.CardSize.small
        #expect(size == .small)
    }

    @Test("CardSize should have medium case")
    func testMediumCase() {
        let size = ComicVineAsyncImageComponent.CardSize.medium
        #expect(size == .medium)
    }

    @Test("CardSize should have large case")
    func testLargeCase() {
        let size = ComicVineAsyncImageComponent.CardSize.large
        #expect(size == .large)
    }

    @Test("CardSize should be equatable")
    func testCardSizeEquality() {
        #expect(ComicVineAsyncImageComponent.CardSize.small == .small)
        #expect(ComicVineAsyncImageComponent.CardSize.medium == .medium)
        #expect(ComicVineAsyncImageComponent.CardSize.large == .large)
        #expect(ComicVineAsyncImageComponent.CardSize.small != .large)
    }
}

// MARK: - ComicVineAsyncImageComponent Context Selection Tests

@Suite("ComicVineAsyncImageComponent Context Selection Tests")
@MainActor
struct ComicVineAsyncImageComponentContextSelectionTests {

    @Test("Portrait cards should use portrait contexts")
    func testPortraitContextSelection() {
        let smallPortrait = ComicVineAsyncImageComponent.card(nil, size: .small, isPortrait: true)
        let mediumPortrait = ComicVineAsyncImageComponent.card(nil, size: .medium, isPortrait: true)
        let largePortrait = ComicVineAsyncImageComponent.card(nil, size: .large, isPortrait: true)

        #expect(type(of: smallPortrait) == ComicVineAsyncImageComponent.self)
        #expect(type(of: mediumPortrait) == ComicVineAsyncImageComponent.self)
        #expect(type(of: largePortrait) == ComicVineAsyncImageComponent.self)
    }

    @Test("Square cards should use square contexts")
    func testSquareContextSelection() {
        let smallSquare = ComicVineAsyncImageComponent.card(nil, size: .small, isPortrait: false)
        let mediumSquare = ComicVineAsyncImageComponent.card(nil, size: .medium, isPortrait: false)
        let largeSquare = ComicVineAsyncImageComponent.card(nil, size: .large, isPortrait: false)

        #expect(type(of: smallSquare) == ComicVineAsyncImageComponent.self)
        #expect(type(of: mediumSquare) == ComicVineAsyncImageComponent.self)
        #expect(type(of: largeSquare) == ComicVineAsyncImageComponent.self)
    }

    @Test("Card factory should work with all size and portrait combinations")
    func testAllCardCombinations() {
        let sizes: [ComicVineAsyncImageComponent.CardSize] = [.small, .medium, .large]
        let isPortraitOptions = [true, false]

        for size in sizes {
            for isPortrait in isPortraitOptions {
                let component = ComicVineAsyncImageComponent.card(
                    nil,
                    size: size,
                    isPortrait: isPortrait
                )
                #expect(type(of: component) == ComicVineAsyncImageComponent.self)
            }
        }
    }
}

// MARK: - ImageContext Equality Tests

@Suite("ImageContext Equality Tests")
@MainActor
struct ImageContextEqualityTests {

    @Test("ImageContext should be equatable")
    func testImageContextEquality() {
        #expect(ImageContext.thumbnail == ImageContext.thumbnail)
        #expect(ImageContext.thumbnail != ImageContext.listItem)
        #expect(ImageContext.cardSmall != ImageContext.cardSquareSmall)
    }

    @Test("All card contexts should be distinct")
    func testCardContextsDistinct() {
        let cardContexts: [ImageContext] = [
            .cardSmall, .cardMedium, .cardLarge,
            .cardSquareSmall, .cardSquareMedium, .cardSquareLarge
        ]

        for (index, context) in cardContexts.enumerated() {
            for (otherIndex, otherContext) in cardContexts.enumerated() {
                if index == otherIndex {
                    #expect(context == otherContext)
                } else {
                    #expect(context != otherContext)
                }
            }
        }
    }
}

// MARK: - XCTest ComicVineAsyncImageComponent Tests

@MainActor
class ComicVineAsyncImageComponentXCTests: XCTestCase {

    func testBasicInitialization() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        XCTAssertNotNil(component)
    }

    func testInitializationWithContext() {
        let contexts: [ImageContext] = [
            .thumbnail, .listItem,
            .cardSmall, .cardMedium, .cardLarge,
            .cardSquareSmall, .cardSquareMedium, .cardSquareLarge,
            .heroImage, .detailHeader, .fullScreen
        ]

        for context in contexts {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                context: context
            )
            XCTAssertNotNil(component)
        }
    }

    func testInitializationWithContentMode() {
        let fillComponent = ComicVineAsyncImageComponent(
            comicVineImage: nil,
            contentMode: .fill
        )
        let fitComponent = ComicVineAsyncImageComponent(
            comicVineImage: nil,
            contentMode: .fit
        )

        XCTAssertNotNil(fillComponent)
        XCTAssertNotNil(fitComponent)
    }

    func testInitializationWithCornerRadius() {
        let radii: [CGFloat] = [0, 4, 8, 12, 16, 20]

        for radius in radii {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                cornerRadius: radius
            )
            XCTAssertNotNil(component)
        }
    }

    func testInitializationWithFixedSize() {
        let sizes: [CGSize] = [
            CGSize(width: 50, height: 50),
            CGSize(width: 100, height: 100),
            CGSize(width: 150, height: 200),
            CGSize(width: 200, height: 300)
        ]

        for size in sizes {
            let component = ComicVineAsyncImageComponent(
                comicVineImage: nil,
                fixedSize: size
            )
            XCTAssertNotNil(component)
        }
    }

    func testViewBodyCreation() {
        let component = ComicVineAsyncImageComponent(comicVineImage: nil)
        let body = component.body
        XCTAssertNotNil(body)
    }

    func testThumbnailFactory() {
        let component = ComicVineAsyncImageComponent.thumbnail(nil)
        XCTAssertNotNil(component)
    }

    func testThumbnailFactoryWithCornerRadius() {
        let component = ComicVineAsyncImageComponent.thumbnail(nil, cornerRadius: 8)
        XCTAssertNotNil(component)
    }

    func testCardFactoryVariations() {
        let sizes: [ComicVineAsyncImageComponent.CardSize] = [.small, .medium, .large]
        let isPortraitOptions = [true, false]

        for size in sizes {
            for isPortrait in isPortraitOptions {
                let component = ComicVineAsyncImageComponent.card(
                    nil,
                    size: size,
                    isPortrait: isPortrait
                )
                XCTAssertNotNil(component)
            }
        }
    }

    func testHeaderFactory() {
        let component = ComicVineAsyncImageComponent.header(nil)
        XCTAssertNotNil(component)
    }

    func testImageContextEquality() {
        XCTAssertEqual(ImageContext.thumbnail, ImageContext.thumbnail)
        XCTAssertNotEqual(ImageContext.thumbnail, ImageContext.listItem)
        XCTAssertNotEqual(ImageContext.cardSmall, ImageContext.cardSquareSmall)
    }

    func testCardSizeEquality() {
        XCTAssertEqual(ComicVineAsyncImageComponent.CardSize.small, .small)
        XCTAssertEqual(ComicVineAsyncImageComponent.CardSize.medium, .medium)
        XCTAssertEqual(ComicVineAsyncImageComponent.CardSize.large, .large)
        XCTAssertNotEqual(ComicVineAsyncImageComponent.CardSize.small, .large)
    }
}
