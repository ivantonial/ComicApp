//
//  CharacterListSearchUseCase.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import ComicVineAPI
import Foundation

public final class CharacterListSearchUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(query: String, offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        return try await service.searchCharacters(query: query, offset: offset, limit: limit)
    }
}
