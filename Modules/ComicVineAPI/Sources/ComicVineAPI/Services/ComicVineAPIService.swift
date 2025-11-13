//
//  ComicVineAPIService.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import Foundation
import Networking
import Alamofire

public protocol ComicVineServiceProtocol: Sendable {
    func fetchCharacters(offset: Int, limit: Int) async throws -> [Character]
    func fetchCharacter(by id: Int) async throws -> Character
    func fetchIssues(offset: Int, limit: Int) async throws -> [Comic]
    func fetchIssue(by id: Int) async throws -> Comic
    func searchCharacters(query: String, offset: Int, limit: Int) async throws -> [Character]
    func searchComics(query: String, offset: Int, limit: Int) async throws -> [Comic]
    func fetchCharacterComics(characterId: Int, offset: Int, limit: Int) async throws -> [Comic]
}

public final class ComicVineAPIService: ComicVineServiceProtocol, @unchecked Sendable {
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let apiKey: String
    private let baseURL = "https://comicvine.gamespot.com/api"

    // Cache para armazenar personagens já carregados
    private var characterCache: [Int: Character] = [:]

    // MARK: - Response Validation Helper
    private func validateResponse<T>(_ response: ComicVineResponse<T>) throws {
        guard response.isSuccess else {
            let errorMessage = response.errorMessage ?? "Unknown ComicVine API error"
            throw NetworkError.serverErrorMessage(errorMessage)
        }
    }

    // MARK: - Endpoints
    enum Endpoint {
        case characters(offset: Int, limit: Int)
        case character(id: Int)
        case issues(offset: Int, limit: Int)
        case issue(id: Int)
        case search(query: String, resources: String, offset: Int, limit: Int)

        var path: String {
            switch self {
            case .characters: return "/characters"
            case .character(let id): return "/character/4005-\(id)"
            case .issues: return "/issues"
            case .issue(let id): return "/issue/4000-\(id)"
            case .search: return "/search"
            }
        }

        var parameters: [String: String] {
            switch self {
            case .characters(let offset, let limit):
                return [
                    "offset": String(offset),
                    "limit": String(limit),
                    "sort": "date_last_updated:desc",
                    "field_list": "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher,character_enemies,character_friends,creators,issue_credits,powers,teams,volume_credits"
                ]
            case .character:
                return [
                    "field_list": "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher,character_enemies,character_friends,creators,issue_credits,powers,teams,volume_credits"
                ]
            case .issues(let offset, let limit):
                return [
                    "offset": String(offset),
                    "limit": String(limit),
                    "sort": "date_last_updated:desc",
                    "field_list": "id,name,issue_number,description,deck,image,cover_date,store_date,api_detail_url,site_detail_url,volume,has_staff_review,date_added,date_last_updated"
                ]
            case .issue:
                return [
                    "field_list": "id,name,issue_number,description,deck,image,cover_date,store_date,api_detail_url,site_detail_url,volume,has_staff_review,date_added,date_last_updated"
                ]
            case .search(let query, let resources, let offset, let limit):
                return [
                    "query": query,
                    "resources": resources,
                    "offset": String(offset),
                    "limit": String(limit),
                    "field_list": resources == "character"
                        ? "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher,character_enemies,character_friends,creators,issue_credits,powers,teams,volume_credits"
                        : "id,name,issue_number,description,deck,image,cover_date,store_date,api_detail_url,site_detail_url,volume,has_staff_review,date_added,date_last_updated"
                ]
            }
        }
    }

    // MARK: - Initialization
    public init(networkService: NetworkServiceProtocol, apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }

    // MARK: - Private Methods
    private func makeRequest<T: Decodable & Sendable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T {
        var parameters = endpoint.parameters
        parameters["api_key"] = apiKey
        parameters["format"] = "json"

        let apiEndpoint = ComicVineEndpoint(
            baseURL: baseURL,
            path: endpoint.path,
            method: .get,
            headers: nil,
            parameters: parameters,
            encoding: URLEncoding.default
        )

        return try await networkService.request(apiEndpoint, responseType: responseType)
    }

    // MARK: - Public Methods
    public func fetchCharacters(offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let response = try await makeRequest(.characters(offset: offset, limit: limit),
                                             responseType: ComicVineResponse<Character>.self)
        try validateResponse(response)
        return response.results
    }

    public func fetchCharacter(by id: Int) async throws -> Character {
        // Verificar cache primeiro
        if let cachedCharacter = characterCache[id] {
            print("📦 Usando character em cache: \(cachedCharacter.name)")
            return cachedCharacter
        }

        let response = try await makeRequest(
            .character(id: id),
            responseType: ComicVineResponse<Character>.self
        )
        try validateResponse(response)

        // Como results vem como objeto único convertido para array de 1 elemento
        guard let character = response.results.first else {
            throw NetworkError.serverErrorMessage("Character not found")
        }

        // Armazenar em cache
        characterCache[id] = character

        return character
    }

    public func fetchIssues(offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        let response = try await makeRequest(.issues(offset: offset, limit: limit),
                                             responseType: ComicVineResponse<Comic>.self)
        try validateResponse(response)
        return response.results
    }

    public func fetchIssue(by id: Int) async throws -> Comic {
        let response = try await makeRequest(.issue(id: id),
                                             responseType: ComicVineResponse<Comic>.self)
        try validateResponse(response)
        guard let issue = response.results.first else {
            throw NetworkError.serverErrorMessage("Issue not found")
        }
        return issue
    }

    public func searchCharacters(query: String, offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let response = try await makeRequest(.search(query: query, resources: "character", offset: offset, limit: limit),
                                             responseType: ComicVineResponse<Character>.self)
        try validateResponse(response)
        return response.results
    }

    public func searchComics(query: String, offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        let response = try await makeRequest(.search(query: query, resources: "issue", offset: offset, limit: limit),
                                             responseType: ComicVineResponse<Comic>.self)
        try validateResponse(response)
        return response.results
    }

    /// Busca comics de um personagem usando o campo issueCredits
    /// Como a API ComicVine NÃO suporta filtro por personagem no endpoint /issues,
    /// esta implementação busca primeiro os detalhes do personagem e depois as issues individualmente.
    ///
    /// NOTA: Este método mantém compatibilidade com código existente, mas recomenda-se
    /// usar FetchIssuesByIdsUseCase diretamente para melhor controle e performance.
    public func fetchCharacterComics(characterId: Int, offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        print("🔍 Buscando comics para personagem ID: \(characterId)")

        // Passo 1: Buscar o personagem completo para obter issueCredits
        let character = try await fetchCharacter(by: characterId)

        // Passo 2: Verificar se há issueCredits disponíveis
        guard let issueCredits = character.issueCredits, !issueCredits.isEmpty else {
            print("⚠️ Personagem não tem issueCredits disponíveis")
            return []
        }

        print("📚 Encontradas \(issueCredits.count) issues para o personagem")

        // Passo 3: Aplicar paginação nos IDs
        let startIndex = offset
        let endIndex = min(startIndex + limit, issueCredits.count)

        guard startIndex < issueCredits.count else {
            return []
        }

        let issueIdsToLoad = issueCredits[startIndex..<endIndex].map { $0.id }

        // Passo 4: Buscar as issues em paralelo (mas com limite de concorrência)
        let batchSize = 5 // Processar 5 requisições por vez
        var allComics: [Comic] = []

        for batch in issueIdsToLoad.chunked(into: batchSize) {
            let comics = await withTaskGroup(of: Comic?.self) { group in
                for issueId in batch {
                    group.addTask { [weak self] in
                        guard let self = self else { return nil }
                        do {
                            return try await self.fetchIssue(by: issueId)
                        } catch {
                            print("⚠️ Erro ao buscar issue \(issueId): \(error)")
                            return nil
                        }
                    }
                }

                var batchComics: [Comic] = []
                for await comic in group {
                    if let comic = comic {
                        batchComics.append(comic)
                    }
                }
                return batchComics
            }

            allComics.append(contentsOf: comics)

            // Pequeno delay entre lotes para respeitar rate limits
            if batch != issueIdsToLoad.chunked(into: batchSize).last {
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 segundos
            }
        }

        // Ordenar por data de lançamento (mais recentes primeiro)
        return allComics.sorted { first, second in
            if let date1 = first.coverDate, let date2 = second.coverDate {
                return date1 > date2
            }
            return first.id > second.id
        }
    }
}

// MARK: - Array Extension para chunking
private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}






