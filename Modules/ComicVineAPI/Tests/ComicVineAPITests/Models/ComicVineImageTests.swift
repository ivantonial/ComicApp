//
//  ComicVineImageTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - ComicVineImage Model Tests

@Suite("ComicVineImage Model Tests")
struct ComicVineImageModelTests {

    // MARK: - Initialization Tests

    @Test("ComicVineImage should initialize with all URLs")
    func testFullInitialization() {
        let image = ComicVineImage.apiFixture()

        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.screenUrl != nil)
        #expect(image.screenLargeUrl != nil)
        #expect(image.smallUrl != nil)
        #expect(image.superUrl != nil)
        #expect(image.thumbUrl != nil)
        #expect(image.tinyUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage should initialize with empty values")
    func testEmptyInitialization() {
        let image = ComicVineImage.emptyFixture()

        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.screenUrl == nil)
        #expect(image.screenLargeUrl == nil)
        #expect(image.smallUrl == nil)
        #expect(image.superUrl == nil)
        #expect(image.thumbUrl == nil)
        #expect(image.tinyUrl == nil)
        #expect(image.originalUrl == nil)
    }

    @Test("ComicVineImage should initialize with default values")
    func testDefaultInitialization() {
        let image = ComicVineImage()

        #expect(image.iconUrl == nil)
        #expect(image.originalUrl == nil)
    }

    // MARK: - bestQualityUrl Tests

    @Test("bestQualityUrl should return originalUrl when available")
    func testBestQualityUrlOriginal() {
        let image = ComicVineImage.originalOnlyFixture(
            originalUrl: "https://example.com/original.jpg"
        )

        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/original.jpg")
    }

    @Test("bestQualityUrl should fallback to superUrl")
    func testBestQualityUrlSuper() {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: "https://example.com/super.jpg",
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )

        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/super.jpg")
    }

    @Test("bestQualityUrl should fallback to screenLargeUrl")
    func testBestQualityUrlScreenLarge() {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: "https://example.com/screen_large.jpg",
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )

        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/screen_large.jpg")
    }

    @Test("bestQualityUrl should return nil when no URLs available")
    func testBestQualityUrlNil() {
        let image = ComicVineImage.emptyFixture()

        #expect(image.bestQualityUrl == nil)
    }

    @Test("bestQualityUrl should skip invalid URLs")
    func testBestQualityUrlSkipsInvalid() {
        let image = ComicVineImage.invalidUrlsFixture()

        #expect(image.bestQualityUrl == nil)
    }

    // MARK: - mediumQualityUrl Tests

    @Test("mediumQualityUrl should return mediumUrl when available")
    func testMediumQualityUrlMedium() {
        let image = ComicVineImage.mediumOnlyFixture(
            mediumUrl: "https://example.com/medium.jpg"
        )

        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/medium.jpg")
    }

    @Test("mediumQualityUrl should fallback to screenUrl")
    func testMediumQualityUrlScreen() {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: "https://example.com/screen.jpg",
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )

        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/screen.jpg")
    }

    @Test("mediumQualityUrl should fallback to smallUrl")
    func testMediumQualityUrlSmall() {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: "https://example.com/small.jpg",
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )

        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/small.jpg")
    }

    @Test("mediumQualityUrl should fallback to bestQualityUrl")
    func testMediumQualityUrlFallbackToBest() {
        let image = ComicVineImage.originalOnlyFixture(
            originalUrl: "https://example.com/original.jpg"
        )

        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/original.jpg")
    }

    // MARK: - thumbnailUrl Tests

    @Test("thumbnailUrl should return thumbUrl when available")
    func testThumbnailUrlThumb() {
        let image = ComicVineImage.thumbnailOnlyFixture(
            thumbUrl: "https://example.com/thumb.jpg"
        )

        #expect(image.thumbnailUrl?.absoluteString == "https://example.com/thumb.jpg")
    }

    @Test("thumbnailUrl should fallback to mediumQualityUrl")
    func testThumbnailUrlFallback() {
        let image = ComicVineImage.mediumOnlyFixture(
            mediumUrl: "https://example.com/medium.jpg"
        )

        #expect(image.thumbnailUrl?.absoluteString == "https://example.com/medium.jpg")
    }

    @Test("thumbnailUrl should return nil when no URLs available")
    func testThumbnailUrlNil() {
        let image = ComicVineImage.emptyFixture()

        #expect(image.thumbnailUrl == nil)
    }

    // MARK: - Quality Levels Tests

    @Test("Image quality should follow correct priority order")
    func testQualityPriorityOrder() {
        let image = ComicVineImage.qualityLevelsFixture()

        // Best quality should be original
        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/original.jpg")

        // Medium quality should be medium
        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/medium.jpg")

        // Thumbnail should be thumb
        #expect(image.thumbnailUrl?.absoluteString == "https://example.com/thumb.jpg")
    }
}

// MARK: - ComicVineImage Decoding Tests

@Suite("ComicVineImage Decoding Tests")
struct ComicVineImageDecodingTests {

    @Test("ComicVineImage should decode from valid JSON")
    func testDecodeFromJSON() throws {
        let json = """
        {
            "icon_url": "https://example.com/icon.jpg",
            "medium_url": "https://example.com/medium.jpg",
            "screen_url": "https://example.com/screen.jpg",
            "screen_large_url": "https://example.com/screen_large.jpg",
            "small_url": "https://example.com/small.jpg",
            "super_url": "https://example.com/super.jpg",
            "thumb_url": "https://example.com/thumb.jpg",
            "tiny_url": "https://example.com/tiny.jpg",
            "original_url": "https://example.com/original.jpg"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let image = try decoder.decode(ComicVineImage.self, from: data)

        #expect(image.iconUrl == "https://example.com/icon.jpg")
        #expect(image.originalUrl == "https://example.com/original.jpg")
    }

    @Test("ComicVineImage should decode with null values")
    func testDecodeWithNulls() throws {
        let json = """
        {
            "icon_url": null,
            "medium_url": "https://example.com/medium.jpg",
            "screen_url": null,
            "screen_large_url": null,
            "small_url": null,
            "super_url": null,
            "thumb_url": null,
            "tiny_url": null,
            "original_url": null
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let image = try decoder.decode(ComicVineImage.self, from: data)

        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == "https://example.com/medium.jpg")
        #expect(image.originalUrl == nil)
    }

    @Test("ComicVineImage should decode empty object")
    func testDecodeEmptyObject() throws {
        let json = "{}"

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let image = try decoder.decode(ComicVineImage.self, from: data)

        #expect(image.iconUrl == nil)
        #expect(image.originalUrl == nil)
    }
}

// MARK: - XCTest Integration Tests

class ComicVineImageXCTests: XCTestCase {

    func testComicVineImageSendableCompliance() {
        let image = ComicVineImage.apiFixture()
        let sendable: any Sendable = image
        XCTAssertNotNil(sendable)
    }

    func testURLConversionChain() {
        // Test with all quality levels
        let fullImage = ComicVineImage.qualityLevelsFixture()
        XCTAssertNotNil(fullImage.bestQualityUrl)
        XCTAssertNotNil(fullImage.mediumQualityUrl)
        XCTAssertNotNil(fullImage.thumbnailUrl)

        // Test with empty image
        let emptyImage = ComicVineImage.emptyFixture()
        XCTAssertNil(emptyImage.bestQualityUrl)
        XCTAssertNil(emptyImage.mediumQualityUrl)
        XCTAssertNil(emptyImage.thumbnailUrl)
    }

    func testInvalidURLHandling() {
        let image = ComicVineImage.invalidUrlsFixture()

        // URLs inválidas não devem converter para URL
        XCTAssertNil(image.bestQualityUrl)
    }
}
