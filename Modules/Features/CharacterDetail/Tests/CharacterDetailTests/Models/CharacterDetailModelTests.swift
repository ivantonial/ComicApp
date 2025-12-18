//
//  CharacterDetailModelTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

@testable import CharacterDetail
import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - CharacterDetailModel Tests

@Suite("CharacterDetailModel Tests")
struct CharacterDetailModelTests {

    // MARK: - Initialization Tests

    @Test("Should create model from character")
    func testInitializationFromCharacter() {
        // Arrange
        let character = Character.detailFixture(
            id: 1,
            name: "Spider-Man",
            comicsCount: 100
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.character.id == 1)
        #expect(model.character.name == "Spider-Man")
        #expect(model.character.countOfIssueAppearances == 100)
    }

    @Test("Should create stats model correctly")
    func testStatsModelCreation() {
        // Arrange
        let character = Character.detailFixture(comicsCount: 50)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.value == 50)
        #expect(model.stats.allStats.count == 4)
    }

    @Test("Should create related content model correctly")
    func testRelatedContentModelCreation() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.relatedContent.hasContent == true)
    }

    @Test("Should create share info model correctly")
    func testShareInfoModelCreation() {
        // Arrange
        let character = Character.detailFixture(name: "Batman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.shareInfo.text.contains("Batman"))
    }

    // MARK: - Update Tests

    @Test("Should update model with new character")
    func testUpdate() {
        // Arrange
        let originalCharacter = Character.detailFixture(id: 1, name: "Spider-Man")
        let updatedCharacter = Character.detailFixture(id: 1, name: "Peter Parker")
        var model = CharacterDetailModel(from: originalCharacter)

        // Act
        model.update(with: updatedCharacter)

        // Assert
        #expect(model.character.name == "Peter Parker")
    }

    // MARK: - Minimal Character Tests

    @Test("Should handle minimal character")
    func testMinimalCharacter() {
        // Arrange
        let character = Character.minimalDetailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.character.id == 1)
        #expect(model.stats.comics.value == 0)
        #expect(model.stats.friends.value == 0)
        #expect(model.stats.powers.value == 0)
        #expect(model.stats.enemies.value == 0)
        #expect(model.relatedContent.hasContent == false)
    }

    // MARK: - Character Without Relations Tests

    @Test("Should handle character without relations")
    func testCharacterWithoutRelations() {
        // Arrange
        let character = Character.detailFixture(includeRelations: false)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.friends.value == 0)
        #expect(model.stats.powers.value == 0)
        #expect(model.stats.enemies.value == 0)
    }
}

// MARK: - CharacterDetailModel Sendable Tests

@Suite("CharacterDetailModel Sendable Tests")
struct CharacterDetailModelSendableTests {

    @Test("CharacterDetailModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        // Se compilar, o protocolo está implementado
        let _: Sendable = model
        #expect(true)
    }

    @Test("CharacterDetailModel should work across isolation boundaries")
    func testCrossIsolation() async {
        // Arrange
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        // Act - Simula envio através de boundary
        let task = Task {
            return model.character.id
        }
        let result = await task.value

        // Assert
        #expect(result == character.id)
    }
}

// MARK: - XCTest Integration Tests

class CharacterDetailModelXCTests: XCTestCase {

    func testModelCreation() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.character.id, character.id)
        XCTAssertEqual(model.character.name, character.name)
    }

    func testModelUpdate() {
        // Arrange
        let originalCharacter = Character.detailFixture(id: 1, name: "Original")
        let updatedCharacter = Character.detailFixture(id: 1, name: "Updated")
        var model = CharacterDetailModel(from: originalCharacter)

        // Act
        model.update(with: updatedCharacter)

        // Assert
        XCTAssertEqual(model.character.name, "Updated")
    }

    func testModelWithAllRelations() {
        // Arrange
        let character = Character.detailFixture(includeRelations: true)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertTrue(model.stats.friends.value > 0)
        XCTAssertTrue(model.stats.powers.value > 0)
        XCTAssertTrue(model.stats.enemies.value > 0)
    }

    func testModelShareInfoContainsCharacterName() {
        // Arrange
        let character = Character.detailFixture(name: "Wonder Woman")

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertTrue(model.shareInfo.text.contains("Wonder Woman"))
    }

    func testModelStatsHaveFourItems() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.allStats.count, 4)
    }
}
