//
//  CharacterFixture+AppCoordinator.swift
//  AppCoordinator
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for AppCoordinator Tests

extension Character {
    /// Fixture para testes do AppCoordinator
    /// Cria um Character válido para uso em testes de navegação
    static func coordinatorFixture(
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
            deck: "A superhero from New York",
            aliases: "Spidey\nWeb-Slinger",
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/spider-man/4005-\(id)/",
            firstAppearedInIssue: IssueSummary(
                id: 100,
                name: "Amazing Fantasy #15",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-100/",
                issueNumber: "15"
            ),
            countOfIssueAppearances: comicsCount,
            realName: "Peter Parker",
            birth: "1962-08-01",
            dateAdded: "2008-06-06 11:27:46",
            dateLastUpdated: "2024-01-15 10:30:00",
            gender: 1,
            origin: OriginSummary(id: 4, name: "Human"),
            publisher: PublisherSummary(id: 31, name: "Marvel"),
            characterEnemies: [
                CharacterReference(
                    id: 2,
                    name: "Green Goblin",
                    apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-2/",
                    siteDetailUrl: "https://comicvine.gamespot.com/green-goblin/4005-2/"
                )
            ],
            characterFriends: [
                CharacterReference(
                    id: 3,
                    name: "Mary Jane Watson",
                    apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-3/",
                    siteDetailUrl: "https://comicvine.gamespot.com/mary-jane-watson/4005-3/"
                )
            ],
            creators: nil,
            issueCredits: nil,
            powers: [
                PowerReference(id: 1, name: "Super Strength", apiDetailUrl: nil),
                PowerReference(id: 2, name: "Wall Crawling", apiDetailUrl: nil)
            ],
            teams: nil,
            volumeCredits: nil
        )
    }
}

// MARK: - IssueSummary Extension

extension IssueSummary {
    /// Fixture para testes
    static func fixture(
        id: Int = 100,
        name: String? = "Amazing Fantasy #15",
        apiDetailUrl: String? = "https://comicvine.gamespot.com/api/issue/4000-100/",
        issueNumber: String? = "15"
    ) -> IssueSummary {
        IssueSummary(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl,
            issueNumber: issueNumber
        )
    }
}
