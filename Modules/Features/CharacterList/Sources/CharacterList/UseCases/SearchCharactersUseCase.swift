//
//  SearchCharactersUseCase.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Cache
import ComicVineAPI
import Foundation

public protocol SearchCharactersUseCase {
    func search(_ query: String, offset: Int, limit: Int) async throws -> [Character]
}

public final class SearchCharactersUseCaseImpl: SearchCharactersUseCase {
    private let service: ComicVineAPIService
    private let cacheManager: CacheManager
    private let cacheKey = "SearchCharacters_"

    public init(service: ComicVineAPIService, cacheManager: CacheManager = .shared) {
        self.service = service
        self.cacheManager = cacheManager
    }

    public func search(_ query: String, offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        return try await service.searchCharacters(query: trimmedQuery, offset: offset, limit: limit)
    }
}
