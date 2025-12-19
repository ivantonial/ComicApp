//
//  MockFavoritesService.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 12/12/25.
//

import Core
import Foundation

// MARK: - MockFavoritesService (Actor)

/// Mock thread-safe do FavoritesServiceProtocol usando actor para isolamento de concorrência.
/// Projetado para ser usado em testes com operações concorrentes.
actor MockFavoritesService: FavoritesServiceProtocol {

    // MARK: - Private Storage (Actor-Isolated)

    private var _favorites: Set<Int> = []
    private var _shouldThrowError = false
    private var _errorToThrow: Error?
    private var _methodCalls: [String: Int] = [:]
    private var _addedCharacters: [FavoriteCharacterInput] = []

    // MARK: - FavoritesServiceProtocol Implementation

    func isFavorite(characterId: Int) async -> Bool {
        trackMethodCall("isFavorite")
        return _favorites.contains(characterId)
    }

    func addFavorite(character: FavoriteCharacterInput) async throws {
        trackMethodCall("addFavorite")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _favorites.insert(character.id)
        _addedCharacters.append(character)
    }

    func removeFavorite(characterId: Int) async throws {
        trackMethodCall("removeFavorite")

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        _favorites.remove(characterId)
    }

    // MARK: - Test Setup Methods

    /// Define os IDs de favoritos iniciais
    func setFavorites(_ ids: Set<Int>) {
        _favorites = ids
    }

    /// Adiciona um ID aos favoritos
    func addFavoriteId(_ id: Int) {
        _favorites.insert(id)
    }

    /// Remove um ID dos favoritos
    func removeFavoriteId(_ id: Int) {
        _favorites.remove(id)
    }

    /// Configura o mock para lançar um erro
    func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
        _shouldThrowError = shouldThrow
        _errorToThrow = error ?? MockFavoritesError.genericError
    }

    // MARK: - Test Helper Methods

    /// Retorna a contagem de favoritos
    func getFavoritesCount() -> Int {
        return _favorites.count
    }

    /// Retorna todos os IDs de favoritos
    func getAllFavoriteIds() -> Set<Int> {
        return _favorites
    }

    /// Retorna a contagem de chamadas para um método específico
    func callCount(for method: String) -> Int {
        return _methodCalls[method] ?? 0
    }

    /// Retorna todos os characters que foram adicionados aos favoritos
    func getAddedCharacters() -> [FavoriteCharacterInput] {
        return _addedCharacters
    }

    /// Verifica se um character foi adicionado aos favoritos
    func wasCharacterAdded(withId id: Int) -> Bool {
        return _addedCharacters.contains { $0.id == id }
    }

    /// Reseta todo o estado do mock
    func reset() {
        _favorites.removeAll()
        _shouldThrowError = false
        _errorToThrow = nil
        _methodCalls.removeAll()
        _addedCharacters.removeAll()
    }

    // MARK: - Private Helpers

    private func trackMethodCall(_ method: String) {
        _methodCalls[method, default: 0] += 1
    }
}

// MARK: - MockFavoritesError

/// Erros que podem ser lançados pelo MockFavoritesService
enum MockFavoritesError: Error, LocalizedError {
    case genericError
    case notFound
    case saveFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .genericError:
            return "A generic favorites error occurred"
        case .notFound:
            return "Favorite not found"
        case .saveFailed:
            return "Failed to save favorite"
        case .deleteFailed:
            return "Failed to delete favorite"
        }
    }
}

// MARK: - MockFavoritesService Tests Support

extension MockFavoritesService {

    /// Cria um MockFavoritesService com configuração pré-definida
    static func configured(
        favorites: Set<Int> = [],
        shouldThrowError: Bool = false,
        error: Error? = nil
    ) -> MockFavoritesService {
        let mock = MockFavoritesService()
        Task {
            await mock.setFavorites(favorites)
            if shouldThrowError {
                await mock.setShouldThrowError(true, error: error)
            }
        }
        return mock
    }
}
