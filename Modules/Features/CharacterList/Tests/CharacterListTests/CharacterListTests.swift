@testable import CharacterList
@testable import ComicVineAPI
import Networking
import Testing
import XCTest

// MARK: - Mock Service
final class MockComicVineService: ComicVineServiceProtocol, @unchecked Sendable {
    var shouldThrowError = false
    var charactersToReturn: [Character] = []
    var characterToReturn: Character?
    var comicsToReturn: [Comic] = []
    var issueToReturn: Comic?

    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character] {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        return charactersToReturn
    }

    func fetchCharacter(by id: Int) async throws -> Character {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        guard let character = characterToReturn else {
            throw NetworkError.noData
        }
        return character
    }

    func fetchCharacterComics(characterId: Int, offset: Int, limit: Int) async throws -> [Comic] {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        return comicsToReturn
    }

    func fetchIssues(offset: Int, limit: Int) async throws -> [Comic] {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        return comicsToReturn
    }

    func fetchIssue(by id: Int) async throws -> Comic {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        guard let issue = issueToReturn else {
            throw NetworkError.noData
        }
        return issue
    }

    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character] {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        return charactersToReturn.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic] {
        if shouldThrowError {
            throw NetworkError.serverErrorCode(500)
        }
        return comicsToReturn
    }
}

// MARK: - Character Fixture
extension Character {
    static func fixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        comicsCount: Int = 100
    ) -> Character {
        Character.makeFromCache(
            id: id,
            name: name,
            description: description,
            thumbnailPath: "https://example.com/image.jpg",
            comicsCount: comicsCount
        )
    }
}

// MARK: - Tests using Swift Testing
@Suite("CharacterListViewModel Tests")
struct CharacterListViewModelTests {

    @Test("Should load characters successfully")
    @MainActor
    func testLoadCharactersSuccess() async throws {
        // Arrange
        let mockService = MockComicVineService()
        mockService.charactersToReturn = [
            Character.fixture(id: 1, name: "Spider-Man"),
            Character.fixture(id: 2, name: "Iron Man")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()

        // Aguarda o carregamento assíncrono
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos

        // Assert
        #expect(viewModel.characters.count == 2)
        #expect(viewModel.characters[0].name == "Spider-Man")
        #expect(viewModel.characters[1].name == "Iron Man")
        #expect(viewModel.error == nil)
    }

    @Test("Should handle error when loading characters")
    @MainActor
    func testLoadCharactersError() async throws {
        // Arrange
        let mockService = MockComicVineService()
        mockService.shouldThrowError = true

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()

        // Aguarda o carregamento assíncrono
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.error != nil)
    }

    @Test("Should convert characters to card models")
    @MainActor
    func testCharacterCardModels() async throws {
        // Arrange
        let mockService = MockComicVineService()
        mockService.charactersToReturn = [
            Character.fixture(id: 1, name: "Spider-Man", comicsCount: 150),
            Character.fixture(id: 2, name: "Iron Man", comicsCount: 200)
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()

        // Aguarda o carregamento assíncrono
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert
        let cardModels = viewModel.characterCardModels
        #expect(cardModels.count == 2)
        #expect(cardModels[0].name == "Spider-Man")
        #expect(cardModels[1].name == "Iron Man")
    }

    @Test("Should display characters correctly")
    @MainActor
    func testDisplayCharacters() async throws {
        // Arrange
        let mockService = MockComicVineService()
        mockService.charactersToReturn = [
            Character.fixture(id: 1, name: "Batman"),
            Character.fixture(id: 2, name: "Superman"),
            Character.fixture(id: 3, name: "Wonder Woman")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Act
        viewModel.loadInitialData()

        // Aguarda o carregamento assíncrono
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert - displayCharacters retorna characters quando searchText está vazio
        #expect(viewModel.displayCharacters.count == 3)
        #expect(viewModel.displayCharacters[0].name == "Batman")
    }

    @Test("Should have correct initial state")
    @MainActor
    func testInitialState() async {
        // Arrange
        let mockService = MockComicVineService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Assert
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isSearching == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.hasMorePages == true)
        #expect(viewModel.searchText.isEmpty)
    }
}

// MARK: - Character Fixture Tests
@Suite("Character Fixture Tests")
struct CharacterFixtureTests {

    @Test("Should create character fixture with default values")
    func testDefaultFixture() {
        let character = Character.fixture()

        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Friendly neighborhood Spider-Man")
        #expect(character.comicsCount == 100)
    }

    @Test("Should create character fixture with custom values")
    func testCustomFixture() {
        let character = Character.fixture(
            id: 42,
            name: "Batman",
            description: "The Dark Knight",
            comicsCount: 500
        )

        #expect(character.id == 42)
        #expect(character.name == "Batman")
        #expect(character.description == "The Dark Knight")
        #expect(character.comicsCount == 500)
    }
}
