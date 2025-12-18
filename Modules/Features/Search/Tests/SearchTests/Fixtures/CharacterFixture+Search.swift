//
//  CharacterFixture+Search.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for Search Tests

extension Character {

    /// Fixture padrão para testes do módulo Search
    /// Cria um Character válido com todos os campos básicos preenchidos
    static func searchFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        deck: String? = "A superhero from New York",
        comicsCount: Int = 100,
        dateLastUpdated: String = "2024-01-15 12:00:00",
        hasImage: Bool = true
    ) -> Character {
        let image = hasImage ? ComicVineImage.searchFixture() : ComicVineImage()

        return Character(
            id: id,
            name: name,
            description: description,
            deck: deck,
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: comicsCount,
            realName: nil,
            birth: nil,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: dateLastUpdated,
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

    /// Fixture mínima para testes básicos
    static func minimalSearchFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para vilão (para testes de filtro)
    static func villainSearchFixture(
        id: Int = 1,
        name: String = "Doctor Doom",
        comicsCount: Int = 200
    ) -> Character {
        searchFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para herói (para testes de filtro)
    static func heroSearchFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        comicsCount: Int = 500
    ) -> Character {
        searchFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para time (para testes de filtro)
    static func teamSearchFixture(
        id: Int = 1,
        name: String = "Avengers",
        comicsCount: Int = 1000
    ) -> Character {
        searchFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para testes de popularidade (ordenação)
    static func popularitySearchFixture(
        id: Int,
        name: String,
        comicsCount: Int
    ) -> Character {
        searchFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para testes de data recente (ordenação)
    static func recentSearchFixture(
        id: Int,
        name: String,
        dateLastUpdated: String
    ) -> Character {
        searchFixture(id: id, name: name, dateLastUpdated: dateLastUpdated)
    }
}

// MARK: - Character Array Fixtures

extension Array where Element == Character {

    /// Cria uma coleção de characters para testes de busca
    static func searchFixtures(count: Int) -> [Character] {
        (1...count).map { index in
            Character.searchFixture(
                id: index,
                name: "Hero \(index)",
                comicsCount: index * 10
            )
        }
    }

    /// Cria uma coleção de heróis para testes de filtro
    static func heroSearchFixtures() -> [Character] {
        [
            Character.heroSearchFixture(id: 1, name: "Spider-Man", comicsCount: 500),
            Character.heroSearchFixture(id: 2, name: "Batman", comicsCount: 600),
            Character.heroSearchFixture(id: 3, name: "Superman", comicsCount: 700),
            Character.heroSearchFixture(id: 4, name: "Wonder Woman", comicsCount: 400)
        ]
    }

    /// Cria uma coleção de vilões para testes de filtro
    static func villainSearchFixtures() -> [Character] {
        [
            Character.villainSearchFixture(id: 10, name: "Doctor Doom", comicsCount: 200),
            Character.villainSearchFixture(id: 11, name: "Magneto", comicsCount: 300),
            Character.villainSearchFixture(id: 12, name: "Thanos", comicsCount: 150),
            Character.villainSearchFixture(id: 13, name: "Loki", comicsCount: 250),
            Character.villainSearchFixture(id: 14, name: "Venom", comicsCount: 180),
            Character.villainSearchFixture(id: 15, name: "Green Goblin", comicsCount: 220),
            Character.villainSearchFixture(id: 16, name: "Doctor Octopus", comicsCount: 190)
        ]
    }

    /// Cria uma coleção de times para testes de filtro
    static func teamSearchFixtures() -> [Character] {
        [
            Character.teamSearchFixture(id: 20, name: "Avengers", comicsCount: 1000),
            Character.teamSearchFixture(id: 21, name: "X-Men", comicsCount: 900),
            Character.teamSearchFixture(id: 22, name: "Fantastic Four", comicsCount: 600),
            Character.teamSearchFixture(id: 23, name: "Guardians of the Galaxy", comicsCount: 300),
            Character.teamSearchFixture(id: 24, name: "Defenders", comicsCount: 250)
        ]
    }

    /// Cria uma coleção mista para testes de filtro
    static func mixedSearchFixtures() -> [Character] {
        heroSearchFixtures() + villainSearchFixtures() + teamSearchFixtures()
    }

    /// Cria uma coleção ordenada por popularidade para testes de ordenação
    static func popularityOrderedSearchFixtures() -> [Character] {
        [
            Character.popularitySearchFixture(id: 1, name: "Most Popular", comicsCount: 1000),
            Character.popularitySearchFixture(id: 2, name: "Very Popular", comicsCount: 750),
            Character.popularitySearchFixture(id: 3, name: "Popular", comicsCount: 500),
            Character.popularitySearchFixture(id: 4, name: "Somewhat Popular", comicsCount: 250),
            Character.popularitySearchFixture(id: 5, name: "Least Popular", comicsCount: 100)
        ]
    }

    /// Cria uma coleção ordenada por data para testes de ordenação
    static func recentOrderedSearchFixtures() -> [Character] {
        [
            Character.recentSearchFixture(id: 1, name: "Most Recent", dateLastUpdated: "2024-12-15 12:00:00"),
            Character.recentSearchFixture(id: 2, name: "Recent", dateLastUpdated: "2024-11-15 12:00:00"),
            Character.recentSearchFixture(id: 3, name: "Older", dateLastUpdated: "2024-06-15 12:00:00"),
            Character.recentSearchFixture(id: 4, name: "Old", dateLastUpdated: "2024-01-15 12:00:00"),
            Character.recentSearchFixture(id: 5, name: "Oldest", dateLastUpdated: "2023-06-15 12:00:00")
        ]
    }

    /// Cria uma coleção ordenada por nome para testes de ordenação
    static func nameOrderedSearchFixtures() -> [Character] {
        [
            Character.searchFixture(id: 1, name: "Alpha"),
            Character.searchFixture(id: 2, name: "Beta"),
            Character.searchFixture(id: 3, name: "Charlie"),
            Character.searchFixture(id: 4, name: "Delta"),
            Character.searchFixture(id: 5, name: "Echo")
        ]
    }

    /// Cria uma coleção com nomes variados para testes de busca
    static func searchTestNameFixtures() -> [Character] {
        [
            Character.searchFixture(id: 1, name: "Spider-Man"),
            Character.searchFixture(id: 2, name: "Spider-Woman"),
            Character.searchFixture(id: 3, name: "Spider-Gwen"),
            Character.searchFixture(id: 4, name: "Batman"),
            Character.searchFixture(id: 5, name: "Batgirl"),
            Character.searchFixture(id: 6, name: "Superman"),
            Character.searchFixture(id: 7, name: "Supergirl"),
            Character.searchFixture(id: 8, name: "Wonder Woman"),
            Character.searchFixture(id: 9, name: "Aquaman"),
            Character.searchFixture(id: 10, name: "Flash")
        ]
    }
}

// MARK: - ComicVineImage Fixture for Search Tests

extension ComicVineImage {

    /// Fixture padrão para testes do módulo Search
    static func searchFixture(
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
    static func emptySearchFixture() -> ComicVineImage {
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

// MARK: - Fixture Validation Tests

#if DEBUG
import Testing

@Suite("Search CharacterFixture Validation Tests")
struct SearchCharacterFixtureValidationTests {

    @Test("Character searchFixture should create valid character")
    func testCharacterSearchFixture() {
        // Act
        let character = Character.searchFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character searchFixture should allow custom values")
    func testCharacterSearchFixtureCustom() {
        // Act
        let character = Character.searchFixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 500,
            dateLastUpdated: "2024-12-01 10:00:00"
        )

        // Assert
        #expect(character.id == 42)
        #expect(character.name == "Batman")
        #expect(character.description == "The Dark Knight")
        #expect(character.countOfIssueAppearances == 500)
        #expect(character.dateLastUpdated == "2024-12-01 10:00:00")
    }

    @Test("Character minimalSearchFixture should work correctly")
    func testMinimalSearchFixture() {
        // Act
        let character = Character.minimalSearchFixture(id: 99, name: "Minimal Hero")

        // Assert
        #expect(character.id == 99)
        #expect(character.name == "Minimal Hero")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character villainSearchFixture should create villain")
    func testVillainSearchFixture() {
        // Act
        let villain = Character.villainSearchFixture(id: 10, name: "Doctor Doom", comicsCount: 200)

        // Assert
        #expect(villain.id == 10)
        #expect(villain.name == "Doctor Doom")
        #expect(villain.countOfIssueAppearances == 200)
    }

    @Test("Character teamSearchFixture should create team")
    func testTeamSearchFixture() {
        // Act
        let team = Character.teamSearchFixture(id: 20, name: "Avengers", comicsCount: 1000)

        // Assert
        #expect(team.id == 20)
        #expect(team.name == "Avengers")
        #expect(team.countOfIssueAppearances == 1000)
    }

    @Test("Character array searchFixtures should create multiple characters")
    func testArraySearchFixtures() {
        // Act
        let characters: [Character] = .searchFixtures(count: 5)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }

    @Test("Character mixedSearchFixtures should contain all types")
    func testMixedSearchFixtures() {
        // Act
        let characters: [Character] = .mixedSearchFixtures()

        // Assert
        #expect(characters.count == 16) // 4 heroes + 7 villains + 5 teams

        // Verifica se contém heróis
        #expect(characters.contains { $0.name == "Spider-Man" })

        // Verifica se contém vilões
        #expect(characters.contains { $0.name == "Doctor Doom" })
        #expect(characters.contains { $0.name == "Magneto" })

        // Verifica se contém times
        #expect(characters.contains { $0.name == "Avengers" })
        #expect(characters.contains { $0.name == "X-Men" })
    }

    @Test("Character popularityOrderedSearchFixtures should be ordered by comics count")
    func testPopularityOrderedFixtures() {
        // Act
        let characters: [Character] = .popularityOrderedSearchFixtures()

        // Assert
        #expect(characters.count == 5)
        #expect(characters[0].countOfIssueAppearances == 1000)
        #expect(characters[1].countOfIssueAppearances == 750)
        #expect(characters[4].countOfIssueAppearances == 100)
    }

    @Test("Character recentOrderedSearchFixtures should be ordered by date")
    func testRecentOrderedFixtures() {
        // Act
        let characters: [Character] = .recentOrderedSearchFixtures()

        // Assert
        #expect(characters.count == 5)
        #expect(characters[0].dateLastUpdated > characters[1].dateLastUpdated)
        #expect(characters[1].dateLastUpdated > characters[2].dateLastUpdated)
    }

    @Test("Character nameOrderedSearchFixtures should be alphabetically ordered")
    func testNameOrderedFixtures() {
        // Act
        let characters: [Character] = .nameOrderedSearchFixtures()

        // Assert
        #expect(characters.count == 5)
        #expect(characters[0].name == "Alpha")
        #expect(characters[1].name == "Beta")
        #expect(characters[4].name == "Echo")
    }

    @Test("ComicVineImage searchFixture should have valid URLs")
    func testComicVineImageSearchFixture() {
        // Act
        let image = ComicVineImage.searchFixture()

        // Assert
        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage emptySearchFixture should have nil URLs")
    func testComicVineImageEmptySearchFixture() {
        // Act
        let image = ComicVineImage.emptySearchFixture()

        // Assert
        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.originalUrl == nil)
    }
}
#endif
