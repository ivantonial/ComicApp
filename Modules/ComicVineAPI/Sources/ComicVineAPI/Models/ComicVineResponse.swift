//
//  ComicVineResponse.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation

// MARK: - ComicVine API Response Structure
public struct ComicVineResponse<T: Decodable & Sendable>: Decodable, Sendable {
    public let error: String
    public let statusCode: Int
    public let limit: Int
    public let offset: Int
    public let numberOfPageResults: Int
    public let numberOfTotalResults: Int
    public let results: [T]

    enum CodingKeys: String, CodingKey {
        case error
        case statusCode = "status_code"
        case limit
        case offset
        case numberOfPageResults = "number_of_page_results"
        case numberOfTotalResults = "number_of_total_results"
        case results
    }

    // MARK: - Custom Decoder para melhor tratamento de erros
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.error = try container.decode(String.self, forKey: .error)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.limit = try container.decode(Int.self, forKey: .limit)
        self.offset = try container.decode(Int.self, forKey: .offset)
        self.numberOfPageResults = try container.decode(Int.self, forKey: .numberOfPageResults)
        self.numberOfTotalResults = try container.decode(Int.self, forKey: .numberOfTotalResults)

        // Tenta decodificar results - pode ser array ou objeto único
        do {
            // Primeiro tenta como array (para listas de characters/comics)
            self.results = try container.decode([T].self, forKey: .results)
            #if DEBUG
            print("✅ Decodificado como array com \(self.results.count) elementos")
            #endif
        } catch {
            // Se falhar, tenta como objeto único (para character/issue detail)
            do {
                let singleResult = try container.decode(T.self, forKey: .results)
                self.results = [singleResult]
                #if DEBUG
                print("📋 Decodificado objeto único como array para tipo: \(T.self)")
                #endif
            } catch let decodingError {
                #if DEBUG
                print("❌ Erro ao decodificar results:")
                if let error = decodingError as? DecodingError {
                    switch error {
                    case .typeMismatch(let type, let context):
                        print("   ⚠️ Tipo incorreto. Esperado: \(type)")
                        print("   🔍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .keyNotFound(let key, let context):
                        print("   🔑 Chave não encontrada: \(key)")
                        print("   🔍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    default:
                        print("   ⚠️ Erro de decodificação: \(error)")
                    }
                }
                #endif
                throw decodingError
            }
        }
    }
}

// MARK: - Response Validation Extension
public extension ComicVineResponse {
    /// Verifica se a resposta da API foi bem-sucedida
    var isSuccess: Bool {
        return statusCode == 1 && error == "OK"
    }

    /// Retorna uma mensagem de erro formatada se houver erro
    var errorMessage: String? {
        guard !isSuccess else { return nil }
        return "ComicVine API Error (Code: \(statusCode)): \(error)"
    }

    /// Retorna o primeiro resultado se houver (útil para detail endpoints)
    var firstResult: T? {
        return results.first
    }
}
