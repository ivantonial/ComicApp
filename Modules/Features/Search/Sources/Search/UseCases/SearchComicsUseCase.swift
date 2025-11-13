//
//  SearchComicsUseCase.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import ComicVineAPI
import Foundation

public protocol SearchComicsUseCase {
    func searchComics(query: String, limit: Int, offset: Int) async throws -> [Comic]
}

public final class SearchComicsUseCaseImpl: SearchComicsUseCase {
    private let comicVineService: ComicVineAPIService

    public init(comicVineService: ComicVineAPIService) {
        self.comicVineService = comicVineService
    }

    public func searchComics(query: String, limit: Int, offset: Int) async throws -> [Comic] {
        try await comicVineService.searchComics(
            query: query,
            offset: offset,
            limit: limit
        )
    }
}
