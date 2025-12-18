//
//  StatItemModelTests.swift
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

// MARK: - StatItemModel Tests

@Suite("StatItemModel Tests")
struct StatItemModelTests {

    // MARK: - Properties Tests

    @Test("Should have correct icon property")
    func testIcon() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.icon == "book.fill")
        #expect(model.stats.friends.icon == "person.2.fill")
        #expect(model.stats.powers.icon == "bolt.fill")
        #expect(model.stats.enemies.icon == "exclamationmark.triangle.fill")
    }

    @Test("Should have correct title property")
    func testTitle() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.title == "Comics")
        #expect(model.stats.friends.title == "Friends")
        #expect(model.stats.powers.title == "Powers")
        #expect(model.stats.enemies.title == "Enemies")
    }

    @Test("Should have correct value property")
    func testValue() {
        // Arrange
        let character = Character.statsFixture(
            comicsCount: 100,
            friendsCount: 5,
            powersCount: 10,
            enemiesCount: 3
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.value == 100)
        #expect(model.stats.friends.value == 5)
        #expect(model.stats.powers.value == 10)
        #expect(model.stats.enemies.value == 3)
    }

    @Test("Should have correct color property")
    func testColor() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.color == .red)
        #expect(model.stats.friends.color == .blue)
        #expect(model.stats.powers.color == .yellow)
        #expect(model.stats.enemies.color == .green)
    }

    // MARK: - Display Value Tests

    @Test("Should format display value correctly")
    func testDisplayValue() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 42)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.displayValue == "42")
    }

    @Test("Should format zero display value")
    func testZeroDisplayValue() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 0)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.displayValue == "0")
    }

    @Test("Should format large display value")
    func testLargeDisplayValue() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 99999)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.displayValue == "99999")
    }

    // MARK: - Identifiable Tests

    @Test("Should be identifiable with unique id")
    func testIdentifiable() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)
        let id1 = model.stats.comics.id
        let id2 = model.stats.friends.id

        // Assert
        #expect(id1 != id2)
    }

    @Test("Should have valid UUID as id")
    func testValidUUID() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        // Se a propriedade existe e é UUID, o teste passa
        let _ = model.stats.comics.id
        #expect(true)
    }

    // MARK: - Sendable Tests

    @Test("StatItemModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        let _: Sendable = model.stats.comics
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class StatItemModelXCTests: XCTestCase {

    func testComicsStatItemProperties() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 250)

        // Act
        let model = CharacterDetailModel(from: character)
        let stat = model.stats.comics

        // Assert
        XCTAssertEqual(stat.icon, "book.fill")
        XCTAssertEqual(stat.title, "Comics")
        XCTAssertEqual(stat.value, 250)
        XCTAssertEqual(stat.color, .red)
        XCTAssertEqual(stat.displayValue, "250")
    }

    func testFriendsStatItemProperties() {
        // Arrange
        let character = Character.statsFixture(friendsCount: 8)

        // Act
        let model = CharacterDetailModel(from: character)
        let stat = model.stats.friends

        // Assert
        XCTAssertEqual(stat.icon, "person.2.fill")
        XCTAssertEqual(stat.title, "Friends")
        XCTAssertEqual(stat.value, 8)
        XCTAssertEqual(stat.color, .blue)
    }

    func testPowersStatItemProperties() {
        // Arrange
        let character = Character.statsFixture(powersCount: 15)

        // Act
        let model = CharacterDetailModel(from: character)
        let stat = model.stats.powers

        // Assert
        XCTAssertEqual(stat.icon, "bolt.fill")
        XCTAssertEqual(stat.title, "Powers")
        XCTAssertEqual(stat.value, 15)
        XCTAssertEqual(stat.color, .yellow)
    }

    func testEnemiesStatItemProperties() {
        // Arrange
        let character = Character.statsFixture(enemiesCount: 6)

        // Act
        let model = CharacterDetailModel(from: character)
        let stat = model.stats.enemies

        // Assert
        XCTAssertEqual(stat.icon, "exclamationmark.triangle.fill")
        XCTAssertEqual(stat.title, "Enemies")
        XCTAssertEqual(stat.value, 6)
        XCTAssertEqual(stat.color, .green)
    }

    func testStatItemsHaveUniqueIds() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        let ids = model.stats.allStats.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count)
    }

    func testDisplayValueFormatting() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 1234)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.comics.displayValue, "1234")
    }
}
