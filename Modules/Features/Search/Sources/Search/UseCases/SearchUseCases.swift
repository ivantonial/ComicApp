//
//  SearchUseCases.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation
import Cache
import ComicVineAPI

// MARK: - Busca de Personagens com Cache
public final class SearchCharactersWithCacheUseCase: Sendable {
    private let service: ComicVineServiceProtocol
    private let cacheManager: CacheManagerProtocol
    private let cacheKey = "search_characters_"

    public init(service: ComicVineServiceProtocol, cacheManager: CacheManagerProtocol? = nil) {
        self.service = service
        self.cacheManager = cacheManager ?? CacheManager.shared
    }

    public func execute(query: String, offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        let cacheKey = "\(self.cacheKey)\(trimmedQuery)_\(offset)_\(limit)"

        // Tenta carregar do cache
        if let cachedData = await cacheManager.load([EncodableCharacter].self, forKey: cacheKey),
           !(await cacheManager.isExpired(forKey: cacheKey)) {
            return cachedData.map { $0.toCharacter() }
        }

        // Busca na API
        let results = try await service.searchCharacters(query: trimmedQuery, offset: offset, limit: limit)

        // Salva no cache
        if !results.isEmpty {
            let encodableResults = results.map(EncodableCharacter.init(from:))
            await cacheManager.save(encodableResults, forKey: cacheKey)
            await cacheManager.setExpirationDate(Date().addingTimeInterval(3600), forKey: cacheKey)
        }

        return results
    }
}

// MARK: - Busca de Quadrinhos com Cache
public final class SearchComicsWithCacheUseCase: Sendable {
    private let service: ComicVineServiceProtocol
    private let cacheManager: CacheManagerProtocol
    private let cacheKey = "search_comics_"

    public init(service: ComicVineServiceProtocol, cacheManager: CacheManagerProtocol? = nil) {
        self.service = service
        self.cacheManager = cacheManager ?? CacheManager.shared
    }

    public func execute(query: String, offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        let cacheKey = "\(self.cacheKey)\(trimmedQuery)_\(offset)_\(limit)"

        // Tenta carregar do cache
        if let cachedData = await cacheManager.load([EncodableComic].self, forKey: cacheKey),
           !(await cacheManager.isExpired(forKey: cacheKey)) {
            return cachedData.map { $0.toComic() }
        }

        // Busca na API
        let results = try await service.searchComics(query: trimmedQuery, offset: offset, limit: limit)

        // Salva no cache
        if !results.isEmpty {
            let encodableResults = results.map(EncodableComic.init(from:))
            await cacheManager.save(encodableResults, forKey: cacheKey)
            await cacheManager.setExpirationDate(Date().addingTimeInterval(3600), forKey: cacheKey)
        }

        return results
    }
}
