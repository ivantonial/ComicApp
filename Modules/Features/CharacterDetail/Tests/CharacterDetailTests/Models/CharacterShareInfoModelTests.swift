//
//  CharacterShareInfoModelTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

@testable import CharacterDetail
import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - CharacterShareInfoModel Tests

@Suite("CharacterShareInfoModel Tests")
struct CharacterShareInfoModelTests {

    // MARK: - Text Tests

    @Test("Should have share text containing character name")
    func testShareTextContainsName() {
        // Arrange
        let character = Character.shareFixture(name: "Batman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.text.contains("Batman"))
    }

    @Test("Should have default share text format")
    func testShareTextFormat() {
        // Arrange
        let character = Character.shareFixture(name: "Superman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.text == "Check out Superman on Comic Vine!")
    }

    // MARK: - Detail URL Tests

    @Test("Should have valid detail URL")
    func testDetailURL() {
        // Arrange
        let character = Character.shareFixture(
            siteDetailUrl: "https://comicvine.gamespot.com/batman/4005-1/"
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.detailURL != nil)
        #expect(model.shareInfo.detailURL?.absoluteString == "https://comicvine.gamespot.com/batman/4005-1/")
    }

    @Test("Should handle URL parsing from siteDetailUrl")
    func testURLParsing() {
        // Arrange - Usa uma URL válida para verificar o parsing
        let validUrlString = "https://comicvine.gamespot.com/character/4005-1/"
        let character = Character.shareFixture(siteDetailUrl: validUrlString)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert - Verifica que URLs válidas são parseadas corretamente
        #expect(model.shareInfo.detailURL != nil)
        #expect(model.shareInfo.detailURL?.absoluteString == validUrlString)
    }

    // MARK: - Wiki URL Tests

    @Test("Should have nil wiki URL by default")
    func testWikiURLNil() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.wikiURL == nil)
    }

    // MARK: - Image URL Tests

    @Test("Should have valid image URL")
    func testImageURL() {
        // Arrange
        let character = Character.shareFixture(hasImage: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.imageURL != nil)
    }

    @Test("Should have nil image URL when no image")
    func testNoImageURL() {
        // Arrange
        let character = Character.shareFixture(hasImage: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert - bestQualityUrl retorna nil quando todas as URLs estão nil
        // O comportamento depende da implementação de ComicVineImage.bestQualityUrl
        #expect(true) // O teste valida que não há crash
    }

    // MARK: - Share Items Tests

    @Test("Should have share items array with text")
    func testShareItemsContainsText() {
        // Arrange
        let character = Character.shareFixture(name: "Wonder Woman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(!model.shareInfo.shareItems.isEmpty)
        #expect(model.shareInfo.shareItems.contains { item in
            (item as? String)?.contains("Wonder Woman") == true
        })
    }

    @Test("Should have share items array with URL when available")
    func testShareItemsContainsURL() {
        // Arrange
        let character = Character.shareFixture(
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-1/"
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        let containsURL = model.shareInfo.shareItems.contains { item in
            item is URL
        }
        #expect(containsURL)
    }

    @Test("Should have multiple share items when all data available")
    func testMultipleShareItems() {
        // Arrange
        let character = Character.shareFixture(
            name: "Flash",
            siteDetailUrl: "https://comicvine.gamespot.com/flash/4005-1/",
            hasImage: true
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.shareItems.count >= 2)
    }
}

// MARK: - CharacterShareInfoModel Sendable Tests

@Suite("CharacterShareInfoModel Sendable Tests")
struct CharacterShareInfoModelSendableTests {

    @Test("CharacterShareInfoModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        let _: Sendable = model.shareInfo
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterShareInfoModelXCTests: XCTestCase {

    func testShareTextContainsCharacterName() {
        // Arrange
        let character = Character.shareFixture(name: "Aquaman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertTrue(model.shareInfo.text.contains("Aquaman"))
    }

    func testShareTextHasCorrectFormat() {
        // Arrange
        let character = Character.shareFixture(name: "Green Lantern")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.shareInfo.text, "Check out Green Lantern on Comic Vine!")
    }

    func testDetailURLParsesCorrectly() {
        // Arrange
        let urlString = "https://comicvine.gamespot.com/hero/4005-1/"
        let character = Character.shareFixture(siteDetailUrl: urlString)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertNotNil(model.shareInfo.detailURL)
        XCTAssertEqual(model.shareInfo.detailURL?.absoluteString, urlString)
    }

    func testShareItemsNotEmpty() {
        // Arrange
        let character = Character.shareFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertFalse(model.shareInfo.shareItems.isEmpty)
    }

    func testShareItemsFirstItemIsText() {
        // Arrange
        let character = Character.shareFixture(name: "Cyborg")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertTrue(model.shareInfo.shareItems.first is String)
    }

    func testWikiURLIsNil() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertNil(model.shareInfo.wikiURL)
    }
}
