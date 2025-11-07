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
        case characterIssues(characterId: Int, offset: Int, limit: Int)

        var path: String {
            switch self {
            case .characters: return "/characters"
            case .character(let id): return "/character/4005-\(id)"
            case .issues: return "/issues"
            case .issue(let id): return "/issue/4000-\(id)"
            case .search: return "/search"
            case .characterIssues: return "/issues"
            }
        }

        var parameters: [String: String] {
            switch self {
            case .characters(let offset, let limit):
                return [
                    "offset": String(offset),
                    "limit": String(limit),
                    "sort": "date_last_updated:desc",
                    "field_list": "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher"
                ]
            case .character:
                return [
                    "field_list": "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher"
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
                        ? "id,name,description,deck,aliases,image,api_detail_url,site_detail_url,first_appeared_in_issue,count_of_issue_appearances,real_name,birth,date_added,date_last_updated,gender,origin,publisher"
                        : "id,name,issue_number,description,deck,image,cover_date,store_date,api_detail_url,site_detail_url,volume,has_staff_review,date_added,date_last_updated"
                ]
            case .characterIssues(let characterId, let offset, let limit):
                return [
                    "filter": "character:\(characterId)",
                    "offset": String(offset),
                    "limit": String(limit),
                    "sort": "cover_date:desc",
                    "field_list": "id,name,issue_number,description,deck,image,cover_date,store_date,api_detail_url,site_detail_url,volume,has_staff_review,date_added,date_last_updated"
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
        let response = try await makeRequest(
            .character(id: id),
            responseType: ComicVineResponse<Character>.self
        )
        try validateResponse(response)

        // Como results vem como objeto único convertido para array de 1 elemento
        guard let character = response.results.first else {
            throw NetworkError.serverErrorMessage("Character not found")
        }
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

    public func fetchCharacterComics(characterId: Int, offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        let response = try await makeRequest(.characterIssues(characterId: characterId, offset: offset, limit: limit),
                                             responseType: ComicVineResponse<Comic>.self)
        try validateResponse(response)
        return response.results
    }
}
