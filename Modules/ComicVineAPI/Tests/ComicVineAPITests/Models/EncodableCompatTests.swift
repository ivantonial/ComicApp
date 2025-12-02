//
//  EncodableCompatTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - EncodableCharacter Tests

@Suite("EncodableCharacter Tests")
struct EncodableCharacterTests {

    // MARK: - Initialization Tests

    @Test("EncodableCharacter should initialize from Character")
    func testInitFromCharacter() {
        let character = Character.apiFixture(
            id: 1,
            name: "Spider-Man",
            description: "A superhero",
            comicsCount: 100
        )

        let encodable = EncodableCharacter(from: character)

        #expect(encodable.id == 1)
        #expect(encodable.name == "Spider-Man")
        #expect(encodable.description == "A superhero")
        #expect(encodable.countOfIssueAppearances == 100)
    }

    @Test("EncodableCharacter should extract image URLs")
    func testImageUrlExtraction() {
        let character = Character.apiFixture()

        let encodable = EncodableCharacter(from: character)

        #expect(encodable.imageOriginalUrl != nil)
        #expect(encodable.imageMediumUrl != nil)
    }

    @Test("EncodableCharacter should handle nil description")
    func testNilDescription() {
        let character = Character.minimalApiFixture()

        let encodable = EncodableCharacter(from: character)

        #expect(encodable.description == nil)
    }

    // MARK: - toCharacter Tests

    @Test("toCharacter should recreate Character from EncodableCharacter")
    func testToCharacter() {
        let original = Character.apiFixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 200
        )

        let encodable = EncodableCharacter(from: original)
        let recreated = encodable.toCharacter()

        #expect(recreated.id == 42)
        #expect(recreated.name == "Batman")
        #expect(recreated.description == "The Dark Knight")
        #expect(recreated.countOfIssueAppearances == 200)
    }

    @Test("toCharacter should preserve image URLs")
    func testToCharacterImage() {
        let original = Character.apiFixture()

        let encodable = EncodableCharacter(from: original)
        let recreated = encodable.toCharacter()

        #expect(recreated.image.originalUrl == original.image.originalUrl)
        #expect(recreated.image.mediumUrl == original.image.mediumUrl)
    }

    // MARK: - Codable Tests

    @Test("EncodableCharacter should encode to JSON")
    func testEncode() throws {
        let character = Character.apiFixture()
        let encodable = EncodableCharacter(from: character)

        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)
        let json = String(data: data, encoding: .utf8)

        #expect(json != nil)
        #expect(json?.contains("Spider-Man") == true)
    }

    @Test("EncodableCharacter should decode from JSON")
    func testDecode() throws {
        let json = """
        {
            "id": 1,
            "name": "Test Hero",
            "description": "A test hero",
            "deck": null,
            "imageOriginalUrl": "https://example.com/original.jpg",
            "imageMediumUrl": "https://example.com/medium.jpg",
            "apiDetailUrl": "https://example.com/api",
            "countOfIssueAppearances": 50,
            "realName": "John Doe",
            "aliases": null,
            "dateAdded": "2024-01-01 00:00:00",
            "dateLastUpdated": "2024-01-15 00:00:00"
        }
        """

        let data = json.data(using: .utf8)!
        let encodable = try JSONDecoder().decode(EncodableCharacter.self, from: data)

        #expect(encodable.id == 1)
        #expect(encodable.name == "Test Hero")
        #expect(encodable.countOfIssueAppearances == 50)
    }

    @Test("EncodableCharacter should roundtrip encode/decode")
    func testRoundtrip() throws {
        let original = Character.apiFixture(id: 42, name: "Roundtrip Hero")
        let encodable = EncodableCharacter(from: original)

        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EncodableCharacter.self, from: data)

        let recreated = decoded.toCharacter()

        #expect(recreated.id == 42)
        #expect(recreated.name == "Roundtrip Hero")
    }
}

// MARK: - EncodableComic Tests

@Suite("EncodableComic Tests")
struct EncodableComicTests {

    // MARK: - Initialization Tests

    @Test("EncodableComic should initialize from Comic")
    func testInitFromComic() {
        let comic = Comic.apiFixture(
            id: 100,
            name: "Test Comic",
            issueNumber: "1",
            description: "A test comic"
        )

        let encodable = EncodableComic(from: comic)

        #expect(encodable.id == 100)
        #expect(encodable.name == "Test Comic")
        #expect(encodable.issueNumber == "1")
        #expect(encodable.description == "A test comic")
    }

    @Test("EncodableComic should extract volume information")
    func testVolumeExtraction() {
        let comic = Comic.apiFixture(volumeName: "Amazing Spider-Man", volumeId: 1)

        let encodable = EncodableComic(from: comic)

        #expect(encodable.volumeName == "Amazing Spider-Man")
        #expect(encodable.volumeId == 1)
    }

    @Test("EncodableComic should handle nil volume")
    func testNilVolume() {
        let comic = Comic.withoutVolumeFixture()

        let encodable = EncodableComic(from: comic)

        #expect(encodable.volumeName == nil)
        #expect(encodable.volumeId == nil)
    }

    // MARK: - toComic Tests

    @Test("toComic should recreate Comic from EncodableComic")
    func testToComic() {
        let original = Comic.apiFixture(
            id: 200,
            name: "Batman #1",
            issueNumber: "1"
        )

        let encodable = EncodableComic(from: original)
        let recreated = encodable.toComic()

        #expect(recreated.id == 200)
        #expect(recreated.name == "Batman #1")
        #expect(recreated.issueNumber == "1")
    }

    @Test("toComic should recreate volume when available")
    func testToComicWithVolume() {
        let original = Comic.apiFixture(volumeName: "X-Men", volumeId: 42)

        let encodable = EncodableComic(from: original)
        let recreated = encodable.toComic()

        #expect(recreated.volume?.name == "X-Men")
        #expect(recreated.volume?.id == 42)
    }

    @Test("toComic should handle nil volume gracefully")
    func testToComicNilVolume() {
        let original = Comic.withoutVolumeFixture()

        let encodable = EncodableComic(from: original)
        let recreated = encodable.toComic()

        #expect(recreated.volume == nil)
    }

    // MARK: - Codable Tests

    @Test("EncodableComic should encode to JSON")
    func testEncode() throws {
        let comic = Comic.apiFixture()
        let encodable = EncodableComic(from: comic)

        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)
        let json = String(data: data, encoding: .utf8)

        #expect(json != nil)
    }

    @Test("EncodableComic should decode from JSON")
    func testDecode() throws {
        let json = """
        {
            "id": 100,
            "name": "Test Comic",
            "issueNumber": "1",
            "description": "A test",
            "deck": null,
            "imageOriginalUrl": "https://example.com/original.jpg",
            "imageMediumUrl": null,
            "coverDate": "2024-01-01",
            "apiDetailUrl": "https://example.com/api",
            "volumeName": "Test Volume",
            "volumeId": 1
        }
        """

        let data = json.data(using: .utf8)!
        let encodable = try JSONDecoder().decode(EncodableComic.self, from: data)

        #expect(encodable.id == 100)
        #expect(encodable.name == "Test Comic")
        #expect(encodable.volumeName == "Test Volume")
    }

    @Test("EncodableComic should roundtrip encode/decode")
    func testRoundtrip() throws {
        let original = Comic.apiFixture(id: 42)
        let encodable = EncodableComic(from: original)

        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EncodableComic.self, from: data)

        let recreated = decoded.toComic()

        #expect(recreated.id == 42)
    }
}

// MARK: - XCTest Integration Tests

class EncodableCompatXCTests: XCTestCase {

    func testEncodableCharacterSendableCompliance() {
        let character = Character.apiFixture()
        let encodable = EncodableCharacter(from: character)
        let sendable: any Sendable = encodable
        XCTAssertNotNil(sendable)
    }

    func testEncodableComicSendableCompliance() {
        let comic = Comic.apiFixture()
        let encodable = EncodableComic(from: comic)
        let sendable: any Sendable = encodable
        XCTAssertNotNil(sendable)
    }

    func testCharacterRoundtripPreservesEssentialData() throws {
        let original = Character.apiFixture(
            id: 1,
            name: "Spider-Man",
            description: "Friendly neighborhood Spider-Man",
            comicsCount: 100,
            realName: "Peter Parker"
        )

        let encodable = EncodableCharacter(from: original)
        let data = try JSONEncoder().encode(encodable)
        let decoded = try JSONDecoder().decode(EncodableCharacter.self, from: data)
        let recreated = decoded.toCharacter()

        XCTAssertEqual(recreated.id, original.id)
        XCTAssertEqual(recreated.name, original.name)
        XCTAssertEqual(recreated.description, original.description)
        XCTAssertEqual(recreated.countOfIssueAppearances, original.countOfIssueAppearances)
        XCTAssertEqual(recreated.realName, original.realName)
    }

    func testComicRoundtripPreservesEssentialData() throws {
        let original = Comic.apiFixture(
            id: 100,
            name: "Amazing Fantasy",
            issueNumber: "15",
            description: "First appearance of Spider-Man",
            coverDate: "1962-08-01",
            volumeName: "Amazing Fantasy",
            volumeId: 1
        )

        let encodable = EncodableComic(from: original)
        let data = try JSONEncoder().encode(encodable)
        let decoded = try JSONDecoder().decode(EncodableComic.self, from: data)
        let recreated = decoded.toComic()

        XCTAssertEqual(recreated.id, original.id)
        XCTAssertEqual(recreated.name, original.name)
        XCTAssertEqual(recreated.issueNumber, original.issueNumber)
        XCTAssertEqual(recreated.description, original.description)
        XCTAssertEqual(recreated.coverDate, original.coverDate)
        XCTAssertEqual(recreated.volume?.name, original.volume?.name)
    }
}
