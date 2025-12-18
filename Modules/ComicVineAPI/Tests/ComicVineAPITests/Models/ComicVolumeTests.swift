//
//  ComicVolumeTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - ComicVolume Model Tests

@Suite("ComicVolume Model Tests")
struct ComicVolumeModelTests {

    // MARK: - Initialization Tests

    @Test("ComicVolume should initialize with all properties")
    func testFullInitialization() {
        let volume = ComicVolume(
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/",
            id: 1,
            name: "Amazing Spider-Man",
            siteDetailUrl: "https://comicvine.gamespot.com/volume/4050-1/"
        )

        #expect(volume.id == 1)
        #expect(volume.name == "Amazing Spider-Man")
        #expect(volume.apiDetailUrl == "https://comicvine.gamespot.com/api/volume/4050-1/")
        #expect(volume.siteDetailUrl == "https://comicvine.gamespot.com/volume/4050-1/")
    }

    @Test("ComicVolume should accept nil name")
    func testNilName() {
        let volume = ComicVolume(
            apiDetailUrl: "https://example.com/api",
            id: 1,
            name: nil,
            siteDetailUrl: "https://example.com/site"
        )

        #expect(volume.id == 1)
        #expect(volume.name == nil)
    }

    @Test("ComicVolume fixture should create valid instance")
    func testFixture() {
        let volume = ComicVolume.apiFixture()

        #expect(volume.id == 1)
        #expect(volume.name == "Amazing Spider-Man")
        #expect(volume.apiDetailUrl.contains("4050-1"))
        #expect(volume.siteDetailUrl.contains("4050-1"))
    }

    @Test("ComicVolume fixture should accept custom values")
    func testFixtureCustomValues() {
        let volume = ComicVolume.apiFixture(
            id: 42,
            name: "X-Men"
        )

        #expect(volume.id == 42)
        #expect(volume.name == "X-Men")
    }
}

// MARK: - ComicVolume Codable Tests

@Suite("ComicVolume Codable Tests")
struct ComicVolumeCodableTests {

    @Test("ComicVolume should encode to JSON")
    func testEncode() throws {
        let volume = ComicVolume.apiFixture()

        let encoder = JSONEncoder()
        let data = try encoder.encode(volume)
        let json = String(data: data, encoding: .utf8)

        #expect(json != nil)
        #expect(json?.contains("Amazing Spider-Man") == true)
    }

    @Test("ComicVolume should decode from JSON")
    func testDecode() throws {
        let json = """
        {
            "apiDetailUrl": "https://example.com/api",
            "id": 1,
            "name": "Test Volume",
            "siteDetailUrl": "https://example.com/site"
        }
        """

        let data = json.data(using: .utf8)!
        let volume = try JSONDecoder().decode(ComicVolume.self, from: data)

        #expect(volume.id == 1)
        #expect(volume.name == "Test Volume")
    }

    @Test("ComicVolume should decode with null name")
    func testDecodeNullName() throws {
        let json = """
        {
            "apiDetailUrl": "https://example.com/api",
            "id": 1,
            "name": null,
            "siteDetailUrl": "https://example.com/site"
        }
        """

        let data = json.data(using: .utf8)!
        let volume = try JSONDecoder().decode(ComicVolume.self, from: data)

        #expect(volume.id == 1)
        #expect(volume.name == nil)
    }

    @Test("ComicVolume should roundtrip encode/decode")
    func testRoundtrip() throws {
        let original = ComicVolume.apiFixture(id: 42, name: "Test Series")

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ComicVolume.self, from: data)

        #expect(original.id == decoded.id)
        #expect(original.name == decoded.name)
        #expect(original.apiDetailUrl == decoded.apiDetailUrl)
        #expect(original.siteDetailUrl == decoded.siteDetailUrl)
    }
}

// MARK: - VolumeSummary Tests

@Suite("VolumeSummary Tests")
struct VolumeSummaryTests {

    @Test("VolumeSummary should initialize with all properties")
    func testFullInitialization() {
        let summary = VolumeSummary(
            id: 1,
            name: "Amazing Spider-Man",
            apiDetailUrl: "https://example.com/api"
        )

        #expect(summary.id == 1)
        #expect(summary.name == "Amazing Spider-Man")
        #expect(summary.apiDetailUrl == "https://example.com/api")
    }

    @Test("VolumeSummary should accept nil apiDetailUrl")
    func testNilApiDetailUrl() {
        let summary = VolumeSummary(
            id: 1,
            name: "Test",
            apiDetailUrl: nil
        )

        #expect(summary.apiDetailUrl == nil)
    }

    @Test("VolumeSummary fixture should create valid instance")
    func testFixture() {
        let summary = VolumeSummary.apiFixture()

        #expect(summary.id == 1)
        #expect(summary.name == "Amazing Spider-Man")
        #expect(summary.apiDetailUrl != nil)
    }

    @Test("VolumeSummary should decode from JSON")
    func testDecode() throws {
        let json = """
        {
            "id": 1,
            "name": "Test Volume",
            "api_detail_url": "https://example.com/api"
        }
        """

        let data = json.data(using: .utf8)!
        let summary = try JSONDecoder().decode(VolumeSummary.self, from: data)

        #expect(summary.id == 1)
        #expect(summary.name == "Test Volume")
    }
}

// MARK: - XCTest Integration Tests

class ComicVolumeXCTests: XCTestCase {

    func testComicVolumeSendableCompliance() {
        let volume = ComicVolume.apiFixture()
        let sendable: any Sendable = volume
        XCTAssertNotNil(sendable)
    }

    func testVolumeSummarySendableCompliance() {
        let summary = VolumeSummary.apiFixture()
        let sendable: any Sendable = summary
        XCTAssertNotNil(sendable)
    }

    func testComicVolumeEncodingFormat() throws {
        let volume = ComicVolume.apiFixture()
        let data = try JSONEncoder().encode(volume)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertNotNil(json)
        XCTAssertEqual(json?["id"] as? Int, 1)
        XCTAssertEqual(json?["name"] as? String, "Amazing Spider-Man")
    }
}
