//
//  ComicTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - Comic Model Tests

@Suite("Comic Model Tests")
struct ComicModelTests {

    // MARK: - Initialization Tests

    @Test("Comic should initialize with all properties")
    func testFullInitialization() {
        let comic = Comic.apiFixture()

        #expect(comic.id == 100)
        #expect(comic.name == "The Night Gwen Stacy Died")
        #expect(comic.issueNumber == "121")
        #expect(comic.description == "A classic Spider-Man story")
        #expect(comic.deck == "One of the most important issues in comics history")
        #expect(comic.coverDate == "1973-06-01")
        #expect(comic.hasStaffReview == true)
    }

    @Test("Comic should initialize with minimal properties")
    func testMinimalInitialization() {
        let comic = Comic.minimalApiFixture(id: 42)

        #expect(comic.id == 42)
        #expect(comic.name == nil)
        #expect(comic.issueNumber == nil)
        #expect(comic.description == nil)
        #expect(comic.volume == nil)
    }

    @Test("Comic should have correct API URLs")
    func testApiUrls() {
        let comic = Comic.apiFixture(id: 12345)

        #expect(comic.apiDetailUrl.contains("4000-12345"))
        #expect(comic.siteDetailUrl.contains("4000-12345"))
    }

    // MARK: - Title Computed Property Tests

    @Test("Comic title should include volume name and issue number")
    func testTitleWithVolumeAndIssue() {
        let comic = Comic.apiFixture(
            issueNumber: "121",
            volumeName: "Amazing Spider-Man"
        )

        #expect(comic.title == "Amazing Spider-Man #121")
    }

    @Test("Comic title should fallback to name when no volume or issue")
    func testTitleFallbackToName() {
        let comic = Comic.withoutVolumeFixture(
            name: "Special Issue",
            issueNumber: nil
        )

        #expect(comic.title == "Special Issue")
    }

    @Test("Comic title should fallback to volume name only")
    func testTitleFallbackToVolume() {
        let comic = Comic.apiFixture(
            name: nil,
            issueNumber: nil,
            volumeName: "Amazing Spider-Man"
        )

        // Sem issueNumber, mas com volume
        #expect(comic.title.contains("Amazing Spider-Man"))
    }

    @Test("Comic title should return 'Unknown Comic' when no info available")
    func testTitleUnknown() {
        let comic = Comic.withoutVolumeFixture(
            name: nil,
            issueNumber: nil
        )

        #expect(comic.title == "Unknown Comic")
    }

    // MARK: - Equatable Tests

    @Test("Comics with same ID should be equal")
    func testEqualitySameId() {
        let comic1 = Comic.apiFixture(id: 100, name: "Comic 1")
        let comic2 = Comic.apiFixture(id: 100, name: "Comic 2")

        #expect(comic1 == comic2)
    }

    @Test("Comics with different IDs should not be equal")
    func testEqualityDifferentId() {
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 200)

        #expect(comic1 != comic2)
    }

    // MARK: - Hashable Tests

    @Test("Comic should be hashable")
    func testHashable() {
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 100)

        var set = Set<Comic>()
        set.insert(comic1)
        set.insert(comic2)

        #expect(set.count == 1)
    }

    @Test("Different comics should have different hashes")
    func testHashableDifferent() {
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 200)

        var set = Set<Comic>()
        set.insert(comic1)
        set.insert(comic2)

        #expect(set.count == 2)
    }

    // MARK: - Identifiable Tests

    @Test("Comic id property should match the id value")
    func testIdentifiable() {
        let comic = Comic.apiFixture(id: 42)

        #expect(comic.id == 42)
    }

    // MARK: - Volume Tests

    @Test("Comic should have volume information")
    func testVolumeInfo() {
        let comic = Comic.apiFixture(volumeName: "Amazing Spider-Man", volumeId: 1)

        #expect(comic.volume != nil)
        #expect(comic.volume?.name == "Amazing Spider-Man")
        #expect(comic.volume?.id == 1)
    }

    @Test("Comic can have nil volume")
    func testNilVolume() {
        let comic = Comic.withoutVolumeFixture()

        #expect(comic.volume == nil)
    }

    // MARK: - Date Tests

    @Test("Comic should have coverDate")
    func testCoverDate() {
        let comic = Comic.apiFixture(coverDate: "2024-01-15")

        #expect(comic.coverDate == "2024-01-15")
    }

    @Test("Comic should have storeDate")
    func testStoreDate() {
        let comic = Comic.apiFixture(storeDate: "2024-01-20")

        #expect(comic.storeDate == "2024-01-20")
    }

    @Test("Comic coverDate can be nil")
    func testNilCoverDate() {
        let comic = Comic.minimalApiFixture()

        #expect(comic.coverDate == nil)
    }
}

// MARK: - Comic Decoding Tests

@Suite("Comic Decoding Tests")
struct ComicDecodingTests {

    @Test("Comic should decode from valid JSON")
    func testDecodeFromJSON() throws {
        let json = """
        {
            "id": 100,
            "name": "Test Comic",
            "issue_number": "1",
            "description": "A test comic",
            "deck": null,
            "image": {
                "original_url": "https://example.com/image.jpg"
            },
            "cover_date": "2024-01-01",
            "store_date": null,
            "api_detail_url": "https://api.example.com/issue/100",
            "site_detail_url": "https://example.com/issue/100",
            "volume": {
                "id": 1,
                "name": "Test Volume",
                "api_detail_url": "https://api.example.com/volume/1"
            },
            "has_staff_review": false,
            "date_added": "2024-01-01 00:00:00",
            "date_last_updated": "2024-01-15 00:00:00"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let comic = try decoder.decode(Comic.self, from: data)

        #expect(comic.id == 100)
        #expect(comic.name == "Test Comic")
        #expect(comic.issueNumber == "1")
        #expect(comic.volume?.name == "Test Volume")
    }

    @Test("Comic should decode with null volume")
    func testDecodeWithNullVolume() throws {
        let json = """
        {
            "id": 100,
            "name": null,
            "issue_number": null,
            "description": null,
            "deck": null,
            "image": {},
            "cover_date": null,
            "store_date": null,
            "api_detail_url": "https://api.example.com/issue/100",
            "site_detail_url": "https://example.com/issue/100",
            "volume": null,
            "has_staff_review": null,
            "date_added": "2024-01-01 00:00:00",
            "date_last_updated": "2024-01-15 00:00:00"
        }
        """

        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        let comic = try decoder.decode(Comic.self, from: data)

        #expect(comic.id == 100)
        #expect(comic.volume == nil)
    }
}

// MARK: - Comic Collection Tests

@Suite("Comic Collection Tests")
struct ComicCollectionTests {

    @Test("apiFixtures should create correct number of comics")
    func testFixturesCount() {
        let comics = [Comic].apiFixtures(count: 5)

        #expect(comics.count == 5)
    }

    @Test("apiFixtures should create sequential IDs")
    func testFixturesIds() {
        let comics = [Comic].apiFixtures(count: 3)

        #expect(comics[0].id == 101)
        #expect(comics[1].id == 102)
        #expect(comics[2].id == 103)
    }

    @Test("apiFixturesWithDates should create comics with specified dates")
    func testFixturesWithDates() {
        let dates = ["2024-01-01", "2024-02-01", "2024-03-01"]
        let comics = [Comic].apiFixturesWithDates(dates: dates)

        #expect(comics.count == 3)
        #expect(comics[0].coverDate == "2024-01-01")
        #expect(comics[1].coverDate == "2024-02-01")
        #expect(comics[2].coverDate == "2024-03-01")
    }
}

// MARK: - XCTest Integration Tests

class ComicXCTests: XCTestCase {

    func testComicSendableCompliance() {
        let comic = Comic.apiFixture()
        let sendable: any Sendable = comic
        XCTAssertNotNil(sendable)
    }

    func testComicDecodableCompliance() throws {
        let json = """
        {
            "id": 1,
            "image": {},
            "api_detail_url": "https://test.com",
            "site_detail_url": "https://test.com",
            "date_added": "2024-01-01 00:00:00",
            "date_last_updated": "2024-01-01 00:00:00"
        }
        """

        let data = json.data(using: .utf8)!
        let comic = try JSONDecoder().decode(Comic.self, from: data)

        XCTAssertEqual(comic.id, 1)
    }

    func testComicTitleFormats() {
        // Volume + Issue
        let comic1 = Comic.apiFixture(issueNumber: "5", volumeName: "X-Men")
        XCTAssertEqual(comic1.title, "X-Men #5")

        // Name only
        let comic2 = Comic.withoutVolumeFixture(name: "Special Edition", issueNumber: nil)
        XCTAssertEqual(comic2.title, "Special Edition")

        // Unknown
        let comic3 = Comic.withoutVolumeFixture(name: nil, issueNumber: nil)
        XCTAssertEqual(comic3.title, "Unknown Comic")
    }
}
