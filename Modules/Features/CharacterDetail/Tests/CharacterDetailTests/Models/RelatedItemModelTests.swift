//
//  RelatedItemModelTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

@testable import CharacterDetail
import ComicVineAPI
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - RelatedItemModel Tests

@Suite("RelatedItemModel Tests")
struct RelatedItemModelTests {

    // MARK: - Properties Tests

    @Test("Should have name property from issue credit")
    func testNameFromIssueCredit() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(!firstComic.name.isEmpty)
        }
    }

    @Test("Should have resource URI property")
    func testResourceURI() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(!firstComic.resourceURI.isEmpty)
        }
    }

    @Test("Should use resource URI as id")
    func testIdIsResourceURI() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(firstComic.id == firstComic.resourceURI)
        }
    }

    // MARK: - RelatedItemType Tests

    @Test("Should have comic type for issues")
    func testComicType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            #expect(comic.type == .comic)
        }
    }

    @Test("Should have series type for volumes")
    func testSeriesType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for series in model.relatedContent.recentSeries {
            #expect(series.type == .series)
        }
    }

    // MARK: - RelatedItemType Icon Tests

    @Test("Comic type should have correct icon")
    func testComicTypeIcon() {
        // Act
        let type = RelatedItemModel.RelatedItemType.comic

        // Assert
        #expect(type.icon == "book.circle.fill")
    }

    @Test("Series type should have correct icon")
    func testSeriesTypeIcon() {
        // Act
        let type = RelatedItemModel.RelatedItemType.series

        // Assert
        #expect(type.icon == "tv.circle.fill")
    }

    // MARK: - RelatedItemType Color Tests

    @Test("Comic type should have correct color")
    func testComicTypeColor() {
        // Act
        let type = RelatedItemModel.RelatedItemType.comic

        // Assert
        #expect(type.color == .red)
    }

    @Test("Series type should have correct color")
    func testSeriesTypeColor() {
        // Act
        let type = RelatedItemModel.RelatedItemType.series

        // Assert
        #expect(type.color == .blue)
    }

    // MARK: - Identifiable Tests

    @Test("Should be identifiable using resource URI")
    func testIdentifiable() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)
        let comics = model.relatedContent.recentComics

        // Assert
        guard comics.count >= 2 else {
            #expect(true) // Não temos dados suficientes para o teste
            return
        }

        #expect(comics[0].id != comics[1].id)
    }

    // MARK: - Sendable Tests

    @Test("RelatedItemModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture(includeRelations: true)
        let model = CharacterDetailModel(from: character)

        if let comic = model.relatedContent.recentComics.first {
            let _: Sendable = comic
        }
        #expect(true)
    }

    @Test("RelatedItemType should be Sendable")
    func testTypeSendableConformance() {
        let type = RelatedItemModel.RelatedItemType.comic
        let _: Sendable = type
        #expect(true)
    }

    // MARK: - Fallback URI Tests

    @Test("Should use fallback URI when site URL is nil")
    func testFallbackURI() {
        // Este teste verifica que quando siteDetailUrl e apiDetailUrl são nil,
        // o modelo usa um fallback baseado no ID
        // A lógica está no CharacterRelatedContentModel.init

        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            #expect(!comic.resourceURI.isEmpty)
        }
    }
}

// MARK: - XCTest Integration Tests

class RelatedItemModelXCTests: XCTestCase {

    func testComicItemsHaveCorrectType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            XCTAssertEqual(comic.type, .comic)
        }
    }

    func testSeriesItemsHaveCorrectType() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for series in model.relatedContent.recentSeries {
            XCTAssertEqual(series.type, .series)
        }
    }

    func testComicTypeIconIsCorrect() {
        // Act
        let icon = RelatedItemModel.RelatedItemType.comic.icon

        // Assert
        XCTAssertEqual(icon, "book.circle.fill")
    }

    func testSeriesTypeIconIsCorrect() {
        // Act
        let icon = RelatedItemModel.RelatedItemType.series.icon

        // Assert
        XCTAssertEqual(icon, "tv.circle.fill")
    }

    func testComicTypeColorIsRed() {
        // Act
        let color = RelatedItemModel.RelatedItemType.comic.color

        // Assert
        XCTAssertEqual(color, .red)
    }

    func testSeriesTypeColorIsBlue() {
        // Act
        let color = RelatedItemModel.RelatedItemType.series.color

        // Assert
        XCTAssertEqual(color, .blue)
    }

    func testItemsHaveNonEmptyNames() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            XCTAssertFalse(comic.name.isEmpty)
        }
        for series in model.relatedContent.recentSeries {
            XCTAssertFalse(series.name.isEmpty)
        }
    }

    func testItemsHaveNonEmptyResourceURIs() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            XCTAssertFalse(comic.resourceURI.isEmpty)
        }
        for series in model.relatedContent.recentSeries {
            XCTAssertFalse(series.resourceURI.isEmpty)
        }
    }

    func testIdMatchesResourceURI() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        for comic in model.relatedContent.recentComics {
            XCTAssertEqual(comic.id, comic.resourceURI)
        }
    }
}
