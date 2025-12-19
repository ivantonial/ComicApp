//
//  FixtureValidationTests.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import Cache
import ComicVineAPI
import Foundation
import Testing

// MARK: - Character Cache Conversion Tests

@Suite("Character Cache Conversion Tests")
struct CharacterCacheConversionTests {

    @Test("Character.makeFromCache should create valid character")
    func testMakeFromCache() {
        // Act
        let character = Character.makeFromCache(
            id: 1,
            name: "Spider-Man",
            description: "Hero",
            thumbnailPath: "https://example.com/image.jpg",
            comicsCount: 100
        )

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Hero")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character.makeFromCache should handle nil values")
    func testMakeFromCacheNilValues() {
        // Act
        let character = Character.makeFromCache(
            id: 1,
            name: "Unknown",
            description: nil,
            thumbnailPath: nil,
            comicsCount: 0
        )

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Unknown")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character.makeFromCache should generate valid URLs")
    func testMakeFromCacheUrls() {
        // Act
        let character = Character.makeFromCache(
            id: 12345,
            name: "Spider-Man"
        )

        // Assert
        #expect(character.apiDetailUrl.contains("4005-12345"))
        #expect(character.siteDetailUrl.contains("4005-12345"))
    }

    @Test("Character.makeFromCache should use current date when not provided")
    func testMakeFromCacheDefaultDates() {
        // Act
        let character = Character.makeFromCache(
            id: 1,
            name: "Hero"
        )

        // Assert
        #expect(!character.dateAdded.isEmpty)
        #expect(!character.dateLastUpdated.isEmpty)
    }

    @Test("Character.makeFromCache should use provided dates")
    func testMakeFromCacheProvidedDates() {
        // Arrange
        let dateAdded = "2024-01-01 00:00:00"
        let dateUpdated = "2024-06-15 12:00:00"

        // Act
        let character = Character.makeFromCache(
            id: 1,
            name: "Hero",
            dateAdded: dateAdded,
            dateLastUpdated: dateUpdated
        )

        // Assert
        #expect(character.dateAdded == dateAdded)
        #expect(character.dateLastUpdated == dateUpdated)
    }
}

// MARK: - Character Fixture Tests

@Suite("Character Fixture Tests")
struct CharacterFixtureTests {

    @Test("Character fixture should create valid character")
    func testCharacterFixture() {
        // Act
        let character = Character.cacheFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character fixture should allow custom values")
    func testCharacterFixtureCustomValues() {
        // Act
        let character = Character.cacheFixture(
            id: 42,
            name: "Iron Man",
            description: "Genius billionaire",
            comicsCount: 500
        )

        // Assert
        #expect(character.id == 42)
        #expect(character.name == "Iron Man")
        #expect(character.description == "Genius billionaire")
        #expect(character.countOfIssueAppearances == 500)
    }

    @Test("Character fixture should have valid image")
    func testCharacterFixtureImage() {
        // Act
        let character = Character.cacheFixture()

        // Assert
        #expect(character.image.bestQualityUrl != nil)
        #expect(character.image.thumbnailUrl != nil)
    }

    @Test("Minimal character fixture should work")
    func testMinimalCharacterFixture() {
        // Act
        let character = Character.minimalCacheFixture(id: 99, name: "Minimal Hero")

        // Assert
        #expect(character.id == 99)
        #expect(character.name == "Minimal Hero")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character fixtures collection should create multiple characters")
    func testCharacterFixturesCollection() {
        // Act
        let characters: [Character] = .cacheFixtures(count: 5)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }
}

// MARK: - Comic Fixture Tests

@Suite("Comic Fixture Tests")
struct ComicFixtureTests {

    @Test("Comic fixture should create valid comic")
    func testComicFixture() {
        // Act
        let comic = Comic.cacheFixture()

        // Assert
        #expect(comic.id == 100)
        #expect(comic.name == "Amazing Spider-Man")
        #expect(comic.issueNumber == "1")
    }

    @Test("Comic fixture should allow custom values")
    func testComicFixtureCustomValues() {
        // Act
        let comic = Comic.cacheFixture(
            id: 200,
            name: "X-Men",
            issueNumber: "50",
            description: "Classic issue"
        )

        // Assert
        #expect(comic.id == 200)
        #expect(comic.name == "X-Men")
        #expect(comic.issueNumber == "50")
        #expect(comic.description == "Classic issue")
    }

    @Test("Comic title should combine volume and issue number")
    func testComicTitle() {
        // Act
        let comic = Comic.cacheFixture(
            name: nil,
            issueNumber: "15"
        )

        // Assert
        #expect(comic.title == "Amazing Spider-Man #15")
    }

    @Test("Comic should be Hashable")
    func testComicHashable() {
        // Arrange
        let comic1 = Comic.cacheFixture(id: 1)
        let comic2 = Comic.cacheFixture(id: 1)
        let comic3 = Comic.cacheFixture(id: 2)

        // Assert
        #expect(comic1 == comic2)
        #expect(comic1 != comic3)
        #expect(comic1.hashValue == comic2.hashValue)
    }

    @Test("Minimal comic fixture should work")
    func testMinimalComicFixture() {
        // Act
        let comic = Comic.minimalCacheFixture(id: 999)

        // Assert
        #expect(comic.id == 999)
        #expect(comic.name == nil)
        #expect(comic.issueNumber == nil)
    }

    @Test("Comic fixtures collection should create multiple comics")
    func testComicFixturesCollection() {
        // Act
        let comics: [Comic] = .cacheFixtures(count: 5)

        // Assert
        #expect(comics.count == 5)
        for (index, comic) in comics.enumerated() {
            #expect(comic.id == 101 + index)
            #expect(comic.issueNumber == "\(index + 1)")
        }
    }
}

// MARK: - VolumeSummary Fixture Tests

@Suite("VolumeSummary Fixture Tests")
struct VolumeSummaryFixtureTests {

    @Test("VolumeSummary fixture should create valid volume")
    func testVolumeSummaryFixture() {
        // Act
        let volume = VolumeSummary.cacheFixture()

        // Assert
        #expect(volume.id == 1)
        #expect(volume.name == "Amazing Spider-Man")
        #expect(volume.apiDetailUrl != nil)
    }

    @Test("VolumeSummary fixture should allow custom values")
    func testVolumeSummaryFixtureCustom() {
        // Act
        let volume = VolumeSummary.cacheFixture(
            id: 42,
            name: "X-Men",
            apiDetailUrl: nil
        )

        // Assert
        #expect(volume.id == 42)
        #expect(volume.name == "X-Men")
        #expect(volume.apiDetailUrl == nil)
    }
}

// MARK: - TestCodableObject Tests

@Suite("TestCodableObject Tests")
struct TestCodableObjectTests {

    @Test("TestCodableObject should be codable")
    func testCodable() throws {
        // Arrange
        let original = TestCodableObject(id: 42, name: "Test Object")
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        // Act
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(TestCodableObject.self, from: data)

        // Assert
        #expect(decoded == original)
    }

    @Test("TestCodableObject should be equatable")
    func testEquatable() {
        // Arrange
        let obj1 = TestCodableObject(id: 1, name: "Test")
        let obj2 = TestCodableObject(id: 1, name: "Test")
        let obj3 = TestCodableObject(id: 2, name: "Different")

        // Assert
        #expect(obj1 == obj2)
        #expect(obj1 != obj3)
    }

    @Test("TestCodableObject should be sendable")
    func testSendable() async {
        // Arrange
        let obj = TestCodableObject(id: 1, name: "Test")

        // Act
        let result = await Task.detached {
            return obj.name
        }.value

        // Assert
        #expect(result == "Test")
    }
}
