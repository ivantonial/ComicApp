//
//  FetchCharacterDetailUseCase.swift.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import Foundation

public final class FetchCharacterDetailUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(characterId: Int) async throws -> Character {
        let response = try await service.fetchCharacter(by: characterId)
        return response
    }
}
