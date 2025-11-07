//
//  NetworkError.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case serverErrorMessage(String)
    case serverErrorCode(Int)
    case decodingError(Error)
    case unknown(Error)
    case noData
    case unauthorized
    case notFound

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .serverErrorMessage(let message):
            return "Erro do servidor: \(message)"
        case .serverErrorCode(let code):
            return "Erro do servidor: Código \(code)"
        case .decodingError(let error):
            return "Erro de decodificação: \(error.localizedDescription)"
        case .unknown(let error):
            return "Erro desconhecido: \(error.localizedDescription)"
        case .noData:
            return "Nenhum dado recebido"
        case .unauthorized:
            return "Não autorizado"
        case .notFound:
            return "Recurso não encontrado"
        }
    }
}
