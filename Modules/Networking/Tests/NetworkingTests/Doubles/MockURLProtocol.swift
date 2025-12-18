//
//  MockURLProtocol.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Mock do URLProtocol para interceptar requisições HTTP em testes de integração.
//  Implementado com actor storage para garantir thread-safety e conformidade com Swift 6 Concurrency.
//

import Alamofire
@testable import Networking
import Foundation

// MARK: - MockURLProtocolStorage

/// Actor para armazenamento thread-safe dos dados mockados do URLProtocol
public actor MockURLProtocolStorage {
    public static let shared = MockURLProtocolStorage()

    // MARK: - Properties

    /// Dados mockados a serem retornados
    public var mockData: Data?

    /// Erro mockado a ser retornado
    public var mockError: Error?

    /// Código de status HTTP mockado
    public var mockStatusCode: Int = 200

    /// Headers mockados para a resposta
    public var mockHeaders: [String: String]?

    // MARK: - Initialization

    private init() {}

    // MARK: - Setters

    public func setMockData(_ data: Data?) {
        mockData = data
    }

    public func setMockError(_ error: Error?) {
        mockError = error
    }

    public func setMockStatusCode(_ code: Int) {
        mockStatusCode = code
    }

    public func setMockHeaders(_ headers: [String: String]?) {
        mockHeaders = headers
    }

    // MARK: - Getters

    public func getMockData() -> Data? {
        mockData
    }

    public func getMockError() -> Error? {
        mockError
    }

    public func getMockStatusCode() -> Int {
        mockStatusCode
    }

    public func getMockHeaders() -> [String: String]? {
        mockHeaders
    }

    // MARK: - Reset

    /// Reseta todos os valores mockados para o estado inicial
    public func reset() {
        mockData = nil
        mockError = nil
        mockStatusCode = 200
        mockHeaders = nil
    }
}

// MARK: - MockURLProtocol

/// URLProtocol customizado para interceptar requisições HTTP em testes
public class MockURLProtocol: URLProtocol, @unchecked Sendable {

    // MARK: - URLProtocol Overrides

    override public class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override public func startLoading() {
        guard let client = self.client, let url = request.url else {
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            Task { @MainActor in
                let storage = MockURLProtocolStorage.shared

                if let error = await storage.getMockError() {
                    client.urlProtocol(self, didFailWithError: error)
                } else {
                    let statusCode = await storage.getMockStatusCode()
                    let headers = await storage.getMockHeaders()

                    let response = HTTPURLResponse(
                        url: url,
                        statusCode: statusCode,
                        httpVersion: "HTTP/1.1",
                        headerFields: headers
                    )!

                    client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

                    if let data = await storage.getMockData() {
                        client.urlProtocol(self, didLoad: data)
                    }

                    client.urlProtocolDidFinishLoading(self)
                }
            }
        }
    }

    override public func stopLoading() {
        // Nenhuma ação necessária para parar o carregamento mockado
    }
}

// MARK: - MockSessionFactory

/// Factory para criar sessões Alamofire configuradas com MockURLProtocol
public struct MockSessionFactory {

    /// Cria uma sessão Alamofire configurada para usar MockURLProtocol
    public static func createMockSession() -> Session {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        return Session(
            configuration: config,
            delegate: SessionDelegate(),
            rootQueue: DispatchQueue(label: "mock.session.rootQueue"),
            startRequestsImmediately: true
        )
    }
}

// MARK: - Convenience Configuration Methods

extension MockURLProtocolStorage {

    /// Configura o storage para simular uma resposta de sucesso com JSON
    public func configureSuccessResponse<T: Encodable>(with object: T, statusCode: Int = 200) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        setMockData(data)
        setMockStatusCode(statusCode)
        setMockError(nil)
        setMockHeaders(["Content-Type": "application/json"])
    }

    /// Configura o storage para simular um erro de rede
    public func configureNetworkError(_ error: Error) async {
        setMockData(nil)
        setMockError(error)
    }

    /// Configura o storage para simular um erro HTTP
    public func configureHTTPError(statusCode: Int, message: String? = nil) async throws {
        let errorBody: [String: String]
        if let message = message {
            errorBody = ["error": message]
        } else {
            errorBody = ["error": "HTTP Error \(statusCode)"]
        }

        let encoder = JSONEncoder()
        let data = try encoder.encode(errorBody)

        setMockData(data)
        setMockStatusCode(statusCode)
        setMockError(nil)
    }

    /// Configura o storage para simular uma resposta vazia
    public func configureEmptyResponse(statusCode: Int = 204) async {
        setMockData(nil)
        setMockStatusCode(statusCode)
        setMockError(nil)
    }
}
