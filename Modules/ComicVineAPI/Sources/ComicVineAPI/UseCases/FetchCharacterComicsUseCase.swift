//
//  FetchCharacterComicsUseCase.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import Foundation

public final class FetchCharacterComicsUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(characterId: Int, offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        return try await service.fetchCharacterComics(
            characterId: characterId,
            offset: offset,
            limit: limit
        )
    }
}
