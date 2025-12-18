//
//  CharacterRelatedContentModelTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

@testable import CharacterDetail
import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - CharacterRelatedContentModel Tests

@Suite("CharacterRelatedContentModel Tests")
struct CharacterRelatedContentModelTests {

    // MARK: - Recent Comics Tests

    @Test("Should have recent comics from issue credits")
    func testRecentComicsFromIssueCredits() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(!model.relatedContent.recentComics.isEmpty)
    }

    @Test("Should limit recent comics to 5")
    func testRecentComicsLimit() {
        // Arrange - Character.detailFixture inclui 6 issue credits
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.recentComics.count <= 5)
    }

    @Test("Should have empty recent comics when no issue credits")
    func testEmptyRecentComics() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.recentComics.isEmpty)
    }

    // MARK: - Recent Series Tests

    @Test("Should have recent series from volume credits")
    func testRecentSeriesFromVolumeCredits() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(!model.relatedContent.recentSeries.isEmpty)
    }

    @Test("Should limit recent series to 5")
    func testRecentSeriesLimit() {
        // Arrange - Character.detailFixture inclui 6 volume credits
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.recentSeries.count <= 5)
    }

    @Test("Should have empty recent series when no volume credits")
    func testEmptyRecentSeries() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.recentSeries.isEmpty)
    }

    // MARK: - Has Content Tests

    @Test("Should have content when has comics or series")
    func testHasContentTrue() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.hasContent == true)
    }

    @Test("Should not have content when empty")
    func testHasContentFalse() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.hasContent == false)
    }

    // MARK: - Related Item Model Tests

    @Test("Should create comic related items with correct type")
    func testComicRelatedItemType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(firstComic.type == .comic)
        }
    }

    @Test("Should create series related items with correct type")
    func testSeriesRelatedItemType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let firstSeries = model.relatedContent.recentSeries.first {
            #expect(firstSeries.type == .series)
        }
    }

    @Test("Should have valid resource URIs for comics")
    func testComicResourceURIs() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            #expect(!comic.resourceURI.isEmpty)
        }
    }

    @Test("Should have valid resource URIs for series")
    func testSeriesResourceURIs() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for series in model.relatedContent.recentSeries {
            #expect(!series.resourceURI.isEmpty)
        }
    }
}

// MARK: - CharacterRelatedContentModel Sendable Tests

@Suite("CharacterRelatedContentModel Sendable Tests")
struct CharacterRelatedContentModelSendableTests {

    @Test("CharacterRelatedContentModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        let _: Sendable = model.relatedContent
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterRelatedContentModelXCTests: XCTestCase {

    func testRecentComicsPopulatedFromIssueCredits() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertFalse(model.relatedContent.recentComics.isEmpty)
    }

    func testRecentSeriesPopulatedFromVolumeCredits() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertFalse(model.relatedContent.recentSeries.isEmpty)
    }

    func testHasContentWhenPopulated() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertTrue(model.relatedContent.hasContent)
    }

    func testHasNoContentWhenEmpty() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertFalse(model.relatedContent.hasContent)
    }

    func testComicsLimitedToFive() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertLessThanOrEqual(model.relatedContent.recentComics.count, 5)
    }

    func testSeriesLimitedToFive() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertLessThanOrEqual(model.relatedContent.recentSeries.count, 5)
    }

    func testRelatedItemHasCorrectComicType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let comic = model.relatedContent.recentComics.first {
            XCTAssertEqual(comic.type, .comic)
        }
    }

    func testRelatedItemHasCorrectSeriesType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let series = model.relatedContent.recentSeries.first {
            XCTAssertEqual(series.type, .series)
        }
    }
}
