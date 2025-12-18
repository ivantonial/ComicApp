//
//  MockComicVineService.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation

// MARK: - MockComicVineService (Actor)

/// Mock thread-safe do ComicVineServiceProtocol usando actor para isolamento de concorrência.
/// Projetado para ser usado em testes com operações concorrentes.
actor MockComicVineService: ComicVineServiceProtocol {

    // MARK: - Private Storage (Actor-Isolated)

    private var _characters: [Character] = []
    private var _comics: [Comic] = []
    private var _characterById: [Int: Character] = [:]
    private var _comicById: [Int: Comic] = [:]
    private var _characterComics: [Int: [Comic]] = [:]
    private var _searchCharactersResults: [String: [Character]] = [:]
    private var _searchComicsResults: [String: [Comic]] = [:]
    private var _shouldThrowError = false
    private var _errorToThrow: Error?
    private var _methodCalls: [String: Int] = [:]
    private var _fetchDelay: TimeInterval = 0

    // MARK: - ComicVineServiceProtocol Implementation

    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character] {
        trackMethodCall("fetchCharacters")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        let startIndex = min(offset, _characters.count)
        let endIndex = min(startIndex + limit, _characters.count)

        guard startIndex < endIndex else { return [] }
        return Array(_characters[startIndex..<endIndex])
    }

    func fetchCharacter(by id: Int) async throws -> Character {
        trackMethodCall("fetchCharacter")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        guard let character = _characterById[id] else {
            throw MockServiceError.notFound
        }

        return character
    }

    func fetchIssues(offset: Int, limit: Int) async throws -> [Comic] {
        trackMethodCall("fetchIssues")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        let startIndex = min(offset, _comics.count)
        let endIndex = min(startIndex + limit, _comics.count)

        guard startIndex < endIndex else { return [] }
        return Array(_comics[startIndex..<endIndex])
    }

    func fetchIssue(by id: Int) async throws -> Comic {
        trackMethodCall("fetchIssue")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        guard let comic = _comicById[id] else {
            throw MockServiceError.notFound
        }

        return comic
    }

    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character] {
        trackMethodCall("searchCharacters")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        let results = _searchCharactersResults[query.lowercased()] ?? []
        let startIndex = min(offset, results.count)
        let endIndex = min(startIndex + limit, results.count)

        guard startIndex < endIndex else { return [] }
        return Array(results[startIndex..<endIndex])
    }

    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic] {
        trackMethodCall("searchComics")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        let results = _searchComicsResults[query.lowercased()] ?? []
        let startIndex = min(offset, results.count)
        let endIndex = min(startIndex + limit, results.count)

        guard startIndex < endIndex else { return [] }
        return Array(results[startIndex..<endIndex])
    }

    func fetchCharacterComics(characterId: Int, offset: Int, limit: Int) async throws -> [Comic] {
        trackMethodCall("fetchCharacterComics")

        if _fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(_fetchDelay * 1_000_000_000))
        }

        if _shouldThrowError, let error = _errorToThrow {
            throw error
        }

        let comics = _characterComics[characterId] ?? []
        let startIndex = min(offset, comics.count)
        let endIndex = min(startIndex + limit, comics.count)

        guard startIndex < endIndex else { return [] }
        return Array(comics[startIndex..<endIndex])
    }

    // MARK: - Test Setup Methods

    /// Define os characters que serão retornados pelo mock
    func setCharacters(_ characters: [Character]) {
        _characters = characters
        for character in characters {
            _characterById[character.id] = character
        }
    }

    /// Define os comics que serão retornados pelo mock
    func setComics(_ comics: [Comic]) {
        _comics = comics
        for comic in comics {
            _comicById[comic.id] = comic
        }
    }

    /// Define um character específico por ID
    func setCharacter(_ character: Character, forId id: Int) {
        _characterById[id] = character
    }

    /// Define um comic específico por ID
    func setComic(_ comic: Comic, forId id: Int) {
        _comicById[id] = comic
    }

    /// Define os comics de um personagem específico
    func setCharacterComics(_ comics: [Comic], forCharacterId id: Int) {
        _characterComics[id] = comics
    }

    /// Define os resultados de busca de characters
    func setSearchCharactersResults(_ results: [Character], forQuery query: String) {
        _searchCharactersResults[query.lowercased()] = results
    }

    /// Define os resultados de busca de comics
    func setSearchComicsResults(_ results: [Comic], forQuery query: String) {
        _searchComicsResults[query.lowercased()] = results
    }

    /// Configura o mock para lançar um erro
    func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
        _shouldThrowError = shouldThrow
        _errorToThrow = error ?? MockServiceError.genericError
    }

    /// Define um delay para simular latência de rede
    func setFetchDelay(_ delay: TimeInterval) {
        _fetchDelay = delay
    }

    // MARK: - Test Helper Methods (Sendable returns)

    /// Retorna a contagem de characters configurados
    func getCharactersCount() -> Int {
        return _characters.count
    }

    /// Retorna a contagem de comics configurados
    func getComicsCount() -> Int {
        return _comics.count
    }

    /// Verifica se um character existe por ID
    func hasCharacter(id: Int) -> Bool {
        return _characterById[id] != nil
    }

    /// Verifica se um comic existe por ID
    func hasComic(id: Int) -> Bool {
        return _comicById[id] != nil
    }

    /// Retorna a contagem de chamadas para um método específico
    func callCount(for method: String) -> Int {
        return _methodCalls[method] ?? 0
    }

    /// Reseta todo o estado do mock
    func reset() {
        _characters.removeAll()
        _comics.removeAll()
        _characterById.removeAll()
        _comicById.removeAll()
        _characterComics.removeAll()
        _searchCharactersResults.removeAll()
        _searchComicsResults.removeAll()
        _shouldThrowError = false
        _errorToThrow = nil
        _methodCalls.removeAll()
        _fetchDelay = 0
    }

    // MARK: - Private Helpers

    private func trackMethodCall(_ method: String) {
        _methodCalls[method, default: 0] += 1
    }
}

// MARK: - MockServiceError

/// Erros que podem ser lançados pelo MockComicVineService
enum MockServiceError: Error, LocalizedError {
    case notFound
    case genericError
    case networkError
    case invalidResponse
    case rateLimitExceeded

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Resource not found"
        case .genericError:
            return "A generic error occurred"
        case .networkError:
            return "Network error occurred"
        case .invalidResponse:
            return "Invalid response from server"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        }
    }
}

// MARK: - MockNetworkService

/// Mock do NetworkServiceProtocol para testes de integração
actor MockNetworkService {

    private var _responses: [String: Any] = [:]
    private var _shouldThrowError = false
    private var _errorToThrow: Error?
    private var _requestCount = 0

    func setResponse<T: Decodable>(_ response: T, forPath path: String) {
        _responses[path] = response
    }

    func setShouldThrowError(_ shouldThrow: Bool, error: Error? = nil) {
        _shouldThrowError = shouldThrow
        _errorToThrow = error
    }

    func getRequestCount() -> Int {
        return _requestCount
    }

    func reset() {
        _responses.removeAll()
        _shouldThrowError = false
        _errorToThrow = nil
        _requestCount = 0
    }
}
