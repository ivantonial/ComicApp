//
//  ComicFixture+ComicVineAPI.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation

// MARK: - Comic Fixture for ComicVineAPI Tests

extension Comic {
    /// Fixture completa para testes do módulo ComicVineAPI
    /// Cria um Comic válido com todos os campos preenchidos
    static func apiFixture(
        id: Int = 100,
        name: String? = "The Night Gwen Stacy Died",
        issueNumber: String? = "121",
        description: String? = "A classic Spider-Man story",
        deck: String? = "One of the most important issues in comics history",
        coverDate: String? = "1973-06-01",
        storeDate: String? = "1973-05-15",
        hasStaffReview: Bool? = true,
        volumeName: String = "Amazing Spider-Man",
        volumeId: Int = 1
    ) -> Comic {
        let image = ComicVineImage.apiFixture()

        let volume = VolumeSummary(
            id: volumeId,
            name: volumeName,
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-\(volumeId)/"
        )

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: deck,
            image: image,
            coverDate: coverDate,
            storeDate: storeDate,
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: hasStaffReview,
            dateAdded: "2008-06-06 11:27:46",
            dateLastUpdated: "2024-01-15 10:30:00"
        )
    }

    /// Fixture com campos mínimos para testes básicos
    static func minimalApiFixture(id: Int = 100) -> Comic {
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

    /// Fixture sem volume para testar o title computed property
    static func withoutVolumeFixture(
        id: Int = 100,
        name: String? = "Special Issue",
        issueNumber: String? = "1"
    ) -> Comic {
        let image = ComicVineImage()

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
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

    /// Fixture para testes de ordenação por data
    static func withDateFixture(
        id: Int,
        coverDate: String,
        volumeName: String = "Test Volume"
    ) -> Comic {
        let image = ComicVineImage()

        let volume = VolumeSummary(
            id: 1,
            name: volumeName,
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
        )

        return Comic(
            id: id,
            name: nil,
            issueNumber: String(id),
            description: nil,
            deck: nil,
            image: image,
            coverDate: coverDate,
            storeDate: nil,
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-01 00:00:00"
        )
    }
}

// MARK: - Comic Collection Fixture

extension Array where Element == Comic {
    /// Cria uma lista de Comics para testes
    static func apiFixtures(count: Int, volumeName: String = "Amazing Spider-Man") -> [Comic] {
        (1...count).map { index in
            Comic.apiFixture(
                id: 100 + index,
                name: nil,
                issueNumber: "\(index)",
                description: "Issue \(index) description",
                coverDate: "2024-0\(Swift.min(index, 9))-01",
                volumeName: volumeName,
                volumeId: 1
            )
        }
    }

    /// Cria uma lista de Comics com datas variadas para testes de ordenação
    static func apiFixturesWithDates(dates: [String]) -> [Comic] {
        dates.enumerated().map { index, date in
            Comic.withDateFixture(
                id: 100 + index,
                coverDate: date
            )
        }
    }
}

// MARK: - VolumeSummary Fixture

extension VolumeSummary {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 1,
        name: String = "Amazing Spider-Man",
        apiDetailUrl: String? = nil
    ) -> VolumeSummary {
        VolumeSummary(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/volume/4050-\(id)/"
        )
    }
}

// MARK: - ComicVolume Fixture

extension ComicVolume {
    /// Fixture para testes
    static func apiFixture(
        apiDetailUrl: String = "https://comicvine.gamespot.com/api/volume/4050-1/",
        id: Int = 1,
        name: String? = "Amazing Spider-Man",
        siteDetailUrl: String = "https://comicvine.gamespot.com/volume/4050-1/"
    ) -> ComicVolume {
        ComicVolume(
            apiDetailUrl: apiDetailUrl,
            id: id,
            name: name,
            siteDetailUrl: siteDetailUrl
        )
    }
}
