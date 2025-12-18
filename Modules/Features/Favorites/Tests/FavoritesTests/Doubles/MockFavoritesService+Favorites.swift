//
//  MockFavoritesService+Favorites.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

import Cache
import Combine
import ComicVineAPI
import Core
import Foundation

// MARK: - MockFavoritesServiceForFavorites

/// Mock do FavoritesService para testes do módulo Favorites.
/// Simula o comportamento do FavoritesService real sem dependências externas.
/// Usa @MainActor para manter compatibilidade com o FavoritesService real.
@MainActor
final class MockFavoritesServiceForFavorites: ObservableObject {

    // MARK: - Published Properties (igual ao FavoritesService real)

    @Published private(set) var favoriteCharacters: [Character] = []
    @Published private(set) var favoriteComics: [Comic] = []

    // MARK: - Test Configuration Properties

    var shouldThrowError = false
    var errorToThrow: Error = MockFavoritesServiceError.genericError
    var getAllFavoritesDelay: UInt64 = 0

    // MARK: - Call Tracking Properties

    private(set) var isFavoriteCharacterIdCalls: [Int] = []
    private(set) var isFavoriteComicIdCalls: [Int] = []
    private(set) var toggleFavoriteCharacterCalls: [Character] = []
    private(set) var toggleFavoriteComicCalls: [Comic] = []
    private(set) var getAllFavoritesCalled = false
    private(set) var getAllFavoritesCallCount = 0
    private(set) var removeFavoriteCalls: [Int] = []

    // MARK: - Initialization

    init() {}

    init(initialFavorites: [Character]) {
        self.favoriteCharacters = initialFavorites
    }

    // MARK: - Public API (Sync - em memória)

    /// Verifica se um personagem é favorito com base no array em memória.
    func isFavorite(characterId: Int) -> Bool {
        isFavoriteCharacterIdCalls.append(characterId)
        return favoriteCharacters.contains { $0.id == characterId }
    }

    /// Verifica se um comic é favorito com base no array em memória.
    func isFavorite(comicId: Int) -> Bool {
        isFavoriteComicIdCalls.append(comicId)
        return favoriteComics.contains { $0.id == comicId }
    }

    /// Alterna o status de favorito para um personagem.
    func toggleFavorite(_ character: Character) async {
        toggleFavoriteCharacterCalls.append(character)

        if favoriteCharacters.contains(where: { $0.id == character.id }) {
            favoriteCharacters.removeAll { $0.id == character.id }
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": character.id, "isFavorite": false]
            )
        } else {
            favoriteCharacters.append(character)
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            NotificationCenter.default.post(
                name: .favoriteStatusChanged,
                object: nil,
                userInfo: ["characterId": character.id, "isFavorite": true]
            )
        }
    }

    /// Alterna o status de favorito para um comic.
    func toggleFavorite(_ comic: Comic) async {
        toggleFavoriteComicCalls.append(comic)

        if favoriteComics.contains(where: { $0.id == comic.id }) {
            favoriteComics.removeAll { $0.id == comic.id }
        } else {
            favoriteComics.append(comic)
        }
    }

    /// Retorna todos os favoritos.
    func getAllFavorites() async throws -> [Character] {
        getAllFavoritesCalled = true
        getAllFavoritesCallCount += 1

        // Simula delay se configurado
        if getAllFavoritesDelay > 0 {
            try await Task.sleep(nanoseconds: getAllFavoritesDelay)
        }

        if shouldThrowError {
            throw errorToThrow
        }

        return favoriteCharacters
    }

    /// Remove favorito pelo ID.
    func removeFavorite(characterId: Int) async throws {
        removeFavoriteCalls.append(characterId)

        if shouldThrowError {
            throw errorToThrow
        }

        favoriteCharacters.removeAll { $0.id == characterId }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        NotificationCenter.default.post(
            name: .favoriteStatusChanged,
            object: nil,
            userInfo: ["characterId": characterId, "isFavorite": false]
        )
    }

    // MARK: - Test Setup Methods

    /// Define os personagens favoritos
    func setFavoriteCharacters(_ characters: [Character]) {
        favoriteCharacters = characters
    }

    /// Adiciona um personagem aos favoritos
    func addFavoriteCharacter(_ character: Character) {
        if !favoriteCharacters.contains(where: { $0.id == character.id }) {
            favoriteCharacters.append(character)
        }
    }

    /// Remove um personagem dos favoritos
    func removeFavoriteCharacter(id: Int) {
        favoriteCharacters.removeAll { $0.id == id }
    }

    /// Define os comics favoritos
    func setFavoriteComics(_ comics: [Comic]) {
        favoriteComics = comics
    }

    /// Configura o mock para lançar erro
    func setupError(_ error: Error = MockFavoritesServiceError.genericError) {
        shouldThrowError = true
        errorToThrow = error
    }

    /// Configura delay para simular carregamento lento
    func setupDelay(nanoseconds: UInt64) {
        getAllFavoritesDelay = nanoseconds
    }

    /// Reseta todo o estado do mock
    func reset() {
        favoriteCharacters.removeAll()
        favoriteComics.removeAll()
        shouldThrowError = false
        errorToThrow = MockFavoritesServiceError.genericError
        getAllFavoritesDelay = 0

        isFavoriteCharacterIdCalls.removeAll()
        isFavoriteComicIdCalls.removeAll()
        toggleFavoriteCharacterCalls.removeAll()
        toggleFavoriteComicCalls.removeAll()
        getAllFavoritesCalled = false
        getAllFavoritesCallCount = 0
        removeFavoriteCalls.removeAll()
    }

    // MARK: - Test Helper Methods

    /// Retorna a contagem de favoritos
    func getFavoritesCount() -> Int {
        return favoriteCharacters.count
    }

    /// Verifica se um character foi adicionado via toggleFavorite
    func wasToggleFavoriteCalled(for characterId: Int) -> Bool {
        return toggleFavoriteCharacterCalls.contains { $0.id == characterId }
    }

    /// Retorna quantas vezes isFavorite foi chamado para um characterId
    func isFavoriteCallCount(for characterId: Int) -> Int {
        return isFavoriteCharacterIdCalls.filter { $0 == characterId }.count
    }

    /// Verifica se removeFavorite foi chamado para um characterId
    func wasRemoveFavoriteCalled(for characterId: Int) -> Bool {
        return removeFavoriteCalls.contains(characterId)
    }
}

// MARK: - MockFavoritesServiceError

/// Erros que podem ser lançados pelo MockFavoritesServiceForFavorites
enum MockFavoritesServiceError: Error, LocalizedError {
    case genericError
    case loadFailed
    case saveFailed
    case deleteFailed
    case notFound
    case networkError

    var errorDescription: String? {
        switch self {
        case .genericError:
            return "A generic favorites service error occurred"
        case .loadFailed:
            return "Failed to load favorites"
        case .saveFailed:
            return "Failed to save favorite"
        case .deleteFailed:
            return "Failed to delete favorite"
        case .notFound:
            return "Favorite not found"
        case .networkError:
            return "Network error occurred"
        }
    }
}

// MARK: - Factory Methods

extension MockFavoritesServiceForFavorites {

    /// Cria um mock com favoritos pré-configurados
    static func withFavorites(_ characters: [Character]) -> MockFavoritesServiceForFavorites {
        let mock = MockFavoritesServiceForFavorites()
        mock.setFavoriteCharacters(characters)
        return mock
    }

    /// Cria um mock configurado para lançar erro
    static func withError(_ error: Error = MockFavoritesServiceError.genericError) -> MockFavoritesServiceForFavorites {
        let mock = MockFavoritesServiceForFavorites()
        mock.setupError(error)
        return mock
    }

    /// Cria um mock com delay configurado
    static func withDelay(nanoseconds: UInt64) -> MockFavoritesServiceForFavorites {
        let mock = MockFavoritesServiceForFavorites()
        mock.setupDelay(nanoseconds: nanoseconds)
        return mock
    }
}

// MARK: - Mock FavoritesService Tests

#if DEBUG
import Testing

@Suite("MockFavoritesServiceForFavorites Tests")
struct MockFavoritesServiceForFavoritesTests {

    @Test("Mock should return empty favorites by default")
    @MainActor
    func testDefaultEmptyFavorites() async throws {
        // Arrange
        let mock = MockFavoritesServiceForFavorites()

        // Act
        let favorites = try await mock.getAllFavorites()

        // Assert
        #expect(favorites.isEmpty)
        #expect(mock.getAllFavoritesCalled)
        #expect(mock.getAllFavoritesCallCount == 1)
    }

    @Test("Mock should return configured favorites")
    @MainActor
    func testConfiguredFavorites() async throws {
        // Arrange
        let characters: [Character] = [
            .favoritesFixture(id: 1, name: "Spider-Man"),
            .favoritesFixture(id: 2, name: "Batman")
        ]
        let mock = MockFavoritesServiceForFavorites.withFavorites(characters)

        // Act
        let favorites = try await mock.getAllFavorites()

        // Assert
        #expect(favorites.count == 2)
        #expect(favorites[0].name == "Spider-Man")
        #expect(favorites[1].name == "Batman")
    }

    @Test("Mock should check if character is favorite")
    @MainActor
    func testIsFavoriteCharacter() {
        // Arrange
        let character = Character.favoritesFixture(id: 42)
        let mock = MockFavoritesServiceForFavorites.withFavorites([character])

        // Act & Assert
        #expect(mock.isFavorite(characterId: 42) == true)
        #expect(mock.isFavorite(characterId: 999) == false)
        #expect(mock.isFavoriteCharacterIdCalls.count == 2)
    }

    @Test("Mock should toggle favorite character")
    @MainActor
    func testToggleFavoriteCharacter() async {
        // Arrange
        let mock = MockFavoritesServiceForFavorites()
        let character = Character.favoritesFixture(id: 1, name: "Spider-Man")

        // Act - Add
        await mock.toggleFavorite(character)

        // Assert - Added
        #expect(mock.isFavorite(characterId: 1) == true)
        #expect(mock.getFavoritesCount() == 1)

        // Act - Remove
        await mock.toggleFavorite(character)

        // Assert - Removed
        #expect(mock.isFavorite(characterId: 1) == false)
        #expect(mock.getFavoritesCount() == 0)
    }

    @Test("Mock should throw error when configured")
    @MainActor
    func testThrowError() async {
        // Arrange
        let mock = MockFavoritesServiceForFavorites.withError(MockFavoritesServiceError.loadFailed)

        // Act & Assert
        do {
            _ = try await mock.getAllFavorites()
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is MockFavoritesServiceError)
        }
    }

    @Test("Mock should remove favorite by id")
    @MainActor
    func testRemoveFavorite() async throws {
        // Arrange
        let characters: [Character] = [
            .favoritesFixture(id: 1),
            .favoritesFixture(id: 2),
            .favoritesFixture(id: 3)
        ]
        let mock = MockFavoritesServiceForFavorites.withFavorites(characters)

        // Act
        try await mock.removeFavorite(characterId: 2)

        // Assert
        #expect(mock.getFavoritesCount() == 2)
        #expect(mock.isFavorite(characterId: 1) == true)
        #expect(mock.isFavorite(characterId: 2) == false)
        #expect(mock.isFavorite(characterId: 3) == true)
        #expect(mock.wasRemoveFavoriteCalled(for: 2))
    }

    @Test("Mock should track method calls")
    @MainActor
    func testTrackMethodCalls() async {
        // Arrange
        let mock = MockFavoritesServiceForFavorites()
        let character = Character.favoritesFixture(id: 1)

        // Act
        _ = mock.isFavorite(characterId: 1)
        _ = mock.isFavorite(characterId: 1)
        _ = mock.isFavorite(characterId: 2)
        await mock.toggleFavorite(character)

        // Assert
        #expect(mock.isFavoriteCallCount(for: 1) == 2)
        #expect(mock.isFavoriteCallCount(for: 2) == 1)
        #expect(mock.wasToggleFavoriteCalled(for: 1))
    }

    @Test("Mock should reset state correctly")
    @MainActor
    func testReset() async throws {
        // Arrange
        let mock = MockFavoritesServiceForFavorites()
        mock.setFavoriteCharacters([.favoritesFixture()])
        mock.setupError()
        _ = mock.isFavorite(characterId: 1)

        // Act
        mock.reset()

        // Assert
        #expect(mock.favoriteCharacters.isEmpty)
        #expect(mock.shouldThrowError == false)
        #expect(mock.isFavoriteCharacterIdCalls.isEmpty)

        // Deve funcionar sem erro após reset
        let favorites = try await mock.getAllFavorites()
        #expect(favorites.isEmpty)
    }

    @Test("Mock factory withFavorites should work")
    @MainActor
    func testFactoryWithFavorites() async throws {
        // Arrange
        let characters: [Character] = .favoritesFixtures(count: 5)

        // Act
        let mock = MockFavoritesServiceForFavorites.withFavorites(characters)
        let favorites = try await mock.getAllFavorites()

        // Assert
        #expect(favorites.count == 5)
    }

    @Test("Mock factory withError should work")
    @MainActor
    func testFactoryWithError() async {
        // Arrange
        let mock = MockFavoritesServiceForFavorites.withError(MockFavoritesServiceError.networkError)

        // Act & Assert
        do {
            _ = try await mock.getAllFavorites()
            #expect(Bool(false), "Expected error")
        } catch let error as MockFavoritesServiceError {
            #expect(error == .networkError)
        } catch {
            #expect(Bool(false), "Expected MockFavoritesServiceError")
        }
    }
}
#endif
