//
//  CharacterFixture+CharacterList.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for CharacterList Tests

extension Character {

    /// Fixture padrão para testes do módulo CharacterList
    /// Cria um Character válido com todos os campos básicos preenchidos
    static func listFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        deck: String? = "A superhero from New York",
        comicsCount: Int = 100,
        hasImage: Bool = true
    ) -> Character {
        let image = hasImage ? ComicVineImage.listFixture() : ComicVineImage()

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
            issueCredits: nil,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }

    /// Fixture mínima para testes básicos
    static func minimalListFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para testes de busca com diferentes nomes
    static func searchFixture(
        id: Int,
        name: String,
        comicsCount: Int = 50
    ) -> Character {
        listFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para testes de paginação
    static func paginationFixture(index: Int) -> Character {
        listFixture(
            id: index,
            name: "Character \(index)",
            comicsCount: index * 10
        )
    }
}

// MARK: - Character Array Fixtures

extension Array where Element == Character {

    /// Cria uma coleção de characters para testes
    static func listFixtures(count: Int) -> [Character] {
        (1...count).map { index in
            Character.listFixture(
                id: index,
                name: "Hero \(index)",
                comicsCount: index * 10
            )
        }
    }

    /// Cria uma coleção para testes de busca com nomes variados
    static func searchTestFixtures() -> [Character] {
        [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Spider-Woman"),
            Character.listFixture(id: 3, name: "Spider-Gwen"),
            Character.listFixture(id: 4, name: "Batman"),
            Character.listFixture(id: 5, name: "Batgirl"),
            Character.listFixture(id: 6, name: "Superman"),
            Character.listFixture(id: 7, name: "Supergirl"),
            Character.listFixture(id: 8, name: "Wonder Woman"),
            Character.listFixture(id: 9, name: "Aquaman"),
            Character.listFixture(id: 10, name: "Flash")
        ]
    }

    /// Cria uma coleção com personagens duplicados para testes de deduplicação
    static func duplicatesTestFixtures() -> [Character] {
        [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Batman"),
            Character.listFixture(id: 1, name: "Spider-Man"), // Duplicado
            Character.listFixture(id: 3, name: "Superman"),
            Character.listFixture(id: 2, name: "Batman") // Duplicado
        ]
    }

    /// Cria uma página de resultados para testes de paginação
    static func pageFixtures(page: Int, pageSize: Int = 20) -> [Character] {
        let startIndex = (page * pageSize) + 1
        let endIndex = startIndex + pageSize - 1

        return (startIndex...endIndex).map { index in
            Character.paginationFixture(index: index)
        }
    }
}

// MARK: - ComicVineImage Fixture for CharacterList Tests

extension ComicVineImage {

    /// Fixture padrão para testes do módulo CharacterList
    static func listFixture(
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
    static func emptyListFixture() -> ComicVineImage {
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

@Suite("CharacterList Fixture Validation Tests")
struct CharacterListFixtureValidationTests {

    @Test("Character listFixture should create valid character")
    func testCharacterListFixture() {
        // Act
        let character = Character.listFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character listFixture should allow custom values")
    func testCharacterListFixtureCustom() {
        // Act
        let character = Character.listFixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 500
        )

        // Assert
        #expect(character.id == 42)
        #expect(character.name == "Batman")
        #expect(character.description == "The Dark Knight")
        #expect(character.countOfIssueAppearances == 500)
    }

    @Test("Character minimalListFixture should work correctly")
    func testMinimalListFixture() {
        // Act
        let character = Character.minimalListFixture(id: 99, name: "Minimal Hero")

        // Assert
        #expect(character.id == 99)
        #expect(character.name == "Minimal Hero")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character array listFixtures should create multiple characters")
    func testArrayListFixtures() {
        // Act
        let characters: [Character] = .listFixtures(count: 5)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }

    @Test("Character searchTestFixtures should contain expected heroes")
    func testSearchTestFixtures() {
        // Act
        let characters: [Character] = .searchTestFixtures()

        // Assert
        #expect(characters.count == 10)
        #expect(characters.contains { $0.name == "Spider-Man" })
        #expect(characters.contains { $0.name == "Batman" })
        #expect(characters.contains { $0.name == "Wonder Woman" })
    }

    @Test("Character duplicatesTestFixtures should contain duplicates")
    func testDuplicatesTestFixtures() {
        // Act
        let characters: [Character] = .duplicatesTestFixtures()

        // Assert
        #expect(characters.count == 5)

        let uniqueIds = Set(characters.map { $0.id })
        #expect(uniqueIds.count == 3) // Apenas 3 IDs únicos
    }

    @Test("Character pageFixtures should create correct page")
    func testPageFixtures() {
        // Act
        let page0: [Character] = .pageFixtures(page: 0, pageSize: 10)
        let page1: [Character] = .pageFixtures(page: 1, pageSize: 10)

        // Assert
        #expect(page0.count == 10)
        #expect(page0.first?.id == 1)
        #expect(page0.last?.id == 10)

        #expect(page1.count == 10)
        #expect(page1.first?.id == 11)
        #expect(page1.last?.id == 20)
    }

    @Test("ComicVineImage listFixture should have valid URLs")
    func testComicVineImageListFixture() {
        // Act
        let image = ComicVineImage.listFixture()

        // Assert
        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage emptyListFixture should have nil URLs")
    func testComicVineImageEmptyListFixture() {
        // Act
        let image = ComicVineImage.emptyListFixture()

        // Assert
        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.originalUrl == nil)
    }
}
#endif
