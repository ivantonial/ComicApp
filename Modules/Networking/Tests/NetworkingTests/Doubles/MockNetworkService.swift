//
//  MockNetworkService.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Mock do NetworkServiceProtocol para testes isolados.
//  Implementado como classe final com @unchecked Sendable para compatibilidade
//  com o protocolo NetworkServiceProtocol que usa APIEndpoint (não-Sendable).
//

import Alamofire
@testable import Networking
import Foundation

// MARK: - MockNetworkService

/// Mock thread-safe do NetworkServiceProtocol
/// Permite simular diferentes cenários de resposta sem fazer requisições reais
public final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    // MARK: - Properties

    /// Resultado mockado a ser retornado pelas requisições
    public var mockResult: Result<Any, Error>?

    /// Contador de chamadas para verificação em testes
    public private(set) var requestCallCount: Int = 0

    /// Último endpoint chamado para verificação em testes
    public private(set) var lastRequestedEndpoint: (any APIEndpoint)?

    /// Delay simulado para requisições (em segundos)
    public var simulatedDelay: TimeInterval = 0

    /// Queue para sincronização thread-safe
    private let queue = DispatchQueue(label: "com.comicapp.mocknetworkservice")

    // MARK: - Initialization

    public init() {}

    // MARK: - Configuration Methods

    /// Configura o mock para retornar sucesso com o valor especificado
    public func setSuccessResult<T>(_ value: T) {
        queue.sync {
            mockResult = .success(value)
        }
    }

    /// Configura o mock para retornar o erro especificado
    public func setFailureResult(_ error: Error) {
        queue.sync {
            mockResult = .failure(error)
        }
    }

    /// Reseta o estado do mock para valores iniciais
    public func reset() {
        queue.sync {
            mockResult = nil
            requestCallCount = 0
            lastRequestedEndpoint = nil
            simulatedDelay = 0
        }
    }

    // MARK: - NetworkServiceProtocol

    public func request<T: Decodable & Sendable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        queue.sync {
            requestCallCount += 1
            lastRequestedEndpoint = endpoint
        }

        // Simula delay se configurado
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }

        let result: Result<Any, Error>? = queue.sync {
            mockResult
        }

        guard let result = result else {
            throw NetworkError.noData
        }

        switch result {
        case .success(let data):
            if let typedData = data as? T {
                return typedData
            } else {
                throw NetworkError.decodingError(
                    NSError(
                        domain: "MockNetworkServiceError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Type mismatch in mock response"]
                    )
                )
            }
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Convenience Extensions

extension MockNetworkService {

    /// Configura o mock para simular erro de URL inválida
    public func simulateInvalidURL() {
        setFailureResult(NetworkError.invalidURL)
    }

    /// Configura o mock para simular erro de servidor com código
    public func simulateServerError(code: Int) {
        setFailureResult(NetworkError.serverErrorCode(code))
    }

    /// Configura o mock para simular erro de servidor com mensagem
    public func simulateServerError(message: String) {
        setFailureResult(NetworkError.serverErrorMessage(message))
    }

    /// Configura o mock para simular erro de decodificação
    public func simulateDecodingError() {
        let error = NSError(
            domain: "DecodingError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"]
        )
        setFailureResult(NetworkError.decodingError(error))
    }

    /// Configura o mock para simular erro de não autorizado
    public func simulateUnauthorized() {
        setFailureResult(NetworkError.unauthorized)
    }

    /// Configura o mock para simular erro de não encontrado
    public func simulateNotFound() {
        setFailureResult(NetworkError.notFound)
    }

    /// Configura o mock para simular ausência de dados
    public func simulateNoData() {
        queue.sync {
            mockResult = nil
        }
    }
}
