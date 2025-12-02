//
//  CharacterSummaryModelTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - CharacterSummaryModel Tests

@Suite("CharacterSummaryModel Tests")
struct CharacterSummaryModelTests {

    // MARK: - Initialization from Character Tests

    @Test("CharacterSummaryModel should initialize from Character")
    func testInitFromCharacter() {
        let character = Character.apiFixture(
            id: 1,
            name: "Spider-Man",
            comicsCount: 100
        )

        let summary = CharacterSummaryModel(from: character)

        #expect(summary.id == 1)
        #expect(summary.name == "Spider-Man")
        #expect(summary.comicsCount == 100)
    }

    @Test("CharacterSummaryModel should extract best quality image URL")
    func testImageUrlExtraction() {
        let character = Character.apiFixture()

        let summary = CharacterSummaryModel(from: character)

        #expect(summary.imageURL != nil)
    }

    @Test("CharacterSummaryModel should handle character without image")
    func testNoImage() {
        let character = Character.minimalApiFixture()

        let summary = CharacterSummaryModel(from: character)

        // Minimal fixture has empty ComicVineImage
        #expect(summary.imageURL == nil)
    }

    // MARK: - Manual Initialization Tests

    @Test("CharacterSummaryModel should initialize with manual values")
    func testManualInit() {
        let imageURL = URL(string: "https://example.com/image.jpg")

        let summary = CharacterSummaryModel(
            id: 42,
            name: "Custom Hero",
            imageURL: imageURL,
            comicsCount: 50
        )

        #expect(summary.id == 42)
        #expect(summary.name == "Custom Hero")
        #expect(summary.imageURL == imageURL)
        #expect(summary.comicsCount == 50)
    }

    @Test("CharacterSummaryModel should accept nil image URL")
    func testNilImageUrl() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 0
        )

        #expect(summary.imageURL == nil)
    }

    // MARK: - Computed Properties Tests

    @Test("hasImage should return true when imageURL exists")
    func testHasImageTrue() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: URL(string: "https://example.com/image.jpg"),
            comicsCount: 0
        )

        #expect(summary.hasImage == true)
    }

    @Test("hasImage should return false when imageURL is nil")
    func testHasImageFalse() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 0
        )

        #expect(summary.hasImage == false)
    }

    // MARK: - comicsCountText Tests

    @Test("comicsCountText should return 'No comics' for zero")
    func testComicsCountTextZero() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 0
        )

        #expect(summary.comicsCountText == "No comics")
    }

    @Test("comicsCountText should return '1 comic' for one")
    func testComicsCountTextOne() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 1
        )

        #expect(summary.comicsCountText == "1 comic")
    }

    @Test("comicsCountText should return plural for multiple")
    func testComicsCountTextMultiple() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 100
        )

        #expect(summary.comicsCountText == "100 comics")
    }

    @Test("comicsCountText should handle large numbers")
    func testComicsCountTextLarge() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 9999
        )

        #expect(summary.comicsCountText == "9999 comics")
    }

    // MARK: - Sendable Compliance Tests

    @Test("CharacterSummaryModel should be Sendable")
    func testSendableCompliance() {
        let summary = CharacterSummaryModel(
            id: 1,
            name: "Hero",
            imageURL: nil,
            comicsCount: 0
        )

        // Se compilar, é Sendable
        let _: any Sendable = summary
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterSummaryModelXCTests: XCTestCase {

    func testSummaryFromMultipleCharacters() {
        let characters = [Character].apiFixtures(count: 3)
        let summaries = characters.map { CharacterSummaryModel(from: $0) }

        XCTAssertEqual(summaries.count, 3)

        for (index, summary) in summaries.enumerated() {
            XCTAssertEqual(summary.id, index + 1)
            XCTAssertEqual(summary.name, "Hero \(index + 1)")
        }
    }

    func testComicsCountTextVariations() {
        let testCases: [(count: Int, expected: String)] = [
            (0, "No comics"),
            (1, "1 comic"),
            (2, "2 comics"),
            (10, "10 comics"),
            (100, "100 comics"),
            (1000, "1000 comics")
        ]

        for testCase in testCases {
            let summary = CharacterSummaryModel(
                id: 1,
                name: "Hero",
                imageURL: nil,
                comicsCount: testCase.count
            )

            XCTAssertEqual(summary.comicsCountText, testCase.expected)
        }
    }
}
