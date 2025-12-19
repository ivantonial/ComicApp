//
//  CharacterStatsModelTests.swift
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

// MARK: - CharacterStatsModel Tests

@Suite("CharacterStatsModel Tests")
struct CharacterStatsModelTests {

    // MARK: - Comics Stat Tests

    @Test("Should have correct comics stat")
    func testComicsStat() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 150)

        // Act
        let model = CharacterDetailModel(from: character)
        let comicsStat = model.stats.comics

        // Assert
        #expect(comicsStat.value == 150)
        #expect(comicsStat.title == "Comics")
        #expect(comicsStat.icon == "book.fill")
        #expect(comicsStat.color == .red)
    }

    @Test("Should have correct comics display value")
    func testComicsDisplayValue() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 999)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.displayValue == "999")
    }

    // MARK: - Friends Stat Tests

    @Test("Should have correct friends stat")
    func testFriendsStat() {
        // Arrange
        let character = Character.statsFixture(friendsCount: 5)

        // Act
        let model = CharacterDetailModel(from: character)
        let friendsStat = model.stats.friends

        // Assert
        #expect(friendsStat.value == 5)
        #expect(friendsStat.title == "Friends")
        #expect(friendsStat.icon == "person.2.fill")
        #expect(friendsStat.color == .blue)
    }

    @Test("Should have zero friends when no friends data")
    func testZeroFriends() {
        // Arrange
        let character = Character.statsFixture(friendsCount: 0)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.friends.value == 0)
    }

    // MARK: - Powers Stat Tests

    @Test("Should have correct powers stat")
    func testPowersStat() {
        // Arrange
        let character = Character.statsFixture(powersCount: 10)

        // Act
        let model = CharacterDetailModel(from: character)
        let powersStat = model.stats.powers

        // Assert
        #expect(powersStat.value == 10)
        #expect(powersStat.title == "Powers")
        #expect(powersStat.icon == "bolt.fill")
        #expect(powersStat.color == .yellow)
    }

    @Test("Should have zero powers when no powers data")
    func testZeroPowers() {
        // Arrange
        let character = Character.statsFixture(powersCount: 0)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.powers.value == 0)
    }

    // MARK: - Enemies Stat Tests

    @Test("Should have correct enemies stat")
    func testEnemiesStat() {
        // Arrange
        let character = Character.statsFixture(enemiesCount: 8)

        // Act
        let model = CharacterDetailModel(from: character)
        let enemiesStat = model.stats.enemies

        // Assert
        #expect(enemiesStat.value == 8)
        #expect(enemiesStat.title == "Enemies")
        #expect(enemiesStat.icon == "exclamationmark.triangle.fill")
        #expect(enemiesStat.color == .green)
    }

    @Test("Should have zero enemies when no enemies data")
    func testZeroEnemies() {
        // Arrange
        let character = Character.statsFixture(enemiesCount: 0)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.enemies.value == 0)
    }

    // MARK: - All Stats Tests

    @Test("Should have four stats in allStats")
    func testAllStatsCount() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.allStats.count == 4)
    }

    @Test("Should have stats in correct order")
    func testAllStatsOrder() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)
        let stats = model.stats.allStats

        // Assert
        #expect(stats[0].title == "Comics")
        #expect(stats[1].title == "Friends")
        #expect(stats[2].title == "Powers")
        #expect(stats[3].title == "Enemies")
    }

    // MARK: - Edge Cases Tests

    @Test("Should handle character with all zero stats")
    func testAllZeroStats() {
        // Arrange
        let character = Character.statsFixture(
            comicsCount: 0,
            friendsCount: 0,
            powersCount: 0,
            enemiesCount: 0
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.value == 0)
        #expect(model.stats.friends.value == 0)
        #expect(model.stats.powers.value == 0)
        #expect(model.stats.enemies.value == 0)
    }

    @Test("Should handle character with large stat values")
    func testLargeStatValues() {
        // Arrange
        let character = Character.statsFixture(
            comicsCount: 10000,
            friendsCount: 100,
            powersCount: 50,
            enemiesCount: 200
        )

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        #expect(model.stats.comics.value == 10000)
        #expect(model.stats.friends.value == 100)
        #expect(model.stats.powers.value == 50)
        #expect(model.stats.enemies.value == 200)
    }
}

// MARK: - CharacterStatsModel Sendable Tests

@Suite("CharacterStatsModel Sendable Tests")
struct CharacterStatsModelSendableTests {

    @Test("CharacterStatsModel should be Sendable")
    func testSendableConformance() {
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        let _: Sendable = model.stats
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterStatsModelXCTests: XCTestCase {

    func testComicsStatConfiguration() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 100)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.comics.value, 100)
        XCTAssertEqual(model.stats.comics.title, "Comics")
        XCTAssertEqual(model.stats.comics.icon, "book.fill")
    }

    func testFriendsStatConfiguration() {
        // Arrange
        let character = Character.statsFixture(friendsCount: 3)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.friends.value, 3)
        XCTAssertEqual(model.stats.friends.title, "Friends")
        XCTAssertEqual(model.stats.friends.icon, "person.2.fill")
    }

    func testPowersStatConfiguration() {
        // Arrange
        let character = Character.statsFixture(powersCount: 7)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.powers.value, 7)
        XCTAssertEqual(model.stats.powers.title, "Powers")
        XCTAssertEqual(model.stats.powers.icon, "bolt.fill")
    }

    func testEnemiesStatConfiguration() {
        // Arrange
        let character = Character.statsFixture(enemiesCount: 4)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.enemies.value, 4)
        XCTAssertEqual(model.stats.enemies.title, "Enemies")
        XCTAssertEqual(model.stats.enemies.icon, "exclamationmark.triangle.fill")
    }

    func testAllStatsArrayContainsFourElements() {
        // Arrange
        let character = Character.detailFixture()

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.allStats.count, 4)
    }

    func testDisplayValueFormatsCorrectly() {
        // Arrange
        let character = Character.statsFixture(comicsCount: 12345)

        // Act
        let model = CharacterDetailModel(from: character)

        // Assert
        XCTAssertEqual(model.stats.comics.displayValue, "12345")
    }
}
