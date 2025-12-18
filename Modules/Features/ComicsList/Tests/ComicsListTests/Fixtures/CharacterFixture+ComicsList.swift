//
//  CharacterFixture+ComicsList.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for ComicsList Tests

extension Character {

    /// Fixture padrão para testes do módulo ComicsList
    /// Cria um Character válido com todos os campos básicos preenchidos
    static func comicsListFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        deck: String? = "A superhero from New York",
        comicsCount: Int = 100,
        hasImage: Bool = true,
        issueCredits: [IssueCredit]? = nil
    ) -> Character {
        let image = hasImage ? ComicVineImage.comicsListFixture() : ComicVineImage()

        // Se issueCredits não foi fornecido, criar um padrão com alguns IDs
        let credits = issueCredits ?? defaultIssueCredits()

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
            dateLastUpdated: "2024-01-01 00:00:00",
            gender: nil,
            origin: nil,
            publisher: nil,
            characterEnemies: nil,
            characterFriends: nil,
            creators: nil,
            issueCredits: credits,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }

    /// Fixture mínima para testes básicos
    static func minimalComicsListFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para testes sem issueCredits (fallback behavior)
    static func comicsListFixtureWithoutIssueCredits(
        id: Int = 1,
        name: String = "Character Without Credits",
        comicsCount: Int = 50
    ) -> Character {
        let image = ComicVineImage.comicsListFixture()

        return Character(
            id: id,
            name: name,
            description: "A character without issue credits",
            deck: nil,
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: comicsCount,
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

    /// Fixture para testes de paginação com muitos issueCredits
    static func comicsListFixtureWithManyIssues(
        id: Int = 1,
        name: String = "Popular Hero",
        issueCount: Int = 100
    ) -> Character {
        let image = ComicVineImage.comicsListFixture()
        let credits = (1...issueCount).map { index in
            IssueCredit(
                id: 1000 + index,
                name: "Issue #\(index)",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(1000 + index)/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(1000 + index)/"
            )
        }

        return Character(
            id: id,
            name: name,
            description: "A popular hero with many issues",
            deck: nil,
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: issueCount,
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
            issueCredits: credits,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }

    /// Cria issueCredits padrão para testes
    private static func defaultIssueCredits() -> [IssueCredit] {
        (1...10).map { index in
            IssueCredit(
                id: 100 + index,
                name: "Amazing Spider-Man #\(index)",
                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(100 + index)/",
                siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(100 + index)/"
            )
        }
    }
}

// MARK: - ComicVineImage Fixture for ComicsList Tests

extension ComicVineImage {

    /// Fixture padrão para testes do módulo ComicsList
    static func comicsListFixture(
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
    static func emptyComicsListFixture() -> ComicVineImage {
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

@Suite("ComicsList Character Fixture Validation Tests")
struct ComicsListCharacterFixtureValidationTests {

    @Test("Character comicsListFixture should create valid character")
    func testCharacterComicsListFixture() {
        // Act
        let character = Character.comicsListFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
        #expect(character.issueCredits != nil)
        #expect(character.issueCredits?.count == 10)
    }

    @Test("Character comicsListFixture should allow custom values")
    func testCharacterComicsListFixtureCustom() {
        // Arrange
        let customCredits = [
            IssueCredit(id: 1, name: "Issue 1", apiDetailUrl: nil, siteDetailUrl: nil),
            IssueCredit(id: 2, name: "Issue 2", apiDetailUrl: nil, siteDetailUrl: nil)
        ]

        // Act
        let character = Character.comicsListFixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 500,
            issueCredits: customCredits
        )

        // Assert
        #expect(character.id == 42)
        #expect(character.name == "Batman")
        #expect(character.description == "The Dark Knight")
        #expect(character.countOfIssueAppearances == 500)
        #expect(character.issueCredits?.count == 2)
    }

    @Test("Character minimalComicsListFixture should work correctly")
    func testMinimalComicsListFixture() {
        // Act
        let character = Character.minimalComicsListFixture(id: 99, name: "Minimal Hero")

        // Assert
        #expect(character.id == 99)
        #expect(character.name == "Minimal Hero")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
        #expect(character.issueCredits == nil)
    }

    @Test("Character comicsListFixtureWithoutIssueCredits should have nil issueCredits")
    func testComicsListFixtureWithoutIssueCredits() {
        // Act
        let character = Character.comicsListFixtureWithoutIssueCredits()

        // Assert
        #expect(character.issueCredits == nil)
        #expect(character.countOfIssueAppearances == 50)
    }

    @Test("Character comicsListFixtureWithManyIssues should create correct number of credits")
    func testComicsListFixtureWithManyIssues() {
        // Act
        let character = Character.comicsListFixtureWithManyIssues(issueCount: 50)

        // Assert
        #expect(character.issueCredits?.count == 50)
        #expect(character.countOfIssueAppearances == 50)
    }

    @Test("ComicVineImage comicsListFixture should have valid URLs")
    func testComicVineImageComicsListFixture() {
        // Act
        let image = ComicVineImage.comicsListFixture()

        // Assert
        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage emptyComicsListFixture should have nil URLs")
    func testComicVineImageEmptyComicsListFixture() {
        // Act
        let image = ComicVineImage.emptyComicsListFixture()

        // Assert
        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.originalUrl == nil)
    }
}
#endif
