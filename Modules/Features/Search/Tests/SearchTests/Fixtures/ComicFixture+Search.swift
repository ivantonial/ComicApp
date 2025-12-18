//
//  ComicFixture+Search.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

@testable import ComicVineAPI
import Foundation

// MARK: - Comic Search Fixtures

public extension Comic {

    // MARK: - Basic Fixtures

    /// Fixture padrão para testes de busca
    static func searchFixture(
        id: Int = 1001,
        name: String? = "Test Comic",
        issueNumber: String? = "1",
        description: String? = "A test comic for search functionality",
        deck: String? = "Test comic deck",
        image: ComicVineImage = .searchComicFixture(),
        coverDate: String? = "2024-01-15",
        storeDate: String? = "2024-01-10",
        apiDetailUrl: String = "https://comicvine.gamespot.com/api/issue/4000-1001/",
        siteDetailUrl: String = "https://comicvine.gamespot.com/test-comic/4000-1001/",
        volume: VolumeSummary? = .searchFixture(),
        hasStaffReview: Bool? = false,
        dateAdded: String = "2024-01-01 10:00:00",
        dateLastUpdated: String = "2024-01-15 12:00:00"
    ) -> Comic {
        Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: deck,
            image: image,
            coverDate: coverDate,
            storeDate: storeDate,
            apiDetailUrl: apiDetailUrl,
            siteDetailUrl: siteDetailUrl,
            volume: volume,
            hasStaffReview: hasStaffReview,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated
        )
    }

    /// Fixture mínima para testes básicos
    static func minimalSearchComicFixture(
        id: Int = 9999,
        name: String? = nil,
        issueNumber: String? = "1"
    ) -> Comic {
        Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: nil,
            deck: nil,
            image: .emptySearchComicFixture(),
            coverDate: nil,
            storeDate: nil,
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: nil,
            hasStaffReview: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-01 00:00:00"
        )
    }

    // MARK: - Type-Specific Fixtures

    /// Fixture para série ongoing/regular
    static func ongoingSearchFixture(
        id: Int = 2001,
        volumeName: String = "Amazing Spider-Man",
        issueNumber: String = "42"
    ) -> Comic {
        Comic(
            id: id,
            name: nil,
            issueNumber: issueNumber,
            description: "Regular ongoing series issue",
            deck: "Ongoing series",
            image: .searchComicFixture(),
            coverDate: "2024-02-15",
            storeDate: "2024-02-10",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: VolumeSummary(id: id + 1000, name: volumeName, apiDetailUrl: nil),
            hasStaffReview: false,
            dateAdded: "2024-02-01 10:00:00",
            dateLastUpdated: "2024-02-15 12:00:00"
        )
    }

    /// Fixture para edição especial (Annual/Special)
    static func specialSearchFixture(
        id: Int = 3001,
        specialType: String = "Annual"
    ) -> Comic {
        Comic(
            id: id,
            name: "Batman \(specialType) #1",
            issueNumber: "1",
            description: "Special edition comic",
            deck: "\(specialType) issue",
            image: .searchComicFixture(),
            coverDate: "2024-03-15",
            storeDate: "2024-03-10",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: VolumeSummary(id: id + 1000, name: "Batman \(specialType)", apiDetailUrl: nil),
            hasStaffReview: true,
            dateAdded: "2024-03-01 10:00:00",
            dateLastUpdated: "2024-03-15 12:00:00"
        )
    }

    /// Fixture para edição variante
    static func variantSearchFixture(
        id: Int = 4001,
        volumeName: String = "X-Men"
    ) -> Comic {
        Comic(
            id: id,
            name: "\(volumeName) #1 Variant Cover",
            issueNumber: "1",
            description: "Variant cover edition",
            deck: "Variant cover",
            image: .searchComicFixture(),
            coverDate: "2024-04-15",
            storeDate: "2024-04-10",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: VolumeSummary(id: id + 1000, name: "\(volumeName) Variant", apiDetailUrl: nil),
            hasStaffReview: false,
            dateAdded: "2024-04-01 10:00:00",
            dateLastUpdated: "2024-04-15 12:00:00"
        )
    }

    /// Fixture com nome customizado
    static func namedSearchComicFixture(
        id: Int = 5001,
        name: String,
        volumeName: String? = nil
    ) -> Comic {
        let volume = volumeName.map { VolumeSummary(id: id + 1000, name: $0, apiDetailUrl: nil) }
        return Comic(
            id: id,
            name: name,
            issueNumber: "1",
            description: "Named comic for search",
            deck: nil,
            image: .searchComicFixture(),
            coverDate: "2024-05-15",
            storeDate: "2024-05-10",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: nil,
            dateAdded: "2024-05-01 10:00:00",
            dateLastUpdated: "2024-05-15 12:00:00"
        )
    }
}

// MARK: - Array Extensions for Comic Fixtures

public extension Array where Element == Comic {

    /// Gera múltiplas fixtures de comic para testes
    static func searchComicFixtures(count: Int) -> [Comic] {
        (1...count).map { index in
            let dayValue = Swift.min(index, 28)
            return Comic.searchFixture(
                id: 1000 + index,
                name: "Test Comic \(index)",
                issueNumber: "\(index)",
                dateLastUpdated: "2024-01-\(String(format: "%02d", dayValue)) 12:00:00"
            )
        }
    }

    /// Fixtures de séries ongoing
    static func ongoingSearchComicFixtures() -> [Comic] {
        [
            Comic.ongoingSearchFixture(id: 2001, volumeName: "Amazing Spider-Man", issueNumber: "42"),
            Comic.ongoingSearchFixture(id: 2002, volumeName: "Batman", issueNumber: "137"),
            Comic.ongoingSearchFixture(id: 2003, volumeName: "X-Men", issueNumber: "28")
        ]
    }

    /// Fixtures de edições especiais
    static func specialSearchComicFixtures() -> [Comic] {
        [
            Comic.specialSearchFixture(id: 3001, specialType: "Annual"),
            Comic.specialSearchFixture(id: 3002, specialType: "Special"),
            Comic.specialSearchFixture(id: 3003, specialType: "Giant-Size")
        ]
    }

    /// Fixtures mistas para testes de filtro
    /// Retorna 6 comics: 2 ongoing, 2 annual, 1 special, 1 variant
    static func mixedSearchComicFixtures() -> [Comic] {
        [
            // Ongoing (regular issues - sem "annual", "special", "variant" no título)
            Comic.ongoingSearchFixture(id: 2001, volumeName: "Amazing Spider-Man", issueNumber: "42"),
            Comic.ongoingSearchFixture(id: 2002, volumeName: "Batman", issueNumber: "137"),
            // Annual
            Comic(
                id: 3001,
                name: "Spider-Man Annual #1",
                issueNumber: "1",
                description: "Annual issue",
                deck: nil,
                image: .searchComicFixture(),
                coverDate: "2024-06-15",
                storeDate: "2024-06-10",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-3001/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-3001/",
                volume: VolumeSummary(id: 4001, name: "Spider-Man Annual", apiDetailUrl: nil),
                hasStaffReview: false,
                dateAdded: "2024-06-01 10:00:00",
                dateLastUpdated: "2024-06-15 12:00:00"
            ),
            Comic(
                id: 3002,
                name: "Batman Annual #2",
                issueNumber: "2",
                description: "Annual issue",
                deck: nil,
                image: .searchComicFixture(),
                coverDate: "2024-07-15",
                storeDate: "2024-07-10",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-3002/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-3002/",
                volume: VolumeSummary(id: 4002, name: "Batman Annual", apiDetailUrl: nil),
                hasStaffReview: false,
                dateAdded: "2024-07-01 10:00:00",
                dateLastUpdated: "2024-07-15 12:00:00"
            ),
            // Special
            Comic.specialSearchFixture(id: 3003, specialType: "Special"),
            // Variant
            Comic.variantSearchFixture(id: 4001, volumeName: "X-Men")
        ]
    }

    /// Fixtures com títulos variados para testes de busca
    static func searchComicTitleFixtures() -> [Comic] {
        [
            Comic.namedSearchComicFixture(id: 5001, name: "Action Comics", volumeName: "Action Comics"),
            Comic.namedSearchComicFixture(id: 5002, name: "Detective Comics", volumeName: "Detective Comics"),
            Comic.namedSearchComicFixture(id: 5003, name: "Adventure Comics", volumeName: "Adventure Comics"),
            Comic.namedSearchComicFixture(id: 5004, name: "Brave and the Bold", volumeName: "Brave and the Bold"),
            Comic.namedSearchComicFixture(id: 5005, name: "World's Finest", volumeName: "World's Finest")
        ]
    }

    /// Fixtures por nome de série para testes de busca
    static func searchComicByNameFixtures() -> [Comic] {
        [
            Comic.searchFixture(
                id: 6001,
                name: nil,
                issueNumber: "1",
                volume: VolumeSummary(id: 7001, name: "Spider-Man", apiDetailUrl: nil)
            ),
            Comic.searchFixture(
                id: 6002,
                name: nil,
                issueNumber: "1",
                volume: VolumeSummary(id: 7002, name: "Batman", apiDetailUrl: nil)
            ),
            Comic.searchFixture(
                id: 6003,
                name: nil,
                issueNumber: "1",
                volume: VolumeSummary(id: 7003, name: "Superman", apiDetailUrl: nil)
            ),
            Comic.searchFixture(
                id: 6004,
                name: nil,
                issueNumber: "1",
                volume: VolumeSummary(id: 7004, name: "Wonder Woman", apiDetailUrl: nil)
            )
        ]
    }
}

// MARK: - VolumeSummary Fixtures

public extension VolumeSummary {

    /// Fixture padrão para testes
    static func searchFixture(
        id: Int = 101,
        name: String = "Test Volume",
        apiDetailUrl: String? = "https://comicvine.gamespot.com/api/volume/4050-101/"
    ) -> VolumeSummary {
        VolumeSummary(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl
        )
    }
}

// MARK: - ComicVineImage Fixtures for Search

public extension ComicVineImage {

    /// Fixture padrão de imagem para testes de busca de comics
    static func searchComicFixture() -> ComicVineImage {
        ComicVineImage(
            iconUrl: "https://comicvine.gamespot.com/a/uploads/square_avatar/icon.jpg",
            mediumUrl: "https://comicvine.gamespot.com/a/uploads/scale_medium/medium.jpg",
            screenUrl: "https://comicvine.gamespot.com/a/uploads/screen_medium/screen.jpg",
            screenLargeUrl: "https://comicvine.gamespot.com/a/uploads/screen_kubrick/screen_large.jpg",
            smallUrl: "https://comicvine.gamespot.com/a/uploads/scale_small/small.jpg",
            superUrl: "https://comicvine.gamespot.com/a/uploads/scale_super/super.jpg",
            thumbUrl: "https://comicvine.gamespot.com/a/uploads/scale_avatar/thumb.jpg",
            tinyUrl: "https://comicvine.gamespot.com/a/uploads/square_mini/tiny.jpg",
            originalUrl: "https://comicvine.gamespot.com/a/uploads/original/original.jpg"
        )
    }

    /// Fixture de imagem vazia para testes de busca de comics
    static func emptySearchComicFixture() -> ComicVineImage {
        ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )
    }
}

// MARK: - Fixture Self-Tests

import Testing

@Suite("Comic Search Fixture Validation Tests")
struct ComicSearchFixtureValidationTests {

    @Test("searchFixture should create valid Comic")
    func testSearchFixture() {
        let comic = Comic.searchFixture()
        #expect(comic.id == 1001)
        #expect(comic.name == "Test Comic")
        #expect(comic.issueNumber == "1")
        #expect(comic.volume != nil)
    }

    @Test("minimalSearchComicFixture should create Comic with minimal data")
    func testMinimalSearchComicFixture() {
        let comic = Comic.minimalSearchComicFixture()
        #expect(comic.id == 9999)
        #expect(comic.description == nil)
        #expect(comic.volume == nil)
    }

    @Test("ongoingSearchFixture should create ongoing series comic")
    func testOngoingSearchFixture() {
        let comic = Comic.ongoingSearchFixture()
        #expect(comic.volume?.name == "Amazing Spider-Man")
        #expect(comic.issueNumber == "42")
        // Title should be "Amazing Spider-Man #42"
        #expect(comic.title == "Amazing Spider-Man #42")
    }

    @Test("specialSearchFixture should create special edition comic")
    func testSpecialSearchFixture() {
        let comic = Comic.specialSearchFixture(specialType: "Annual")
        #expect(comic.name?.contains("Annual") == true)
    }

    @Test("variantSearchFixture should create variant cover comic")
    func testVariantSearchFixture() {
        let comic = Comic.variantSearchFixture()
        #expect(comic.name?.contains("Variant") == true)
    }

    @Test("mixedSearchComicFixtures should return correct count and types")
    func testMixedSearchComicFixtures() {
        let comics = [Comic].mixedSearchComicFixtures()
        #expect(comics.count == 6)

        // Check for special types
        let specialCount = comics.filter { comic in
            let title = comic.title.lowercased()
            return title.contains("annual") || title.contains("special") || title.contains("variant")
        }.count
        #expect(specialCount == 4) // 2 annual + 1 special + 1 variant
    }

    @Test("VolumeSummary searchFixture should create valid volume")
    func testVolumeSummarySearchFixture() {
        let volume = VolumeSummary.searchFixture()
        #expect(volume.id == 101)
        #expect(volume.name == "Test Volume")
        #expect(volume.apiDetailUrl != nil)
    }

    @Test("ComicVineImage searchComicFixture should have all URLs")
    func testComicVineImageSearchComicFixture() {
        let image = ComicVineImage.searchComicFixture()
        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage emptySearchComicFixture should have nil URLs")
    func testComicVineImageEmptySearchComicFixture() {
        let image = ComicVineImage.emptySearchComicFixture()
        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.originalUrl == nil)
    }
}
