//
//  SearchCharactersUseCase.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import Foundation

/// Caso de uso responsável por executar buscas de personagens.
public final class SearchCharactersUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    public func execute(query: String, limit: Int = 20) async throws -> [Character] {
        // Busca personagens na API Marvel
        let characters = try await service.fetchCharacters(offset: 0, limit: limit)
        return characters.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}
