//
//  ComicFixture+Cache.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

import ComicVineAPI
import Foundation

// MARK: - Comic Fixture for Cache Tests

extension Comic {
    /// Fixture para testes do módulo Cache
    /// Cria um Comic válido para uso em testes de persistência
    static func cacheFixture(
        id: Int = 100,
        name: String? = "Amazing Spider-Man",
        issueNumber: String? = "1",
        description: String? = "First issue"
    ) -> Comic {
        let image = ComicVineImage(
            iconUrl: "https://example.com/comic_icon.jpg",
            mediumUrl: "https://example.com/comic_medium.jpg",
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: "https://example.com/comic_thumb.jpg",
            tinyUrl: nil,
            originalUrl: "https://example.com/comic_original.jpg"
        )

        let volume = VolumeSummary(
            id: 1,
            name: "Amazing Spider-Man",
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
        )

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: nil,
            image: image,
            coverDate: "2024-01-01",
            storeDate: "2024-01-15",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: false,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-15 00:00:00"
        )
    }

    /// Fixture com campos mínimos para testes básicos
    static func minimalCacheFixture(id: Int = 100) -> Comic {
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
}

// MARK: - Comic Collection Fixture

extension Array where Element == Comic {
    /// Cria uma lista de Comics para testes
    static func cacheFixtures(count: Int, volumeName: String = "Amazing Spider-Man") -> [Comic] {
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

            return Comic(
                id: 100 + index,
                name: nil,
                issueNumber: "\(index)",
                description: "Issue \(index) description",
                deck: nil,
                image: image,
                coverDate: "2024-0\(Swift.min(index, 9))-01",
                storeDate: "2024-0\(Swift.min(index, 9))-15",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(100 + index)/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(100 + index)/",
                volume: volume,
                hasStaffReview: false,
                dateAdded: "2024-01-01 00:00:00",
                dateLastUpdated: "2024-01-15 00:00:00"
            )
        }
    }
}

// MARK: - VolumeSummary Fixture

extension VolumeSummary {
    /// Fixture para testes
    static func cacheFixture(
        id: Int = 1,
        name: String = "Amazing Spider-Man",
        apiDetailUrl: String? = "https://comicvine.gamespot.com/api/volume/4050-1/"
    ) -> VolumeSummary {
        VolumeSummary(id: id, name: name, apiDetailUrl: apiDetailUrl)
    }
}
