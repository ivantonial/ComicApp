//
//  CharacterFixture+Favorites.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

import ComicVineAPI
import Foundation

// MARK: - Character Fixture for Favorites Tests

extension Character {

    /// Fixture padrão para testes do módulo Favorites
    /// Cria um Character válido com todos os campos básicos preenchidos
    static func favoritesFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        deck: String? = "A superhero from New York",
        comicsCount: Int = 100,
        hasImage: Bool = true
    ) -> Character {
        let image = hasImage ? ComicVineImage.favoritesFixture() : ComicVineImage()

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
    static func minimalFavoritesFixture(id: Int = 1, name: String = "Hero") -> Character {
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

    /// Fixture para testes de ordenação por nome
    static func sortableByNameFixture(
        id: Int,
        name: String,
        comicsCount: Int = 50
    ) -> Character {
        favoritesFixture(id: id, name: name, comicsCount: comicsCount)
    }

    /// Fixture para testes de ordenação por quantidade de comics
    static func sortableByComicsFixture(
        id: Int,
        name: String = "Hero",
        comicsCount: Int
    ) -> Character {
        favoritesFixture(id: id, name: "\(name) \(id)", comicsCount: comicsCount)
    }

    /// Fixture para testes de busca com diferentes nomes
    static func searchableFavoritesFixture(
        id: Int,
        name: String,
        comicsCount: Int = 50
    ) -> Character {
        favoritesFixture(id: id, name: name, comicsCount: comicsCount)
    }
}

// MARK: - Character Array Fixtures for Favorites

extension Array where Element == Character {

    /// Cria uma coleção de characters para testes de favoritos
    static func favoritesFixtures(count: Int) -> [Character] {
        (1...count).map { index in
            Character.favoritesFixture(
                id: index,
                name: "Hero \(index)",
                comicsCount: index * 10
            )
        }
    }

    /// Cria uma coleção para testes de busca em favoritos com nomes variados
    static func favoritesSearchTestFixtures() -> [Character] {
        [
            Character.favoritesFixture(id: 1, name: "Spider-Man", comicsCount: 100),
            Character.favoritesFixture(id: 2, name: "Spider-Woman", comicsCount: 80),
            Character.favoritesFixture(id: 3, name: "Spider-Gwen", comicsCount: 60),
            Character.favoritesFixture(id: 4, name: "Batman", comicsCount: 200),
            Character.favoritesFixture(id: 5, name: "Batgirl", comicsCount: 90),
            Character.favoritesFixture(id: 6, name: "Superman", comicsCount: 250),
            Character.favoritesFixture(id: 7, name: "Supergirl", comicsCount: 70),
            Character.favoritesFixture(id: 8, name: "Wonder Woman", comicsCount: 180),
            Character.favoritesFixture(id: 9, name: "Aquaman", comicsCount: 120),
            Character.favoritesFixture(id: 10, name: "Flash", comicsCount: 150)
        ]
    }

    /// Cria uma coleção para testes de ordenação por nome
    static func favoritesSortByNameFixtures() -> [Character] {
        [
            Character.sortableByNameFixture(id: 1, name: "Zatanna"),
            Character.sortableByNameFixture(id: 2, name: "Alfred"),
            Character.sortableByNameFixture(id: 3, name: "Batman"),
            Character.sortableByNameFixture(id: 4, name: "Catwoman"),
            Character.sortableByNameFixture(id: 5, name: "Robin")
        ]
    }

    /// Cria uma coleção para testes de ordenação por quantidade de comics
    static func favoritesSortByComicsFixtures() -> [Character] {
        [
            Character.sortableByComicsFixture(id: 1, name: "Hero", comicsCount: 50),
            Character.sortableByComicsFixture(id: 2, name: "Hero", comicsCount: 200),
            Character.sortableByComicsFixture(id: 3, name: "Hero", comicsCount: 10),
            Character.sortableByComicsFixture(id: 4, name: "Hero", comicsCount: 150),
            Character.sortableByComicsFixture(id: 5, name: "Hero", comicsCount: 80)
        ]
    }

    /// Cria uma coleção com personagens duplicados para testes de deduplicação
    static func favoritesDuplicatesTestFixtures() -> [Character] {
        [
            Character.favoritesFixture(id: 1, name: "Spider-Man"),
            Character.favoritesFixture(id: 2, name: "Batman"),
            Character.favoritesFixture(id: 1, name: "Spider-Man"), // Duplicado
            Character.favoritesFixture(id: 3, name: "Superman"),
            Character.favoritesFixture(id: 2, name: "Batman") // Duplicado
        ]
    }

    /// Cria coleção para testar filtro de busca case-insensitive
    static func favoritesCaseInsensitiveSearchFixtures() -> [Character] {
        [
            Character.favoritesFixture(id: 1, name: "BATMAN"),
            Character.favoritesFixture(id: 2, name: "batman"),
            Character.favoritesFixture(id: 3, name: "Batman"),
            Character.favoritesFixture(id: 4, name: "BaTmAn"),
            Character.favoritesFixture(id: 5, name: "Superman")
        ]
    }
}

// MARK: - ComicVineImage Fixture for Favorites Tests

extension ComicVineImage {

    /// Fixture padrão para testes do módulo Favorites
    static func favoritesFixture(
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
    static func emptyFavoritesFixture() -> ComicVineImage {
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

@Suite("Favorites Fixture Validation Tests")
struct FavoritesFixtureValidationTests {

    @Test("Character favoritesFixture should create valid character")
    func testCharacterFavoritesFixture() {
        // Act
        let character = Character.favoritesFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character favoritesFixture should allow custom values")
    func testCharacterFavoritesFixtureCustom() {
        // Act
        let character = Character.favoritesFixture(
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

    @Test("Character minimalFavoritesFixture should work correctly")
    func testMinimalFavoritesFixture() {
        // Act
        let character = Character.minimalFavoritesFixture(id: 99, name: "Minimal Hero")

        // Assert
        #expect(character.id == 99)
        #expect(character.name == "Minimal Hero")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character array favoritesFixtures should create multiple characters")
    func testArrayFavoritesFixtures() {
        // Act
        let characters: [Character] = .favoritesFixtures(count: 5)

        // Assert
        #expect(characters.count == 5)
        for (index, character) in characters.enumerated() {
            #expect(character.id == index + 1)
            #expect(character.name == "Hero \(index + 1)")
        }
    }

    @Test("Character favoritesSearchTestFixtures should contain expected heroes")
    func testFavoritesSearchTestFixtures() {
        // Act
        let characters: [Character] = .favoritesSearchTestFixtures()

        // Assert
        #expect(characters.count == 10)
        #expect(characters.contains { $0.name == "Spider-Man" })
        #expect(characters.contains { $0.name == "Batman" })
        #expect(characters.contains { $0.name == "Wonder Woman" })
    }

    @Test("Character favoritesSortByNameFixtures should be sortable")
    func testFavoritesSortByNameFixtures() {
        // Act
        let characters: [Character] = .favoritesSortByNameFixtures()
        let sorted = characters.sorted { $0.name < $1.name }

        // Assert
        #expect(characters.count == 5)
        #expect(sorted.first?.name == "Alfred")
        #expect(sorted.last?.name == "Zatanna")
    }

    @Test("Character favoritesSortByComicsFixtures should be sortable by comics count")
    func testFavoritesSortByComicsFixtures() {
        // Act
        let characters: [Character] = .favoritesSortByComicsFixtures()
        let sorted = characters.sorted { $0.countOfIssueAppearances > $1.countOfIssueAppearances }

        // Assert
        #expect(characters.count == 5)
        #expect(sorted.first?.countOfIssueAppearances == 200)
        #expect(sorted.last?.countOfIssueAppearances == 10)
    }

    @Test("Character favoritesDuplicatesTestFixtures should contain duplicates")
    func testFavoritesDuplicatesTestFixtures() {
        // Act
        let characters: [Character] = .favoritesDuplicatesTestFixtures()

        // Assert
        #expect(characters.count == 5)

        let uniqueIds = Set(characters.map { $0.id })
        #expect(uniqueIds.count == 3) // Apenas 3 IDs únicos
    }

    @Test("ComicVineImage favoritesFixture should have valid URLs")
    func testComicVineImageFavoritesFixture() {
        // Act
        let image = ComicVineImage.favoritesFixture()

        // Assert
        #expect(image.iconUrl != nil)
        #expect(image.mediumUrl != nil)
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineImage emptyFavoritesFixture should have nil URLs")
    func testComicVineImageEmptyFavoritesFixture() {
        // Act
        let image = ComicVineImage.emptyFavoritesFixture()

        // Assert
        #expect(image.iconUrl == nil)
        #expect(image.mediumUrl == nil)
        #expect(image.originalUrl == nil)
    }
}
#endif
