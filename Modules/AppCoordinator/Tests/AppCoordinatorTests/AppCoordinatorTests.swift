//@testable import AppCoordinator
//import Testing
//
//@Test func example() async throws {
//    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//}
//@testable import AppCoordinator
//@testable import ComicVineAPI
//import SwiftUI
//import Testing
//import XCTest
//
//// MARK: - Fixtures
//
//extension Character {
//    /// Fixture para testes do AppCoordinator
//    /// Cria um Character válido para uso em testes
//    static func coordinatorFixture(
//        id: Int = 1,
//        name: String = "Spider-Man",
//        description: String? = "Friendly neighborhood Spider-Man",
//        comicsCount: Int = 100
//    ) -> Character {
//        let image = ComicVineImage(
//            iconUrl: "https://example.com/icon.jpg",
//            mediumUrl: "https://example.com/medium.jpg",
//            screenUrl: "https://example.com/screen.jpg",
//            screenLargeUrl: "https://example.com/screen_large.jpg",
//            smallUrl: "https://example.com/small.jpg",
//            superUrl: "https://example.com/super.jpg",
//            thumbUrl: "https://example.com/thumb.jpg",
//            tinyUrl: "https://example.com/tiny.jpg",
//            originalUrl: "https://example.com/original.jpg"
//        )
//
//        return Character(
//            id: id,
//            name: name,
//            description: description,
//            deck: "A superhero from New York",
//            aliases: "Spidey\nWeb-Slinger",
//            image: image,
//            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
//            siteDetailUrl: "https://comicvine.gamespot.com/spider-man/4005-\(id)/",
//            firstAppearedInIssue: IssueSummary(
//                id: 100,
//                name: "Amazing Fantasy #15",
//                apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-100/",
//                issueNumber: "15"
//            ),
//            countOfIssueAppearances: comicsCount,
//            realName: "Peter Parker",
//            birth: "1962-08-01",
//            dateAdded: "2008-06-06 11:27:46",
//            dateLastUpdated: "2024-01-15 10:30:00",
//            gender: 1,
//            origin: OriginSummary(id: 4, name: "Human"),
//            publisher: PublisherSummary(id: 31, name: "Marvel"),
//            characterEnemies: [
//                CharacterReference(
//                    id: 2,
//                    name: "Green Goblin",
//                    apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-2/",
//                    siteDetailUrl: "https://comicvine.gamespot.com/green-goblin/4005-2/"
//                )
//            ],
//            characterFriends: [
//                CharacterReference(
//                    id: 3,
//                    name: "Mary Jane Watson",
//                    apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-3/",
//                    siteDetailUrl: "https://comicvine.gamespot.com/mary-jane-watson/4005-3/"
//                )
//            ],
//            creators: nil,
//            issueCredits: nil,
//            powers: [
//                PowerReference(id: 1, name: "Super Strength", apiDetailUrl: nil),
//                PowerReference(id: 2, name: "Wall Crawling", apiDetailUrl: nil)
//            ],
//            teams: nil,
//            volumeCredits: nil
//        )
//    }
//}
//
//// MARK: - CharacterDestination Tests
//
//@Suite("CharacterDestination Tests")
//struct CharacterDestinationTests {
//
//    @Test("CharacterDestination.detail should be hashable")
//    func testDetailHashable() {
//        // Arrange
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//
//        // Act
//        let destination1 = CharacterDestination.detail(character)
//        let destination2 = CharacterDestination.detail(character)
//
//        // Assert
//        #expect(destination1 == destination2)
//        #expect(destination1.hashValue == destination2.hashValue)
//    }
//
//    @Test("CharacterDestination.comics should be hashable")
//    func testComicsHashable() {
//        // Arrange
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//
//        // Act
//        let destination1 = CharacterDestination.comics(character)
//        let destination2 = CharacterDestination.comics(character)
//
//        // Assert
//        #expect(destination1 == destination2)
//        #expect(destination1.hashValue == destination2.hashValue)
//    }
//
//    @Test("Different CharacterDestinations should not be equal")
//    func testDifferentDestinationsNotEqual() {
//        // Arrange
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//
//        // Act
//        let detailDestination = CharacterDestination.detail(character)
//        let comicsDestination = CharacterDestination.comics(character)
//
//        // Assert
//        #expect(detailDestination != comicsDestination)
//    }
//
//    @Test("CharacterDestination with different characters should not be equal")
//    func testDifferentCharactersNotEqual() {
//        // Arrange
//        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")
//
//        // Act
//        let destination1 = CharacterDestination.detail(character1)
//        let destination2 = CharacterDestination.detail(character2)
//
//        // Assert
//        #expect(destination1 != destination2)
//    }
//
//    @Test("CharacterDestination can be used in Set")
//    func testDestinationInSet() {
//        // Arrange
//        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")
//
//        // Act
//        var destinations: Set<CharacterDestination> = []
//        destinations.insert(.detail(character1))
//        destinations.insert(.detail(character2))
//        destinations.insert(.comics(character1))
//        destinations.insert(.detail(character1)) // Duplicata
//
//        // Assert
//        #expect(destinations.count == 3)
//    }
//}
//
//// MARK: - AppTab Tests
//
//@Suite("AppTab Tests")
//struct AppTabTests {
//
//    @Test("AppTab should have correct raw values")
//    func testRawValues() {
//        // Assert
//        #expect(AppTab.characters.rawValue == "Characters")
//        #expect(AppTab.search.rawValue == "Search")
//        #expect(AppTab.favorites.rawValue == "Favorites")
//        #expect(AppTab.settings.rawValue == "Settings")
//    }
//
//    @Test("AppTab should have correct icons")
//    func testIcons() {
//        // Assert
//        #expect(AppTab.characters.icon == "person.3.fill")
//        #expect(AppTab.search.icon == "magnifyingglass")
//        #expect(AppTab.favorites.icon == "star.fill")
//        #expect(AppTab.settings.icon == "gearshape.fill")
//    }
//
//    @Test("AppTab.allCases should contain all tabs")
//    func testAllCases() {
//        // Arrange
//        let allCases = AppTab.allCases
//
//        // Assert
//        #expect(allCases.count == 4)
//        #expect(allCases.contains(.characters))
//        #expect(allCases.contains(.search))
//        #expect(allCases.contains(.favorites))
//        #expect(allCases.contains(.settings))
//    }
//}
//
//// MARK: - AppCoordinator Navigation Tests (XCTest for @MainActor)
//
//class AppCoordinatorNavigationTests: XCTestCase {
//
//    // MARK: - Properties
//
//    var coordinator: AppCoordinator!
//
//    // MARK: - Setup & Teardown
//
//    @MainActor
//    override func setUp() {
//        super.setUp()
//        // Nota: O AppCoordinator requer uma API key válida no Info.plist
//        // Para testes em ambiente real, certifique-se de ter a chave configurada
//        // coordinator = AppCoordinator()
//    }
//
//    override func tearDown() {
//        coordinator = nil
//        super.tearDown()
//    }
//
//    // MARK: - Initialization Tests
//
//    @MainActor
//    func testSelectedTabDefaultsToCharacters() {
//        // Este teste requer uma API key válida
//        // Para rodar em CI, deve-se usar um mock ou skip
//        // XCTAssertEqual(coordinator.selectedTab, .characters)
//    }
//
//    @MainActor
//    func testNavigationPathsStartEmpty() {
//        // Este teste requer uma API key válida
//        // XCTAssertTrue(coordinator.charactersPath.isEmpty)
//        // XCTAssertTrue(coordinator.searchPath.isEmpty)
//        // XCTAssertTrue(coordinator.favoritesPath.isEmpty)
//        // XCTAssertTrue(coordinator.settingsPath.isEmpty)
//    }
//}
//
//// MARK: - Navigation Path Tests using Swift Testing
//
//@Suite("Navigation Path Logic Tests")
//struct NavigationPathLogicTests {
//
//    @Test("NavigationPath should support appending CharacterDestination")
//    @MainActor
//    func testNavigationPathAppend() {
//        // Arrange
//        var path = NavigationPath()
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        let destination = CharacterDestination.detail(character)
//
//        // Act
//        path.append(destination)
//
//        // Assert
//        #expect(path.count == 1)
//    }
//
//    @Test("NavigationPath should support removing last element")
//    @MainActor
//    func testNavigationPathRemoveLast() {
//        // Arrange
//        var path = NavigationPath()
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        path.append(CharacterDestination.detail(character))
//        path.append(CharacterDestination.comics(character))
//
//        // Act
//        path.removeLast()
//
//        // Assert
//        #expect(path.count == 1)
//    }
//
//    @Test("NavigationPath should support clearing all elements")
//    @MainActor
//    func testNavigationPathClear() {
//        // Arrange
//        var path = NavigationPath()
//        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        path.append(CharacterDestination.detail(character))
//        path.append(CharacterDestination.comics(character))
//
//        // Act
//        path.removeLast(path.count)
//
//        // Assert
//        #expect(path.isEmpty)
//    }
//
//    @Test("NavigationPath isEmpty should return true for empty path")
//    @MainActor
//    func testNavigationPathIsEmpty() {
//        // Arrange
//        let path = NavigationPath()
//
//        // Assert
//        #expect(path.isEmpty)
//        #expect(path.count == 0)
//    }
//
//    @Test("Multiple destinations can be appended in sequence")
//    @MainActor
//    func testMultipleDestinationsAppend() {
//        // Arrange
//        var path = NavigationPath()
//        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
//        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")
//
//        // Act
//        path.append(CharacterDestination.detail(character1))
//        path.append(CharacterDestination.comics(character1))
//        path.append(CharacterDestination.detail(character2))
//
//        // Assert
//        #expect(path.count == 3)
//    }
//}
//
//// MARK: - Character Fixture Tests
//
//@Suite("Character Fixture Validation Tests")
//struct CharacterFixtureValidationTests {
//
//    @Test("Fixture should create valid Character")
//    func testFixtureCreatesValidCharacter() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.id == 1)
//        #expect(character.name == "Spider-Man")
//        #expect(character.description == "Friendly neighborhood Spider-Man")
//        #expect(character.countOfIssueAppearances == 100)
//    }
//
//    @Test("Fixture should allow custom values")
//    func testFixtureWithCustomValues() {
//        // Act
//        let character = Character.coordinatorFixture(
//            id: 999,
//            name: "Custom Hero",
//            description: "A custom description",
//            comicsCount: 50
//        )
//
//        // Assert
//        #expect(character.id == 999)
//        #expect(character.name == "Custom Hero")
//        #expect(character.description == "A custom description")
//        #expect(character.countOfIssueAppearances == 50)
//    }
//
//    @Test("Fixture should create character with valid image")
//    func testFixtureImageValid() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.image.bestQualityUrl != nil)
//        #expect(character.image.thumbnailUrl != nil)
//        #expect(character.image.mediumQualityUrl != nil)
//    }
//
//    @Test("Fixture should create character with publisher")
//    func testFixturePublisher() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.publisher?.name == "Marvel")
//        #expect(character.publisher?.id == 31)
//    }
//
//    @Test("Fixture should create character with powers")
//    func testFixturePowers() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.powers?.count == 2)
//        #expect(character.powers?[0].name == "Super Strength")
//        #expect(character.powers?[1].name == "Wall Crawling")
//    }
//
//    @Test("Fixture should create character with enemies")
//    func testFixtureEnemies() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.characterEnemies?.count == 1)
//        #expect(character.characterEnemies?[0].name == "Green Goblin")
//    }
//
//    @Test("Fixture should create character with friends")
//    func testFixtureFriends() {
//        // Act
//        let character = Character.coordinatorFixture()
//
//        // Assert
//        #expect(character.characterFriends?.count == 1)
//        #expect(character.characterFriends?[0].name == "Mary Jane Watson")
//    }
//}
//
//// MARK: - ComicVineImage Fixture Tests
//
//@Suite("ComicVineImage Tests")
//struct ComicVineImageTests {
//
//    @Test("ComicVineImage should return best quality URL")
//    func testBestQualityUrl() {
//        // Arrange
//        let image = ComicVineImage(
//            iconUrl: "https://example.com/icon.jpg",
//            mediumUrl: "https://example.com/medium.jpg",
//            screenUrl: nil,
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: "https://example.com/super.jpg",
//            thumbUrl: nil,
//            tinyUrl: nil,
//            originalUrl: "https://example.com/original.jpg"
//        )
//
//        // Assert
//        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/original.jpg")
//    }
//
//    @Test("ComicVineImage should fallback when original not available")
//    func testBestQualityUrlFallback() {
//        // Arrange
//        let image = ComicVineImage(
//            iconUrl: "https://example.com/icon.jpg",
//            mediumUrl: "https://example.com/medium.jpg",
//            screenUrl: nil,
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: "https://example.com/super.jpg",
//            thumbUrl: nil,
//            tinyUrl: nil,
//            originalUrl: nil
//        )
//
//        // Assert
//        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/super.jpg")
//    }
//
//    @Test("ComicVineImage should return medium quality URL")
//    func testMediumQualityUrl() {
//        // Arrange
//        let image = ComicVineImage(
//            iconUrl: nil,
//            mediumUrl: "https://example.com/medium.jpg",
//            screenUrl: "https://example.com/screen.jpg",
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: nil,
//            thumbUrl: nil,
//            tinyUrl: nil,
//            originalUrl: nil
//        )
//
//        // Assert
//        #expect(image.mediumQualityUrl?.absoluteString == "https://example.com/medium.jpg")
//    }
//
//    @Test("ComicVineImage should return thumbnail URL")
//    func testThumbnailUrl() {
//        // Arrange
//        let image = ComicVineImage(
//            iconUrl: nil,
//            mediumUrl: nil,
//            screenUrl: nil,
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: nil,
//            thumbUrl: "https://example.com/thumb.jpg",
//            tinyUrl: nil,
//            originalUrl: nil
//        )
//
//        // Assert
//        #expect(image.thumbnailUrl?.absoluteString == "https://example.com/thumb.jpg")
//    }
//
//    @Test("ComicVineImage with all nil should return nil URLs")
//    func testAllNilUrls() {
//        // Arrange
//        let image = ComicVineImage(
//            iconUrl: nil,
//            mediumUrl: nil,
//            screenUrl: nil,
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: nil,
//            thumbUrl: nil,
//            tinyUrl: nil,
//            originalUrl: nil
//        )
//
//        // Assert
//        #expect(image.bestQualityUrl == nil)
//        #expect(image.mediumQualityUrl == nil)
//        #expect(image.thumbnailUrl == nil)
//    }
//}
//
//// MARK: - Supporting Structure Tests
//
//@Suite("Supporting Structures Tests")
//struct SupportingStructuresTests {
//
//    @Test("OriginSummary should store values correctly")
//    func testOriginSummary() {
//        // Arrange & Act
//        let origin = OriginSummary(id: 4, name: "Human")
//
//        // Assert
//        #expect(origin.id == 4)
//        #expect(origin.name == "Human")
//    }
//
//    @Test("PublisherSummary should store values correctly")
//    func testPublisherSummary() {
//        // Arrange & Act
//        let publisher = PublisherSummary(id: 31, name: "Marvel")
//
//        // Assert
//        #expect(publisher.id == 31)
//        #expect(publisher.name == "Marvel")
//    }
//}
@testable import AppCoordinator
@testable import ComicVineAPI
import SwiftUI
import Testing
import XCTest

// MARK: - Character Fixture for AppCoordinator Tests

extension Character {
    /// Fixture para testes do AppCoordinator
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

// MARK: - CharacterDestination Tests

@Suite("CharacterDestination Tests")
struct CharacterDestinationTests {

    @Test("CharacterDestination.detail should be hashable")
    func testDetailHashable() {
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let destination1 = CharacterDestination.detail(character)
        let destination2 = CharacterDestination.detail(character)

        #expect(destination1 == destination2)
        #expect(destination1.hashValue == destination2.hashValue)
    }

    @Test("CharacterDestination.comics should be hashable")
    func testComicsHashable() {
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let destination1 = CharacterDestination.comics(character)
        let destination2 = CharacterDestination.comics(character)

        #expect(destination1 == destination2)
        #expect(destination1.hashValue == destination2.hashValue)
    }

    @Test("Different CharacterDestinations should not be equal")
    func testDifferentDestinationsNotEqual() {
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let detailDestination = CharacterDestination.detail(character)
        let comicsDestination = CharacterDestination.comics(character)

        #expect(detailDestination != comicsDestination)
    }

    @Test("CharacterDestination with different characters should not be equal")
    func testDifferentCharactersNotEqual() {
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        let destination1 = CharacterDestination.detail(character1)
        let destination2 = CharacterDestination.detail(character2)

        #expect(destination1 != destination2)
    }

    @Test("CharacterDestination can be used in Set")
    func testDestinationInSet() {
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        var destinations: Set<CharacterDestination> = []
        destinations.insert(.detail(character1))
        destinations.insert(.detail(character2))
        destinations.insert(.comics(character1))
        destinations.insert(.detail(character1)) // Duplicata

        #expect(destinations.count == 3)
    }
}

// MARK: - AppTab Tests

@Suite("AppTab Tests")
struct AppTabTests {

    @Test("AppTab should have correct raw values")
    func testRawValues() {
        #expect(AppTab.characters.rawValue == "Characters")
        #expect(AppTab.search.rawValue == "Search")
        #expect(AppTab.favorites.rawValue == "Favorites")
        #expect(AppTab.settings.rawValue == "Settings")
    }

    @Test("AppTab should have correct icons")
    func testIcons() {
        #expect(AppTab.characters.icon == "person.3.fill")
        #expect(AppTab.search.icon == "magnifyingglass")
        #expect(AppTab.favorites.icon == "star.fill")
        #expect(AppTab.settings.icon == "gearshape.fill")
    }

    @Test("AppTab.allCases should contain all tabs")
    func testAllCases() {
        let allCases = AppTab.allCases

        #expect(allCases.count == 4)
        #expect(allCases.contains(.characters))
        #expect(allCases.contains(.search))
        #expect(allCases.contains(.favorites))
        #expect(allCases.contains(.settings))
    }
}

// MARK: - Navigation Path Logic Tests

@Suite("Navigation Path Logic Tests")
struct NavigationPathLogicTests {

    @Test("NavigationPath should support appending CharacterDestination")
    @MainActor
    func testNavigationPathAppend() {
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let destination = CharacterDestination.detail(character)

        path.append(destination)

        #expect(path.count == 1)
    }

    @Test("NavigationPath should support removing last element")
    @MainActor
    func testNavigationPathRemoveLast() {
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))
        path.append(CharacterDestination.comics(character))

        path.removeLast()

        #expect(path.count == 1)
    }

    @Test("NavigationPath should support clearing all elements")
    @MainActor
    func testNavigationPathClear() {
        var path = NavigationPath()
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        path.append(CharacterDestination.detail(character))
        path.append(CharacterDestination.comics(character))

        path.removeLast(path.count)

        #expect(path.isEmpty)
    }

    @Test("NavigationPath isEmpty should return true for empty path")
    @MainActor
    func testNavigationPathIsEmpty() {
        let path = NavigationPath()

        #expect(path.isEmpty)
        #expect(path.count == 0)
    }

    @Test("Multiple destinations can be appended in sequence")
    @MainActor
    func testMultipleDestinationsAppend() {
        var path = NavigationPath()
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        path.append(CharacterDestination.detail(character1))
        path.append(CharacterDestination.comics(character1))
        path.append(CharacterDestination.detail(character2))

        #expect(path.count == 3)
    }
}

// MARK: - Character Fixture Validation Tests

@Suite("Character Fixture Validation Tests")
struct CharacterFixtureValidationTests {

    @Test("Fixture should create valid Character")
    func testFixtureCreatesValidCharacter() {
        let character = Character.coordinatorFixture()

        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Fixture should allow custom values")
    func testFixtureWithCustomValues() {
        let character = Character.coordinatorFixture(
            id: 999,
            name: "Custom Hero",
            description: "A custom description",
            comicsCount: 50
        )

        #expect(character.id == 999)
        #expect(character.name == "Custom Hero")
        #expect(character.description == "A custom description")
        #expect(character.countOfIssueAppearances == 50)
    }

    @Test("Fixture should create character with valid image")
    func testFixtureImageValid() {
        let character = Character.coordinatorFixture()

        #expect(character.image.bestQualityUrl != nil)
        #expect(character.image.thumbnailUrl != nil)
        #expect(character.image.mediumQualityUrl != nil)
    }

    @Test("Fixture should create character with publisher")
    func testFixturePublisher() {
        let character = Character.coordinatorFixture()

        #expect(character.publisher?.name == "Marvel")
        #expect(character.publisher?.id == 31)
    }

    @Test("Fixture should create character with powers")
    func testFixturePowers() {
        let character = Character.coordinatorFixture()

        #expect(character.powers?.count == 2)
        #expect(character.powers?[0].name == "Super Strength")
        #expect(character.powers?[1].name == "Wall Crawling")
    }
}

// MARK: - ComicVineImage Tests

@Suite("ComicVineImage Tests")
struct ComicVineImageTests {

    @Test("ComicVineImage should return best quality URL")
    func testBestQualityUrl() {
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

        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/original.jpg")
    }

    @Test("ComicVineImage should fallback when original not available")
    func testBestQualityUrlFallback() {
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

        #expect(image.bestQualityUrl?.absoluteString == "https://example.com/super.jpg")
    }

    @Test("ComicVineImage with all nil should return nil URLs")
    func testAllNilUrls() {
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

        #expect(image.bestQualityUrl == nil)
        #expect(image.mediumQualityUrl == nil)
        #expect(image.thumbnailUrl == nil)
    }
}

// MARK: - Supporting Structure Tests

@Suite("Supporting Structures Tests")
struct SupportingStructuresTests {

    @Test("OriginSummary should store values correctly")
    func testOriginSummary() {
        let origin = OriginSummary(id: 4, name: "Human")

        #expect(origin.id == 4)
        #expect(origin.name == "Human")
    }

    @Test("PublisherSummary should store values correctly")
    func testPublisherSummary() {
        let publisher = PublisherSummary(id: 31, name: "Marvel")

        #expect(publisher.id == 31)
        #expect(publisher.name == "Marvel")
    }
}
