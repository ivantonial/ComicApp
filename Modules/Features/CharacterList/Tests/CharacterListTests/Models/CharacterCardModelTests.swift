//
//  CharacterCardModelTests.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import CharacterList
@testable import ComicVineAPI
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - CharacterCardModel Creation Tests

@Suite("CharacterCardModel Creation Tests")
struct CharacterCardModelCreationTests {

    @Test("Should create model with all parameters")
    func testCreateWithAllParameters() {
        // Arrange
        let image = ComicVineImage.listFixture()

        // Act
        let model = CharacterCardModel(
            id: 42,
            name: "Batman",
            comicVineImage: image,
            comicsCount: 500,
            aspectRatio: 1.5
        )

        // Assert
        #expect(model.id == 42)
        #expect(model.name == "Batman")
        #expect(model.comicVineImage != nil)
        #expect(model.comicsCount == 500)
        #expect(model.aspectRatio == 1.5)
    }

    @Test("Should use default aspect ratio of 1.0")
    func testDefaultAspectRatio() {
        // Act
        let model = CharacterCardModel(
            id: 1,
            name: "Spider-Man",
            comicVineImage: nil,
            comicsCount: 100
        )

        // Assert
        #expect(model.aspectRatio == 1.0)
    }

    @Test("Should create model from Character")
    func testCreateFromCharacter() {
        // Arrange
        let character = Character.listFixture(
            id: 10,
            name: "Wonder Woman",
            comicsCount: 200
        )

        // Act
        let model = CharacterCardModel(from: character)

        // Assert
        #expect(model.id == 10)
        #expect(model.name == "Wonder Woman")
        #expect(model.comicsCount == 200)
        #expect(model.aspectRatio == 1.0)
    }

    @Test("Should preserve character image")
    func testPreserveCharacterImage() {
        // Arrange
        let character = Character.listFixture(hasImage: true)

        // Act
        let model = CharacterCardModel(from: character)

        // Assert
        #expect(model.comicVineImage != nil)
        #expect(model.comicVineImage?.mediumUrl != nil)
    }

    @Test("Should handle character without image")
    func testHandleCharacterWithoutImage() {
        // Arrange
        let character = Character.listFixture(hasImage: false)

        // Act
        let model = CharacterCardModel(from: character)

        // Assert
        #expect(model.comicVineImage != nil) // Ainda existe, mas vazio
    }
}

// MARK: - CharacterCardModel Identifiable Tests

@Suite("CharacterCardModel Identifiable Tests")
struct CharacterCardModelIdentifiableTests {

    @Test("Should be identifiable by id")
    func testIdentifiable() {
        // Arrange
        let model1 = CharacterCardModel(
            id: 1,
            name: "Hero A",
            comicVineImage: nil,
            comicsCount: 10
        )
        let model2 = CharacterCardModel(
            id: 2,
            name: "Hero B",
            comicVineImage: nil,
            comicsCount: 20
        )

        // Assert
        #expect(model1.id != model2.id)
        #expect(model1.id == 1)
        #expect(model2.id == 2)
    }

    @Test("Models with same id should have same identifier")
    func testSameId() {
        // Arrange
        let model1 = CharacterCardModel(
            id: 42,
            name: "Batman",
            comicVineImage: nil,
            comicsCount: 100
        )
        let model2 = CharacterCardModel(
            id: 42,
            name: "Batman Updated",
            comicVineImage: nil,
            comicsCount: 200
        )

        // Assert
        #expect(model1.id == model2.id)
    }
}

// MARK: - CharacterCardModel ContentCardConvertible Tests

@Suite("CharacterCardModel ContentCardConvertible Tests")
struct CharacterCardModelContentCardConvertibleTests {

    @Test("Should convert to ContentCardModel correctly")
    func testToContentCardModel() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Spider-Man",
            comicVineImage: nil,
            comicsCount: 150
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.id == 1)
        #expect(contentModel.title == "Spider-Man")
        #expect(contentModel.subtitle == nil)
        #expect(contentModel.aspectRatio == 1.0)
        #expect(contentModel.contentMode == .fill)
    }

    @Test("Should preserve image in content card")
    func testPreserveImageInContentCard() {
        // Arrange
        let image = ComicVineImage.listFixture()
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Batman",
            comicVineImage: image,
            comicsCount: 100
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.comicVineImage != nil)
    }

    @Test("Should use fill content mode")
    func testContentModeFill() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Superman",
            comicVineImage: nil,
            comicsCount: 50
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.contentMode == .fill)
    }

    @Test("Should include badge with comics count")
    func testBadgeWithComicsCount() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Flash",
            comicVineImage: nil,
            comicsCount: 75
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.badge != nil)
        #expect(contentModel.badge?.text == "75 comics")
        #expect(contentModel.badge?.icon == "book.fill")
    }

    @Test("Should have nil fixed height")
    func testNilFixedHeight() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Aquaman",
            comicVineImage: nil,
            comicsCount: 30
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.fixedHeight == nil)
    }

    @Test("Should respect custom aspect ratio")
    func testCustomAspectRatio() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Green Lantern",
            comicVineImage: nil,
            comicsCount: 80,
            aspectRatio: 0.75
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.aspectRatio == 0.75)
    }
}

// MARK: - CharacterCardModel Edge Cases Tests

@Suite("CharacterCardModel Edge Cases Tests")
struct CharacterCardModelEdgeCasesTests {

    @Test("Should handle zero comics count")
    func testZeroComicsCount() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "New Hero",
            comicVineImage: nil,
            comicsCount: 0
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.badge?.text == "0 comics")
    }

    @Test("Should handle large comics count")
    func testLargeComicsCount() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Popular Hero",
            comicVineImage: nil,
            comicsCount: 10000
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.badge?.text == "10000 comics")
    }

    @Test("Should handle empty name")
    func testEmptyName() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "",
            comicVineImage: nil,
            comicsCount: 10
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.title.isEmpty)
    }

    @Test("Should handle special characters in name")
    func testSpecialCharactersInName() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Spider-Man (Peter Parker)",
            comicVineImage: nil,
            comicsCount: 100
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.title == "Spider-Man (Peter Parker)")
    }

    @Test("Should handle unicode characters in name")
    func testUnicodeCharactersInName() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Hérói Çãràcter",
            comicVineImage: nil,
            comicsCount: 50
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        #expect(contentModel.title == "Hérói Çãràcter")
    }
}

// MARK: - XCTest Integration Tests

class CharacterCardModelXCTests: XCTestCase {

    func testCharacterCardModelCreation() {
        // Arrange & Act
        let model = CharacterCardModel(
            id: 1,
            name: "Test Hero",
            comicVineImage: nil,
            comicsCount: 100
        )

        // Assert
        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.name, "Test Hero")
        XCTAssertEqual(model.comicsCount, 100)
        XCTAssertEqual(model.aspectRatio, 1.0, accuracy: 0.001)
    }

    func testCharacterCardModelFromCharacter() {
        // Arrange
        let character = Character.listFixture(
            id: 5,
            name: "Test Character",
            comicsCount: 75
        )

        // Act
        let model = CharacterCardModel(from: character)

        // Assert
        XCTAssertEqual(model.id, character.id)
        XCTAssertEqual(model.name, character.name)
        XCTAssertEqual(model.comicsCount, character.countOfIssueAppearances)
    }

    func testContentCardConversion() {
        // Arrange
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Conversion Test",
            comicVineImage: nil,
            comicsCount: 50
        )

        // Act
        let contentModel = cardModel.toContentCardModel()

        // Assert
        XCTAssertEqual(contentModel.id, cardModel.id)
        XCTAssertEqual(contentModel.title, cardModel.name)
        XCTAssertNil(contentModel.subtitle)
        XCTAssertEqual(contentModel.contentMode, .fill)
    }

    func testMultipleModelsCreation() {
        // Arrange
        let characters: [Character] = .listFixtures(count: 10)

        // Act
        let models = characters.map { CharacterCardModel(from: $0) }

        // Assert
        XCTAssertEqual(models.count, 10)

        for (index, model) in models.enumerated() {
            XCTAssertEqual(model.id, index + 1)
            XCTAssertEqual(model.name, "Hero \(index + 1)")
        }
    }
}
