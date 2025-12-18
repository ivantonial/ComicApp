//
//  CharacterFixture+CharacterDetail.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for CharacterDetail Tests

extension Character {
    /// Fixture completa para testes do módulo CharacterDetail
    /// Cria um Character válido com todos os campos preenchidos
    static func detailFixture(
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
        let image = ComicVineImage.detailFixture()

        let firstAppearedInIssue: IssueSummary? = includeRelations ? IssueSummary.detailFixture() : nil

        let origin: OriginSummary? = includeRelations ? OriginSummary(id: 4, name: "Human") : nil
        let publisher: PublisherSummary? = includeRelations ? PublisherSummary(id: 31, name: "Marvel") : nil

        let characterEnemies: [CharacterReference]? = includeRelations ? [
            CharacterReference.detailFixture(id: 2, name: "Green Goblin"),
            CharacterReference.detailFixture(id: 3, name: "Doctor Octopus")
        ] : nil

        let characterFriends: [CharacterReference]? = includeRelations ? [
            CharacterReference.detailFixture(id: 4, name: "Mary Jane Watson"),
            CharacterReference.detailFixture(id: 5, name: "Harry Osborn")
        ] : nil

        let creators: [CreatorReference]? = includeRelations ? [
            CreatorReference.detailFixture(id: 1, name: "Stan Lee"),
            CreatorReference.detailFixture(id: 2, name: "Steve Ditko")
        ] : nil

        let issueCredits: [IssueCredit]? = includeRelations ? [
            IssueCredit.detailFixture(id: 100, name: "Amazing Fantasy #15"),
            IssueCredit.detailFixture(id: 101, name: "Amazing Spider-Man #1"),
            IssueCredit.detailFixture(id: 102, name: "Amazing Spider-Man #2"),
            IssueCredit.detailFixture(id: 103, name: "Amazing Spider-Man #3"),
            IssueCredit.detailFixture(id: 104, name: "Amazing Spider-Man #4"),
            IssueCredit.detailFixture(id: 105, name: "Amazing Spider-Man #5")
        ] : nil

        let powers: [PowerReference]? = includeRelations ? [
            PowerReference.detailFixture(id: 1, name: "Super Strength"),
            PowerReference.detailFixture(id: 2, name: "Wall Crawling"),
            PowerReference.detailFixture(id: 3, name: "Spider-Sense")
        ] : nil

        let teams: [TeamReference]? = includeRelations ? [
            TeamReference.detailFixture(id: 1, name: "Avengers"),
            TeamReference.detailFixture(id: 2, name: "Fantastic Four")
        ] : nil

        let volumeCredits: [VolumeCredit]? = includeRelations ? [
            VolumeCredit.detailFixture(id: 1, name: "Amazing Spider-Man"),
            VolumeCredit.detailFixture(id: 2, name: "Spectacular Spider-Man"),
            VolumeCredit.detailFixture(id: 3, name: "Web of Spider-Man"),
            VolumeCredit.detailFixture(id: 4, name: "Spider-Man"),
            VolumeCredit.detailFixture(id: 5, name: "Ultimate Spider-Man"),
            VolumeCredit.detailFixture(id: 6, name: "Peter Parker: Spider-Man")
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
    static func minimalDetailFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para testes de estatísticas com valores específicos
    static func statsFixture(
        comicsCount: Int = 50,
        friendsCount: Int = 3,
        powersCount: Int = 5,
        enemiesCount: Int = 2
    ) -> Character {
        let image = ComicVineImage.detailFixture()

        // CORREÇÃO: Usar Array com índices seguros para evitar Range inválido
        let friends: [CharacterReference]? = friendsCount > 0
            ? (1...friendsCount).map { index in
                CharacterReference.detailFixture(id: 100 + index, name: "Friend \(index)")
            }
            : nil

        let powers: [PowerReference]? = powersCount > 0
            ? (1...powersCount).map { index in
                PowerReference.detailFixture(id: 200 + index, name: "Power \(index)")
            }
            : nil

        let enemies: [CharacterReference]? = enemiesCount > 0
            ? (1...enemiesCount).map { index in
                CharacterReference.detailFixture(id: 300 + index, name: "Enemy \(index)")
            }
            : nil

        return Character(
            id: 1,
            name: "Stats Hero",
            description: "A hero for stats testing",
            deck: "Stats deck",
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-1/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-1/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: comicsCount,
            realName: nil,
            birth: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-01 00:00:00",
            gender: nil,
            origin: nil,
            publisher: nil,
            characterEnemies: enemies,
            characterFriends: friends,
            creators: nil,
            issueCredits: nil,
            powers: powers,
            teams: nil,
            volumeCredits: nil
        )
    }

    /// Fixture para testes de compartilhamento
    static func shareFixture(
        name: String = "Shareable Hero",
        siteDetailUrl: String = "https://comicvine.gamespot.com/shareable-hero/4005-1/",
        hasImage: Bool = true
    ) -> Character {
        let image = hasImage ? ComicVineImage.detailFixture() : ComicVineImage()

        return Character(
            id: 1,
            name: name,
            description: "A shareable hero",
            deck: nil,
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-1/",
            siteDetailUrl: siteDetailUrl,
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

// MARK: - ComicVineImage Fixture for CharacterDetail Tests

extension ComicVineImage {
    /// Fixture completa para testes do módulo CharacterDetail
    static func detailFixture(
        iconUrl: String? = "https://comicvine.gamespot.com/a/uploads/icon/icon.jpg",
        mediumUrl: String? = "https://comicvine.gamespot.com/a/uploads/medium/medium.jpg",
        screenUrl: String? = "https://comicvine.gamespot.com/a/uploads/screen/screen.jpg",
        screenLargeUrl: String? = "https://comicvine.gamespot.com/a/uploads/screen_large/screen_large.jpg",
        smallUrl: String? = "https://comicvine.gamespot.com/a/uploads/small/small.jpg",
        superUrl: String? = "https://comicvine.gamespot.com/a/uploads/super/super.jpg",
        thumbUrl: String? = "https://comicvine.gamespot.com/a/uploads/thumb/thumb.jpg",
        tinyUrl: String? = "https://comicvine.gamespot.com/a/uploads/tiny/tiny.jpg",
        originalUrl: String? = "https://comicvine.gamespot.com/a/uploads/original/original.jpg"
    ) -> ComicVineImage {
        ComicVineImage(
            iconUrl: iconUrl,
            mediumUrl: mediumUrl,
            screenUrl: screenUrl,
            screenLargeUrl: screenLargeUrl,
            smallUrl: smallUrl,
            superUrl: superUrl,
            thumbUrl: thumbUrl,
            tinyUrl: tinyUrl,
            originalUrl: originalUrl
        )
    }

    /// Fixture vazia para testes de fallback
    static func emptyDetailFixture() -> ComicVineImage {
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

// MARK: - IssueSummary Fixture

extension IssueSummary {
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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

// MARK: - CharacterReference Fixture

extension CharacterReference {
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
    /// Fixture para testes do CharacterDetail
    static func detailFixture(
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
