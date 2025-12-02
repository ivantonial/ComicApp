//
//  CharacterFixture+ComicVineAPI.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation

// MARK: - Character Fixture for ComicVineAPI Tests

extension Character {
    /// Fixture completa para testes do módulo ComicVineAPI
    /// Cria um Character válido com todos os campos preenchidos
    static func apiFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        deck: String? = "A superhero from New York",
        aliases: String? = "Spidey\nWeb-Slinger",
        comicsCount: Int = 100,
        realName: String? = "Peter Parker",
        birth: String? = "1962-08-01",
        gender: Int? = 1,
        includeRelations: Bool = true
    ) -> Character {
        let image = ComicVineImage.apiFixture()

        let firstAppearedInIssue: IssueSummary? = includeRelations ? IssueSummary.apiFixture() : nil

        let origin: OriginSummary? = includeRelations ? OriginSummary(id: 4, name: "Human") : nil
        let publisher: PublisherSummary? = includeRelations ? PublisherSummary(id: 31, name: "Marvel") : nil

        let characterEnemies: [CharacterReference]? = includeRelations ? [
            CharacterReference.apiFixture(id: 2, name: "Green Goblin"),
            CharacterReference.apiFixture(id: 3, name: "Doctor Octopus")
        ] : nil

        let characterFriends: [CharacterReference]? = includeRelations ? [
            CharacterReference.apiFixture(id: 4, name: "Mary Jane Watson"),
            CharacterReference.apiFixture(id: 5, name: "Harry Osborn")
        ] : nil

        let creators: [CreatorReference]? = includeRelations ? [
            CreatorReference.apiFixture(id: 1, name: "Stan Lee"),
            CreatorReference.apiFixture(id: 2, name: "Steve Ditko")
        ] : nil

        let issueCredits: [IssueCredit]? = includeRelations ? [
            IssueCredit.apiFixture(id: 100, name: "Amazing Fantasy #15"),
            IssueCredit.apiFixture(id: 101, name: "Amazing Spider-Man #1"),
            IssueCredit.apiFixture(id: 102, name: "Amazing Spider-Man #2")
        ] : nil

        let powers: [PowerReference]? = includeRelations ? [
            PowerReference.apiFixture(id: 1, name: "Super Strength"),
            PowerReference.apiFixture(id: 2, name: "Wall Crawling"),
            PowerReference.apiFixture(id: 3, name: "Spider-Sense")
        ] : nil

        let teams: [TeamReference]? = includeRelations ? [
            TeamReference.apiFixture(id: 1, name: "Avengers"),
            TeamReference.apiFixture(id: 2, name: "Fantastic Four")
        ] : nil

        let volumeCredits: [VolumeCredit]? = includeRelations ? [
            VolumeCredit.apiFixture(id: 1, name: "Amazing Spider-Man"),
            VolumeCredit.apiFixture(id: 2, name: "Spectacular Spider-Man")
        ] : nil

        return Character(
            id: id,
            name: name,
            description: description,
            deck: deck,
            aliases: aliases,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/spider-man/4005-\(id)/",
            firstAppearedInIssue: firstAppearedInIssue,
            countOfIssueAppearances: comicsCount,
            realName: realName,
            birth: birth,
            dateAdded: "2008-06-06 11:27:46",
            dateLastUpdated: "2024-01-15 10:30:00",
            gender: gender,
            origin: origin,
            publisher: publisher,
            characterEnemies: characterEnemies,
            characterFriends: characterFriends,
            creators: creators,
            issueCredits: issueCredits,
            powers: powers,
            teams: teams,
            volumeCredits: volumeCredits
        )
    }

    /// Fixture com campos mínimos para testes básicos
    static func minimalApiFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para testes de cache com makeFromCache
    static func fromCacheFixture(
        id: Int = 1,
        name: String = "Cached Hero",
        description: String? = "A cached hero",
        thumbnailPath: String? = "https://example.com/thumb.jpg",
        comicsCount: Int = 50
    ) -> Character {
        return Character.makeFromCache(
            id: id,
            name: name,
            description: description,
            thumbnailPath: thumbnailPath,
            comicsCount: comicsCount
        )
    }
}

// MARK: - Character Collection Fixture

extension Array where Element == Character {
    /// Cria uma lista de Characters para testes
    static func apiFixtures(count: Int, includeRelations: Bool = false) -> [Character] {
        (1...count).map { index in
            Character.apiFixture(
                id: index,
                name: "Hero \(index)",
                description: "Description for Hero \(index)",
                comicsCount: index * 10,
                includeRelations: includeRelations
            )
        }
    }
}

// MARK: - IssueSummary Fixture

extension IssueSummary {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 100,
        name: String? = "Amazing Fantasy #15",
        apiDetailUrl: String? = nil,
        issueNumber: String? = "15"
    ) -> IssueSummary {
        IssueSummary(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            issueNumber: issueNumber
        )
    }
}

// MARK: - OriginSummary Fixture

extension OriginSummary {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 4,
        name: String = "Human"
    ) -> OriginSummary {
        OriginSummary(id: id, name: name)
    }
}

// MARK: - PublisherSummary Fixture

extension PublisherSummary {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 31,
        name: String = "Marvel"
    ) -> PublisherSummary {
        PublisherSummary(id: id, name: name)
    }
}

// MARK: - CharacterReference Fixture

extension CharacterReference {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 2,
        name: String = "Green Goblin",
        apiDetailUrl: String? = nil,
        siteDetailUrl: String? = nil
    ) -> CharacterReference {
        CharacterReference(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: siteDetailUrl ?? "https://comicvine.gamespot.com/character/4005-\(id)/"
        )
    }
}

// MARK: - CreatorReference Fixture

extension CreatorReference {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 1,
        name: String = "Stan Lee",
        apiDetailUrl: String? = nil,
        siteDetailUrl: String? = nil
    ) -> CreatorReference {
        CreatorReference(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/person/4040-\(id)/",
            siteDetailUrl: siteDetailUrl ?? "https://comicvine.gamespot.com/person/4040-\(id)/"
        )
    }
}

// MARK: - IssueCredit Fixture

extension IssueCredit {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 100,
        name: String? = "Amazing Fantasy #15",
        apiDetailUrl: String? = nil,
        siteDetailUrl: String? = nil
    ) -> IssueCredit {
        IssueCredit(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: siteDetailUrl ?? "https://comicvine.gamespot.com/issue/4000-\(id)/"
        )
    }
}

// MARK: - PowerReference Fixture

extension PowerReference {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 1,
        name: String = "Super Strength",
        apiDetailUrl: String? = nil
    ) -> PowerReference {
        PowerReference(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/power/4035-\(id)/"
        )
    }
}

// MARK: - TeamReference Fixture

extension TeamReference {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 1,
        name: String = "Avengers",
        apiDetailUrl: String? = nil,
        siteDetailUrl: String? = nil
    ) -> TeamReference {
        TeamReference(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/team/4060-\(id)/",
            siteDetailUrl: siteDetailUrl ?? "https://comicvine.gamespot.com/team/4060-\(id)/"
        )
    }
}

// MARK: - VolumeCredit Fixture

extension VolumeCredit {
    /// Fixture para testes
    static func apiFixture(
        id: Int = 1,
        name: String = "Amazing Spider-Man",
        apiDetailUrl: String? = nil,
        siteDetailUrl: String? = nil
    ) -> VolumeCredit {
        VolumeCredit(
            id: id,
            name: name,
            apiDetailUrl: apiDetailUrl ?? "https://comicvine.gamespot.com/api/volume/4050-\(id)/",
            siteDetailUrl: siteDetailUrl ?? "https://comicvine.gamespot.com/volume/4050-\(id)/"
        )
    }
}
