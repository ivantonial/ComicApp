//
//  FetchIssuesByIdsUseCase.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 12/11/25.
//

import Foundation

public final class FetchIssuesByIdsUseCase: Sendable {
    private let service: ComicVineServiceProtocol

    public init(service: ComicVineServiceProtocol) {
        self.service = service
    }

    /// Busca múltiplas issues pelos seus IDs
    /// - Parameters:
    ///   - issueIds: Array com os IDs das issues a serem buscadas
    ///   - batchSize: Tamanho do lote para requisições paralelas (default: 5)
    /// - Returns: Array de Comics com os detalhes das issues
    public func execute(issueIds: [Int], batchSize: Int = 5) async throws -> [Comic] {
        guard !issueIds.isEmpty else { return [] }

        var allComics: [Comic] = []

        // Processar em lotes para evitar sobrecarga de requisições
        for batch in issueIds.chunked(into: batchSize) {
            // Buscar issues em paralelo dentro do lote
            let comics = await withTaskGroup(of: Comic?.self) { group in
                for issueId in batch {
                    group.addTask { [weak self] in
                        guard let self = self else { return nil }
                        do {
                            return try await self.service.fetchIssue(by: issueId)
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

            // Pequeno delay entre lotes para respeitar rate limits da API
            if batch != issueIds.chunked(into: batchSize).last {
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 segundos
            }
        }

        // Ordenar por data de lançamento (mais recentes primeiro)
        return allComics.sorted { first, second in
            // Assumindo que coverDate pode ser nil
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
