//
//  NetworkService.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import Alamofire
import Foundation

/// Implementação do serviço de rede usando Alamofire
@available(iOS 16.0, *)
public final class NetworkService: NetworkServiceProtocol, @unchecked Sendable {

    private let session: Session
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "com.comicapp.networkservice")

    public init(session: Session = .default) {
        self.session = session
        self.decoder = JSONDecoder()
        // REMOVIDO: decoder.keyDecodingStrategy = .convertFromSnakeCase
        // A API da ComicVine usa mapeamento manual através de CodingKeys
        // Manter a estratégia padrão para evitar conflitos
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint,
                                                responseType: T.Type) async throws -> T {

        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            session.request(url,
                            method: endpoint.method,
                            parameters: endpoint.parameters,
                            encoding: endpoint.encoding,
                            headers: endpoint.headers)
            .validate()
            .responseData(queue: queue) { response in
                switch response.result {
                case .success(let data):
                    do {
                        #if DEBUG
                        // Log para debug em caso de erro de decodificação
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📡 JSON Response (first 500 chars):", String(jsonString.prefix(500)))
                        }
                        #endif

                        let decodedObject = try self.decoder.decode(T.self, from: data)
                        continuation.resume(returning: decodedObject)
                    } catch {
                        #if DEBUG
                        print("❌ Erro de decodificação: \(error)")
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .keyNotFound(let key, let context):
                                print("   🔑 Chave não encontrada: '\(key.stringValue)'")
                                print("   📍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                            case .typeMismatch(let type, let context):
                                print("   ⚠️ Tipo incorreto. Esperado: \(type)")
                                print("   📍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                            case .valueNotFound(let type, let context):
                                print("   ❓ Valor não encontrado para tipo: \(type)")
                                print("   📍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                            case .dataCorrupted(let context):
                                print("   💔 Dados corrompidos")
                                print("   📍 Caminho: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                            @unknown default:
                                print("   ❌ Erro desconhecido")
                            }
                        }
                        #endif
                        continuation.resume(throwing: NetworkError.decodingError(error))
                    }

                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        continuation.resume(throwing: NetworkError.serverErrorCode(statusCode))
                    } else {
                        continuation.resume(throwing: NetworkError.unknown(error))
                    }
                }
            }
        }
    }
}
