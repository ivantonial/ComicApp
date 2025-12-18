//
//  CharacterFixture+Cache.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for Cache Tests

extension Character {
    /// Fixture para testes do módulo Cache
    /// Cria um Character válido para uso em testes de persistência
    static func cacheFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        comicsCount: Int = 100
    ) -> Character {
        let image = ComicVineImage(
            iconUrl: "https://example.com/icon.jpg",
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: "https://example.com/screen.jpg",
            screenLargeUrl: "https://example.com/screen_large.jpg",
            smallUrl: "https://example.com/small.jpg",
            superUrl: "https://example.com/super.jpg",
            thumbUrl: "https://example.com/thumb.jpg",
            tinyUrl: "https://example.com/tiny.jpg",
            originalUrl: "https://example.com/original.jpg"
        )

        return Character(
            id: id,
            name: name,
            description: description,
            deck: "A superhero",
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: comicsCount,
            realName: "Peter Parker",
            birth: nil,
            dateAdded: "2008-06-06 11:27:46",
            dateLastUpdated: "2024-01-15 10:30:00",
            gender: 1,
            origin: OriginSummary(id: 4, name: "Human"),
            publisher: PublisherSummary(id: 31, name: "Marvel"),
            characterEnemies: nil,
            characterFriends: nil,
            creators: nil,
            issueCredits: nil,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }

    /// Fixture com campos mínimos para testes básicos
    static func minimalCacheFixture(id: Int = 1, name: String = "Hero") -> Character {
        let image = ComicVineImage()

        return Character(
            id: id,
            name: name,
            description: nil,
            deck: nil,
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: 0,
            realName: nil,
            birth: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-01 00:00:00",
            gender: nil,
            origin: nil,
            publisher: nil,
            characterEnemies: nil,
            characterFriends: nil,
            creators: nil,
            issueCredits: nil,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }
}

// MARK: - Character Collection Fixture

extension Array where Element == Character {
    /// Cria uma lista de Characters para testes
    static func cacheFixtures(count: Int) -> [Character] {
        (1...count).map { index in
            Character.cacheFixture(
                id: index,
                name: "Hero \(index)",
                description: "Description for Hero \(index)",
                comicsCount: index * 10
            )
        }
    }
}
