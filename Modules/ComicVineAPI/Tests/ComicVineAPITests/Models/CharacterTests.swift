//
//  CharacterTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - Character Model Tests

@Suite("Character Model Tests")
struct CharacterModelTests {

    // MARK: - Initialization Tests

    @Test("Character should initialize with all properties")
    func testFullInitialization() {
        let character = Character.apiFixture()

        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.deck == "A superhero from New York")
        #expect(character.realName == "Peter Parker")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character should initialize with minimal properties")
    func testMinimalInitialization() {
        let character = Character.minimalApiFixture(id: 42, name: "Test Hero")

        #expect(character.id == 42)
        #expect(character.name == "Test Hero")
        #expect(character.description == nil)
        #expect(character.deck == nil)
        #expect(character.realName == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character should have correct API URLs")
    func testApiUrls() {
        let character = Character.apiFixture(id: 12345)

        #expect(character.apiDetailUrl.contains("4005-12345"))
        #expect(character.siteDetailUrl.contains("4005-12345"))
    }

    // MARK: - Computed Properties Tests

    @Test("Character thumbnail should return image")
    func testThumbnailComputedProperty() {
        let character = Character.apiFixture()

        #expect(character.thumbnail.originalUrl != nil)
    }

    @Test("Character comicsCount should return countOfIssueAppearances")
    func testComicsCountComputedProperty() {
        let character = Character.apiFixture(comicsCount: 150)

        #expect(character.comicsCount == 150)
    }

    @Test("Character hasDescription should return true when description exists")
    func testHasDescriptionTrue() {
        let character = Character.apiFixture(description: "A valid description")

        #expect(character.hasDescription == true)
    }

    @Test("Character hasDescription should return false when description is nil")
    func testHasDescriptionFalseNil() {
        let character = Character.apiFixture(description: nil)

        #expect(character.hasDescription == false)
    }

    @Test("Character hasDescription should return false when description is empty")
    func testHasDescriptionFalseEmpty() {
        let character = Character.apiFixture(description: "")

        #expect(character.hasDescription == false)
    }

    @Test("Character hasDeck should return true when deck exists")
    func testHasDeckTrue() {
        let character = Character.apiFixture(deck: "A valid deck")

        #expect(character.hasDeck == true)
    }

    @Test("Character hasDeck should return false when deck is nil")
    func testHasDeckFalseNil() {
        let character = Character.apiFixture(deck: nil)

        #expect(character.hasDeck == false)
    }

    @Test("Character hasDeck should return false when deck is empty")
    func testHasDeckFalseEmpty() {
        let character = Character.apiFixture(deck: "")

        #expect(character.hasDeck == false)
    }

    // MARK: - Equatable Tests

    @Test("Characters with same ID should be equal")
    func testEqualitySameId() {
        let character1 = Character.apiFixture(id: 1, name: "Spider-Man")
        let character2 = Character.apiFixture(id: 1, name: "Different Name")

        #expect(character1 == character2)
    }

    @Test("Characters with different IDs should not be equal")
    func testEqualityDifferentId() {
        let character1 = Character.apiFixture(id: 1)
        let character2 = Character.apiFixture(id: 2)

        #expect(character1 != character2)
    }

    // MARK: - Hashable Tests

    @Test("Character should be hashable")
    func testHashable() {
        let character1 = Character.apiFixture(id: 1)
        let character2 = Character.apiFixture(id: 1)

        var set = Set<Character>()
        set.insert(character1)
        set.insert(character2)

        #expect(set.count == 1)
    }

    @Test("Different characters should have different hashes")
    func testHashableDifferent() {
        let character1 = Character.apiFixture(id: 1)
        let character2 = Character.apiFixture(id: 2)

        var set = Set<Character>()
        set.insert(character1)
        set.insert(character2)

        #expect(set.count == 2)
    }

    // MARK: - Identifiable Tests

    @Test("Character id property should match the id value")
    func testIdentifiable() {
        let character = Character.apiFixture(id: 42)

        #expect(character.id == 42)
    }

    // MARK: - Relations Tests

    @Test("Character should have enemies when includeRelations is true")
    func testCharacterEnemies() {
        let character = Character.apiFixture(includeRelations: true)

        #expect(character.characterEnemies != nil)
        #expect(character.characterEnemies?.isEmpty == false)
    }

    @Test("Character should have friends when includeRelations is true")
    func testCharacterFriends() {
        let character = Character.apiFixture(includeRelations: true)

        #expect(character.characterFriends != nil)
        #expect(character.characterFriends?.isEmpty == false)
    }

    @Test("Character should have powers when includeRelations is true")
    func testCharacterPowers() {
        let character = Character.apiFixture(includeRelations: true)

        #expect(character.powers != nil)
        #expect(character.powers?.isEmpty == false)
    }

    @Test("Character should have issue credits when includeRelations is true")
    func testCharacterIssueCredits() {
        let character = Character.apiFixture(includeRelations: true)

        #expect(character.issueCredits != nil)
        #expect(character.issueCredits?.isEmpty == false)
    }

    @Test("Character should not have relations when includeRelations is false")
    func testNoRelations() {
        let character = Character.apiFixture(includeRelations: false)

        #expect(character.characterEnemies == nil)
        #expect(character.characterFriends == nil)
        #expect(character.powers == nil)
        #expect(character.issueCredits == nil)
    }

    // MARK: - makeFromCache Tests

    @Test("makeFromCache should create valid character")
    func testMakeFromCache() {
        let character = Character.makeFromCache(
            id: 1,
            name: "Cached Hero",
            description: "A cached hero description",
            thumbnailPath: "https://example.com/thumb.jpg",
            comicsCount: 50
        )

        #expect(character.id == 1)
        #expect(character.name == "Cached Hero")
        #expect(character.description == "A cached hero description")
        #expect(character.countOfIssueAppearances == 50)
    }

    @Test("makeFromCache should create valid API URLs")
    func testMakeFromCacheUrls() {
        let character = Character.makeFromCache(
            id: 12345,
            name: "Test Hero"
        )

        #expect(character.apiDetailUrl.contains("4005-12345"))
        #expect(character.siteDetailUrl.contains("4005-12345"))
    }

    @Test("makeFromCache should use default dates when not provided")
    func testMakeFromCacheDefaultDates() {
        let character = Character.makeFromCache(
            id: 1,
            name: "Test Hero"
        )

        #expect(!character.dateAdded.isEmpty)
        #expect(!character.dateLastUpdated.isEmpty)
    }
}

// MARK: - Character Decoding Tests

@Suite("Character Decoding Tests")
struct CharacterDecodingTests {

    @Test("Character should decode from valid JSON")
    func testDecodeFromJSON() throws {
        let json = """
        {
            "id": 1,
            "name": "Spider-Man",
            "description": "A superhero",
            "deck": "Web-slinger",
            "aliases": null,
            "image": {
                "original_url": "https://example.com/image.jpg"
            },
            "api_detail_url": "https://api.example.com/character/1",
            "site_detail_url": "https://example.com/character/1",
            "first_appeared_in_issue": null,
            "count_of_issue_appearances": 100,
            "real_name": "Peter Parker",
            "birth": null,
            "date_added": "2024-01-01 00:00:00",
            "date_last_updated": "2024-01-15 00:00:00",
            "gender": 1,
            "origin": null,
            "publisher": null
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let character = try decoder.decode(Character.self, from: data)

        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "A superhero")
        #expect(character.countOfIssueAppearances == 100)
    }
}

// MARK: - XCTest Integration Tests

class CharacterXCTests: XCTestCase {

    func testCharacterSendableCompliance() {
        let character = Character.apiFixture()
        let sendable: any Sendable = character
        XCTAssertNotNil(sendable)
    }

    func testCharacterDecodableCompliance() throws {
        let json = """
        {
            "id": 1,
            "name": "Test",
            "image": {},
            "api_detail_url": "https://test.com",
            "site_detail_url": "https://test.com",
            "count_of_issue_appearances": 0,
            "date_added": "2024-01-01 00:00:00",
            "date_last_updated": "2024-01-01 00:00:00"
        }
        """

        let data = json.data(using: .utf8)!
        let character = try JSONDecoder().decode(Character.self, from: data)

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Test")
    }

    func testCharacterCollection() {
        let characters = [Character].apiFixtures(count: 5)

        XCTAssertEqual(characters.count, 5)

        for (index, character) in characters.enumerated() {
            XCTAssertEqual(character.id, index + 1)
            XCTAssertEqual(character.name, "Hero \(index + 1)")
        }
    }
}
