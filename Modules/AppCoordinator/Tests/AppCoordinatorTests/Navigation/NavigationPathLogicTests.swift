//
//  NavigationPathLogicTests.swift
//  AppCoordinator
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import AppCoordinator
import ComicVineAPI
import SwiftUI
import Testing

// MARK: - Navigation Path Logic Tests

@Suite("Navigation Path Logic Tests")
struct NavigationPathLogicTests {

    // MARK: - Append Tests

    @Test("NavigationPath should support appending CharacterDestination")
    @MainActor
    func testNavigationPathAppend() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let destination = CharacterDestination.detail(character)

        // Act
        path.append(destination)

        // Assert
        #expect(path.count == 1)
    }

    @Test("Multiple destinations can be appended in sequence")
    @MainActor
    func testMultipleDestinationsAppend() {
        // Arrange
        var path = NavigationPath()
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        // Act
        path.append(CharacterDestination.detail(character1))
        path.append(CharacterDestination.comics(character1))
        path.append(CharacterDestination.detail(character2))

        // Assert
        #expect(path.count == 3)
    }

    // MARK: - Remove Tests

    @Test("NavigationPath should support removing last element")
    @MainActor
    func testNavigationPathRemoveLast() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))
        path.append(CharacterDestination.comics(character))

        // Act
        path.removeLast()

        // Assert
        #expect(path.count == 1)
    }

    @Test("NavigationPath should support clearing all elements")
    @MainActor
    func testNavigationPathClear() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))
        path.append(CharacterDestination.comics(character))

        // Act
        path.removeLast(path.count)

        // Assert
        #expect(path.isEmpty)
    }

    @Test("NavigationPath should support removing multiple elements")
    @MainActor
    func testRemoveMultipleElements() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))
        path.append(CharacterDestination.comics(character))
        path.append(CharacterDestination.detail(character))

        // Act
        path.removeLast(2)

        // Assert
        #expect(path.count == 1)
    }

    // MARK: - Empty State Tests

    @Test("NavigationPath isEmpty should return true for empty path")
    @MainActor
    func testNavigationPathIsEmpty() {
        // Arrange
        let path = NavigationPath()

        // Assert
        #expect(path.isEmpty)
        #expect(path.count == 0)
    }

    @Test("NavigationPath isEmpty should return false for non-empty path")
    @MainActor
    func testNavigationPathIsNotEmpty() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act
        path.append(CharacterDestination.detail(character))

        // Assert
        #expect(!path.isEmpty)
        #expect(path.count == 1)
    }

    // MARK: - Navigation Flow Tests

    @Test("Navigation flow: detail -> comics -> back")
    @MainActor
    func testNavigationFlowDetailComicsBack() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act - Navigate to detail
        path.append(CharacterDestination.detail(character))
        #expect(path.count == 1)

        // Act - Navigate to comics
        path.append(CharacterDestination.comics(character))
        #expect(path.count == 2)

        // Act - Go back
        path.removeLast()
        #expect(path.count == 1)

        // Act - Go to root
        path.removeLast(path.count)
        #expect(path.isEmpty)
    }

    @Test("Navigation with different characters")
    @MainActor
    func testNavigationDifferentCharacters() {
        // Arrange
        var path = NavigationPath()
        let spiderman = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let ironman = Character.coordinatorFixture(id: 2, name: "Iron Man")
        let thor = Character.coordinatorFixture(id: 3, name: "Thor")

        // Act
        path.append(CharacterDestination.detail(spiderman))
        path.append(CharacterDestination.detail(ironman))
        path.append(CharacterDestination.detail(thor))

        // Assert
        #expect(path.count == 3)
    }
}

// MARK: - Navigation Path Codable Tests
// NOTA: O comportamento de NavigationPath.codable varia:
// - Path VAZIO: retorna CodableRepresentation válido (não nil)
// - Path com elementos NÃO REGISTRADOS: retorna nil (tipos não registrados via .navigationDestination)
// Este comportamento é específico do framework SwiftUI.

@Suite("Navigation Path Codable Tests")
struct NavigationPathCodableTests {

    @Test("NavigationPath with unregistered types returns nil codable (expected behavior)")
    @MainActor
    func testNavigationPathWithUnregisteredTypesReturnsNil() {
        // Arrange
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))

        // Act
        let codable = path.codable

        // Assert
        // NavigationPath.codable retorna nil quando contém tipos não registrados
        // via .navigationDestination(for:) em uma hierarquia SwiftUI.
        // Em testes unitários, os tipos nunca são registrados, então sempre retorna nil.
        #expect(codable == nil, "NavigationPath.codable returns nil for unregistered types")
    }

    @Test("Empty NavigationPath returns valid CodableRepresentation")
    @MainActor
    func testEmptyNavigationPathCodable() {
        // Arrange
        let path = NavigationPath()

        // Act
        let codable = path.codable

        // Assert
        // Um NavigationPath VAZIO sempre retorna um CodableRepresentation válido,
        // diferente de um path com elementos não registrados que retorna nil.
        #expect(codable != nil, "Empty NavigationPath should have valid CodableRepresentation")
    }

    @Test("Empty NavigationPath codable can be used to create new path")
    @MainActor
    func testEmptyNavigationPathCodableRoundTrip() {
        // Arrange
        let originalPath = NavigationPath()

        // Act
        guard let codable = originalPath.codable else {
            Issue.record("Empty path should have codable representation")
            return
        }
        let recreatedPath = NavigationPath(codable)

        // Assert
        #expect(recreatedPath.isEmpty)
        #expect(recreatedPath.count == 0)
    }
}

// MARK: - Character Fixture Validation Tests

@Suite("Character Fixture Validation Tests")
struct CharacterFixtureValidationTests {

    @Test("Fixture should create valid Character")
    func testFixtureCreatesValidCharacter() {
        // Act
        let character = Character.coordinatorFixture()

        // Assert
        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Fixture should allow custom values")
    func testFixtureWithCustomValues() {
        // Act
        let character = Character.coordinatorFixture(
            id: 999,
            name: "Custom Hero",
            description: "A custom description",
            comicsCount: 50
        )

        // Assert
        #expect(character.id == 999)
        #expect(character.name == "Custom Hero")
        #expect(character.description == "A custom description")
        #expect(character.countOfIssueAppearances == 50)
    }

    @Test("Fixture should create character with valid image")
    func testFixtureImageValid() {
        // Act
        let character = Character.coordinatorFixture()

        // Assert
        #expect(character.image.bestQualityUrl != nil)
        #expect(character.image.thumbnailUrl != nil)
        #expect(character.image.mediumQualityUrl != nil)
    }

    @Test("Fixture should create character with publisher")
    func testFixturePublisher() {
        // Act
        let character = Character.coordinatorFixture()

        // Assert
        #expect(character.publisher?.name == "Marvel")
        #expect(character.publisher?.id == 31)
    }

    @Test("Fixture should create character with powers")
    func testFixturePowers() {
        // Act
        let character = Character.coordinatorFixture()

        // Assert
        #expect(character.powers?.count == 2)
        #expect(character.powers?[0].name == "Super Strength")
        #expect(character.powers?[1].name == "Wall Crawling")
    }

    @Test("Fixture should create character with enemies and friends")
    func testFixtureEnemiesAndFriends() {
        // Act
        let character = Character.coordinatorFixture()

        // Assert
        #expect(character.characterEnemies?.count == 1)
        #expect(character.characterEnemies?[0].name == "Green Goblin")
        #expect(character.characterFriends?.count == 1)
        #expect(character.characterFriends?[0].name == "Mary Jane Watson")
    }
}

// MARK: - ComicVineImage Tests

@Suite("ComicVineImage Tests")
struct ComicVineImageTests {

    @Test("ComicVineImage should return best quality URL")
    func testBestQualityUrl() {
        // Arrange
        let image = ComicVineImage(
            iconUrl: "https://example.com/icon.jpg",
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: "https://example.com/super.jpg",
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: "https://example.com/original.jpg"
        )

        // Assert
        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/original.jpg")
    }

    @Test("ComicVineImage should fallback when original not available")
    func testBestQualityUrlFallback() {
        // Arrange
        let image = ComicVineImage(
            iconUrl: "https://example.com/icon.jpg",
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: "https://example.com/super.jpg",
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )

        // Assert
        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/super.jpg")
    }

    @Test("ComicVineImage with all nil should return nil URLs")
    func testAllNilUrls() {
        // Arrange
        let image = ComicVineImage(
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

        // Assert
        #expect(image.bestQualityUrl == nil)
        #expect(image.mediumQualityUrl == nil)
        #expect(image.thumbnailUrl == nil)
    }

    @Test("ComicVineImage thumbnailUrl should prefer thumbUrl")
    func testThumbnailUrlPreference() {
        // Arrange
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: "https://example.com/thumb.jpg",
            tinyUrl: nil,
            originalUrl: nil
        )

        // Assert
        #expect(image.thumbnailUrl?.absoluteString == "https://example.com/thumb.jpg")
    }
}

// MARK: - Supporting Structures Tests

@Suite("Supporting Structures Tests")
struct SupportingStructuresTests {

    @Test("OriginSummary should store values correctly")
    func testOriginSummary() {
        // Act
        let origin = OriginSummary(id: 4, name: "Human")

        // Assert
        #expect(origin.id == 4)
        #expect(origin.name == "Human")
    }

    @Test("PublisherSummary should store values correctly")
    func testPublisherSummary() {
        // Act
        let publisher = PublisherSummary(id: 31, name: "Marvel")

        // Assert
        #expect(publisher.id == 31)
        #expect(publisher.name == "Marvel")
    }
}
