//
//  ComicFixture+ComicsList.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Comic Fixture for ComicsList Tests

extension Comic {

    /// Fixture padrão para testes do módulo ComicsList
    /// Cria um Comic válido com todos os campos básicos preenchidos
    static func comicsListFixture(
        id: Int = 100,
        name: String? = nil,
        volumeName: String = "Amazing Spider-Man",
        issueNumber: String? = "1",
        description: String? = "First appearance of the villain",
        coverDate: String? = "2024-01-01",
        storeDate: String? = "2024-01-15",
        hasImage: Bool = true
    ) -> Comic {
        let image = hasImage ? ComicVineImage.comicsListFixture() : ComicVineImage()

        let volume = VolumeSummary(
            id: 1,
            name: volumeName,
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
        )

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: nil,
            image: image,
            coverDate: coverDate,
            storeDate: storeDate,
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: false,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-15 00:00:00"
        )
    }

    /// Fixture mínima para testes básicos
    static func minimalComicsListFixture(id: Int = 100) -> Comic {
        let image = ComicVineImage()

        return Comic(
            id: id,
            name: nil,
            issueNumber: nil,
            description: nil,
            deck: nil,
            image: image,
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

    /// Fixture para testes de ordenação por data (recentes)
    static func recentComicFixture(
        id: Int,
        daysAgo: Int = 0
    ) -> Comic {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let coverDate = formatter.string(from: date)

        return comicsListFixture(
            id: id,
            volumeName: "Recent Comic",
            issueNumber: "\(id)",
            coverDate: coverDate
        )
    }

    /// Fixture para testes de ordenação por data (clássicos)
    static func classicComicFixture(
        id: Int,
        year: Int = 1970
    ) -> Comic {
        let month = (id % 12) + 1
        let coverDate = String(format: "%04d-%02d-01", year, month)

        return comicsListFixture(
            id: id,
            volumeName: "Classic Comic",
            issueNumber: "\(id)",
            coverDate: coverDate
        )
    }

    /// Fixture para comic sem data de capa
    static func comicWithoutCoverDate(id: Int = 100) -> Comic {
        comicsListFixture(
            id: id,
            coverDate: nil
        )
    }

    /// Fixture para comic com nome personalizado
    static func namedComicFixture(
        id: Int = 100,
        name: String
    ) -> Comic {
        let image = ComicVineImage.comicsListFixture()

        return Comic(
            id: id,
            name: name,
            issueNumber: nil,
            description: nil,
            deck: nil,
            image: image,
            coverDate: "2024-01-01",
            storeDate: nil,
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: nil,
            hasStaffReview: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-01 00:00:00"
        )
    }
}

// MARK: - Comic Collection Fixtures

extension Array where Element == Comic {

    /// Cria uma lista de Comics para testes
    static func comicsListFixtures(count: Int, volumeName: String = "Amazing Spider-Man") -> [Comic] {
        (1...count).map { index in
            let volume = VolumeSummary(
                id: 1,
                name: volumeName,
                apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
            )

            let image = ComicVineImage(
                iconUrl: nil,
                mediumUrl: "https://example.com/comic_\(index)_medium.jpg",
                screenUrl: nil,
                screenLargeUrl: nil,
                smallUrl: nil,
                superUrl: nil,
                thumbUrl: "https://example.com/comic_\(index)_thumb.jpg",
                tinyUrl: nil,
                originalUrl: nil
            )

            let month = ((index - 1) % 12) + 1
            let coverDate = String(format: "2024-%02d-01", month)

            return Comic(
                id: 100 + index,
                name: nil,
                issueNumber: "\(index)",
                description: "Issue \(index) description",
                deck: nil,
                image: image,
                coverDate: coverDate,
                storeDate: String(format: "2024-%02d-15", month),
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(100 + index)/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(100 + index)/",
                volume: volume,
                hasStaffReview: false,
                dateAdded: "2024-01-01 00:00:00",
                dateLastUpdated: "2024-01-15 00:00:00"
            )
        }
    }

    /// Cria uma lista de Comics com datas variadas para testes de ordenação
    static func comicsListFixturesForSorting() -> [Comic] {
        [
            Comic.comicsListFixture(id: 1, coverDate: "2024-03-01"),  // Março
            Comic.comicsListFixture(id: 2, coverDate: "2024-01-01"),  // Janeiro (mais antigo)
            Comic.comicsListFixture(id: 3, coverDate: "2024-06-01"),  // Junho (mais recente)
            Comic.comicsListFixture(id: 4, coverDate: "2024-02-01"),  // Fevereiro
            Comic.comicsListFixture(id: 5, coverDate: nil),           // Sem data
        ]
    }

    /// Cria uma lista de Comics recentes
    static func recentComicsListFixtures(count: Int) -> [Comic] {
        (1...count).map { index in
            Comic.recentComicFixture(id: 100 + index, daysAgo: index * 7)
        }
    }

    /// Cria uma lista de Comics clássicas
    static func classicComicsListFixtures(count: Int, startYear: Int = 1970) -> [Comic] {
        (1...count).map { index in
            Comic.classicComicFixture(id: 100 + index, year: startYear + index)
        }
    }

    /// Cria uma página de resultados para testes de paginação
    static func pageComicsListFixtures(page: Int, pageSize: Int = 20) -> [Comic] {
        let startIndex = (page * pageSize) + 1
        let endIndex = startIndex + pageSize - 1

        return (startIndex...endIndex).map { index in
            Comic.comicsListFixture(
                id: 100 + index,
                issueNumber: "\(index)"
            )
        }
    }
}

// MARK: - VolumeSummary Fixture

extension VolumeSummary {

    /// Fixture para testes do módulo ComicsList
    static func comicsListFixture(
        id: Int = 1,
        name: String = "Amazing Spider-Man",
        apiDetailUrl: String? = "https://comicvine.gamespot.com/api/volume/4050-1/"
    ) -> VolumeSummary {
        VolumeSummary(id: id, name: name, apiDetailUrl: apiDetailUrl)
    }
}

// MARK: - Fixture Validation Tests

#if DEBUG
import Testing

@Suite("ComicsList Comic Fixture Validation Tests")
struct ComicsListComicFixtureValidationTests {

    @Test("Comic comicsListFixture should create valid comic")
    func testComicComicsListFixture() {
        // Act
        let comic = Comic.comicsListFixture()

        // Assert
        #expect(comic.id == 100)
        #expect(comic.volume?.name == "Amazing Spider-Man")
        #expect(comic.issueNumber == "1")
        #expect(comic.coverDate == "2024-01-01")
    }

    @Test("Comic comicsListFixture should allow custom values")
    func testComicComicsListFixtureCustom() {
        // Act
        let comic = Comic.comicsListFixture(
            id: 200,
            volumeName: "X-Men",
            issueNumber: "50",
            description: "Classic X-Men issue",
            coverDate: "1990-05-01"
        )

        // Assert
        #expect(comic.id == 200)
        #expect(comic.volume?.name == "X-Men")
        #expect(comic.issueNumber == "50")
        #expect(comic.description == "Classic X-Men issue")
        #expect(comic.coverDate == "1990-05-01")
    }

    @Test("Comic minimalComicsListFixture should work correctly")
    func testMinimalComicsListFixture() {
        // Act
        let comic = Comic.minimalComicsListFixture(id: 999)

        // Assert
        #expect(comic.id == 999)
        #expect(comic.name == nil)
        #expect(comic.issueNumber == nil)
        #expect(comic.volume == nil)
        #expect(comic.coverDate == nil)
    }

    @Test("Comic array comicsListFixtures should create multiple comics")
    func testArrayComicsListFixtures() {
        // Act
        let comics: [Comic] = .comicsListFixtures(count: 5)

        // Assert
        #expect(comics.count == 5)
        for (index, comic) in comics.enumerated() {
            #expect(comic.id == 100 + index + 1)
            #expect(comic.issueNumber == "\(index + 1)")
        }
    }

    @Test("Comic comicsListFixturesForSorting should have correct dates")
    func testComicsListFixturesForSorting() {
        // Act
        let comics: [Comic] = .comicsListFixturesForSorting()

        // Assert
        #expect(comics.count == 5)
        #expect(comics[0].coverDate == "2024-03-01")
        #expect(comics[1].coverDate == "2024-01-01")
        #expect(comics[2].coverDate == "2024-06-01")
        #expect(comics[3].coverDate == "2024-02-01")
        #expect(comics[4].coverDate == nil)
    }

    @Test("Comic pageComicsListFixtures should create correct page")
    func testPageComicsListFixtures() {
        // Act
        let page0: [Comic] = .pageComicsListFixtures(page: 0, pageSize: 10)
        let page1: [Comic] = .pageComicsListFixtures(page: 1, pageSize: 10)

        // Assert
        #expect(page0.count == 10)
        #expect(page0.first?.id == 101)
        #expect(page0.last?.id == 110)

        #expect(page1.count == 10)
        #expect(page1.first?.id == 111)
        #expect(page1.last?.id == 120)
    }

    @Test("Comic title should use volume name and issue number")
    func testComicTitle() {
        // Act
        let comic = Comic.comicsListFixture(volumeName: "Batman", issueNumber: "100")

        // Assert
        #expect(comic.title == "Batman #100")
    }

    @Test("Comic title should fallback to name when no volume")
    func testComicTitleFallback() {
        // Act
        let comic = Comic.namedComicFixture(id: 1, name: "Special Edition")

        // Assert
        #expect(comic.title == "Special Edition")
    }

    @Test("VolumeSummary comicsListFixture should create valid volume")
    func testVolumeSummaryComicsListFixture() {
        // Act
        let volume = VolumeSummary.comicsListFixture()

        // Assert
        #expect(volume.id == 1)
        #expect(volume.name == "Amazing Spider-Man")
        #expect(volume.apiDetailUrl != nil)
    }

    @Test("VolumeSummary comicsListFixture should allow custom values")
    func testVolumeSummaryComicsListFixtureCustom() {
        // Act
        let volume = VolumeSummary.comicsListFixture(
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
#endif
