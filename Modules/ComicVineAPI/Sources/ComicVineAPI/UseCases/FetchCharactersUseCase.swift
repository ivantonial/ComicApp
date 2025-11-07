//
//  FetchCharactersUseCase.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import Foundation

/// Use Case para buscar lista de personagens
public final class FetchCharactersUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(offset: Int = 0, limit: Int = 20) async throws -> [Character] {
        try await service.fetchCharacters(offset: offset, limit: limit)
    }
}

/// Use Case para buscar lista de quadrinhos
public final class FetchComicsUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(offset: Int = 0, limit: Int = 20) async throws -> [Comic] {
        try await service.fetchIssues(offset: offset, limit: limit)
    }
}
